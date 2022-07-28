//
//  Printer.m
//  StarPrinter
//
//  Created by Shailesh Lolam on 11/3/17.
//  Copyright © 2017 Shailesh Lolam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Printer.h"
#import "BarcodeReader.h"
#import <StarIO/SMPort.h>

@class Receipt;

@implementation PrinterQueue

static dispatch_queue_attr_t queueAttributes;

-(id) initWithName: (NSString*) name {
    self = [super init];
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        queueAttributes = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, 0);
    });
    
    self.queue = dispatch_queue_create([name UTF8String], queueAttributes);
    return self;
}

@end

@implementation Printer {
    int timeout;
}

//fields
static int CONNECTION_TIMEOUT = 10000;

static NSLock * lock;
static NSMutableDictionary * printerQueues;

//Properties
@synthesize portName;

@synthesize macAddress;

@synthesize modelName;

-(id) initWithPort: (NSString *) portName{
    self = [super init];
    if(self != nil) {
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            lock = [[NSLock alloc] init];
            printerQueues = [[NSMutableDictionary<NSString*, PrinterQueue*> alloc] init];
        });
        self.portName = portName;
        timeout = 30000;
        return self;
    }
    return nil;
}

-(void) setTimeout: (int) timeout{
    self->timeout = timeout;
}


-(void) createReceiptText: (bool) text PaperSize: (int) paperSize Handler: (void (^)(Receipt *)) completeBlock; {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        Receipt *receipt = [Receipt createReceiptFromText:text Language:LanguageEnglish AndPaperSize:paperSize];
        [receipt setFont:[UIFont fontWithName:self.fontName size:self.fontSize]];
        completeBlock(receipt);
    });
}

-(PrinterStatus *) getStatus{
    PrinterStatus *status = [[PrinterStatus alloc] init];
    SMPort * port = nil;
    NSError *error = nil;
    @try{
        
        port = [SMPort getPort:portName :@"" :CONNECTION_TIMEOUT :&error];
        
        StarPrinterStatus_2 printerStatus;
        
        [port beginCheckedBlock:&printerStatus :2 : &error];
        
        status.offline = printerStatus.offline;
        status.paperJam = printerStatus.presenterPaperJamError;
        status.outOfPaper = printerStatus.receiptPaperEmpty;
    }
    @catch(PortException *ex){
        status.offline = TRUE;
    }
    if(port != nil){
        [SMPort releasePort:port];
    }
    return status;
}

-(void) printReceipt: (Receipt *) receipt withDelay: (float) delay andRetry: (int) retry onSuccess: (void (^) (PrinterStatus *)) successBlock onFail: (void (^)(PrinterStatus *)) failedBlock {
    //Assign delay to at least a second
    if(delay < 0.5) {
        delay = 0.5;
    } else if (delay > 2.5) {
        delay = 2.5;
    }

    
    [lock lock];
    PrinterQueue * printerQueue = [printerQueues valueForKey:portName];
    if(!printerQueue) {
        printerQueue = [[PrinterQueue alloc] initWithName:portName];
        [printerQueues setObject:printerQueue forKey:portName];
        NSLog(@"Create new work queue %@", portName);
    }
    [lock unlock];
    
    //Dispatch immediately on background thread on printer queue
    dispatch_async(printerQueue.queue, ^{
        NSLog(@"Attempting to print first time with delay = %f and pending retry = %d", delay, retry);
        [Printer retryPrint:receipt onPort:self->portName withTimeout:self->timeout withDelay:delay andRetry:retry onSuccess:successBlock onFail:failedBlock];
    });
}


+(void) retryPrint: (Receipt *) receipt onPort: (NSString*) portName withTimeout:(int) timeout withDelay: (float) delay andRetry: (int) retry onSuccess: (void (^) (PrinterStatus *)) successBlock onFail: (void (^)(PrinterStatus *)) failedBlock {
    
    PrinterStatus *result = [[PrinterStatus alloc] init];
    
    [receipt closeReceipt];
    
    uint32_t commandLength = (uint32_t) receipt.builder.commands.length;
    
    unsigned char *commandsBytes = (unsigned char *) receipt.builder.commands.bytes;
    BOOL sharedPort = BarcodeScanner.scanner && [portName isEqualToString:BarcodeScanner.scanner.port.portName];
    SMPort * port = nil;
    NSError *error = nil;

    //Retry retry times with an interval of delay in ms
    do {
        
        @try {
            if(sharedPort) {
                port = BarcodeScanner.scanner.port;
                [BarcodeScanner.scanner.manager.lock lock];
            } else {
                port = [SMPort getPort:portName :@"" :CONNECTION_TIMEOUT :&error];
            }
            while (YES) {
                if (port == nil) {
                    result.error = [[NSString alloc] initWithFormat:@"Could not connect to the printer %@,", portName];
                    break;
                }
                
                // Sleep to avoid a problem which sometimes cannot communicate with Bluetooth.
                // (Refer Readme for details)
                //NSOperatingSystemVersion version = {11, 0, 0};
                //BOOL isOSVer11OrLater = [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:version];
                BOOL isBluetoothPrinter = [portName.uppercaseString hasPrefix:@"BT:"];
                //if (isOSVer11OrLater && isBluetoothPrinter) {
                if (isBluetoothPrinter) {
                    [NSThread sleepForTimeInterval:0.2];
                }
                
                StarPrinterStatus_2 printerStatus;
                
                [port beginCheckedBlock:&printerStatus :2 :&error];
                
                if (printerStatus.offline == SM_TRUE) {
                    result.offline = printerStatus.offline;
                    result.paperJam = printerStatus.presenterPaperJamError;
                    result.outOfPaper = printerStatus.receiptPaperEmpty;
                    result.error = [[NSString alloc] initWithFormat:@"Printer %@ seems to be offline", portName];
                    break;
                }
                
                NSDate *startDate = [NSDate date];
                
                uint32_t total = 0;
                
                while (total < commandLength) {
                    
                    uint32_t written = [port writePort:commandsBytes :total :commandLength - total: &error];
                    
                    total += written;
                    
                    if ([[NSDate date] timeIntervalSinceDate:startDate] >= timeout / 1000.0) {     // 30000mS!!!
                        
                        break;
                    }
                }
                
                if (total < commandLength) {
                    result.error = [[NSString alloc] initWithFormat:@"Timed out while printing to the printer %@", portName];
                    NSLog(@"%@", result.error);
                    break;
                }
                
                port.endCheckedBlockTimeoutMillis = timeout;     // 30000mS!!!
                
                //if (isBluetoothPrinter) {
                //    [NSThread sleepForTimeInterval:0.3];
                //}
                
                [port endCheckedBlock:&printerStatus :2 :&error];
                
                if (printerStatus.offline == SM_TRUE) {
                    result.offline = printerStatus.offline;
                    result.paperJam = printerStatus.presenterPaperJamError;
                    result.outOfPaper = printerStatus.receiptPaperEmpty;
                    result.error = [[NSString alloc] initWithFormat:@"Printer %@ went offline while printing", portName];
                    break;
                }
                
                result.printed = true;
                
//                if(!sharedPort) {
//                    [port disconnect];
//                }
                
                break;
            } // END of WHILE
        } @catch (NSException *exc) {
            result.error = [[NSString alloc] initWithFormat:@"Exception occurred on printing on port %@\n %@: %@", portName, exc.name, exc.reason];
            NSLog(@"%@", result.error);
        } // END of CATCH
        @finally {
            if(sharedPort) {
                [BarcodeScanner.scanner.manager.lock unlock];
            } else if(port != nil){
                @try{
                    [SMPort releasePort:port];
                } @catch (NSException *exc) {
                    result.error = [[NSString alloc] initWithFormat:@"Exception occurred on closing %@\n %@: %@", portName, exc.name, exc.reason];
                    NSLog(@"%@", result.error);
                }
                port = nil;
            }
        } // END of FINALLY
        
        if(result.printed) {
            // dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Printed successfully delay = %f and retry = %d", delay, retry);
                successBlock (result);
            // });
            return;
        }
        if(retry > 0) {
            [NSThread sleepForTimeInterval: delay];
            NSLog(@"Attempting to retry printing with delay = %f and pending retry = %d", delay, retry);
        }
        retry--;
    } while(retry > 0);//END of DO-WHILE
    
    // dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Failed to print delay = %f and pending retry = %d", delay, retry);
        failedBlock (result);
    // });
}

+ (void) searchPrinters: (void(^)(NSArray<PrinterInfo *> *)) completeBlock {
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSMutableArray<PrinterInfo *> *retVal = [[NSMutableArray<PrinterInfo *> alloc] init];
        NSError *error = nil;
        NSArray *portInfoArray = [SMPort searchPrinter:@"ALL:" :&error];
        if (portInfoArray != nil) {
            for (PortInfo *portInfo in portInfoArray) {
                [retVal addObject:[[PrinterInfo alloc] initWithPortName:portInfo.portName
                                                             macAddress:portInfo.macAddress
                                                              modelName:portInfo.modelName]];
            }
        } else {
            NSLog(@"Error searching the printers %@", error.debugDescription);
        }
        completeBlock (retVal);
    });
    
}

+ (Printer *) getPrinter:(NSString *)portName timeout:(int)timeout {
    NSLog(@"Connecting to the printer at %@", portName);
    Printer *printer = [[Printer alloc] initWithPort:portName];
    if(printer) {
        printer.fontName = @"Menlo";
        printer.fontSize = 24.5;
        [printer setTimeout:timeout];
    }
    return printer;
}
@end






@implementation PrinterInfo
- (id)initWithPortName:(NSString *)portName_ macAddress:(NSString *)macAddress_ modelName:(NSString *)modelName_{
    self = [super init];
    if(self != nil){
        self.portName = portName_;
        self.macAddress = macAddress_;
        self.modelName = modelName_;
    }
    return self;
}

@synthesize portName;
@synthesize macAddress;
@synthesize modelName;
@end

@implementation PrinterStatus: NSObject
@synthesize offline;
@synthesize outOfPaper;
@synthesize paperJam;
@end

//
//  Printer.h
//  StarPrinter
//
//  Created by Shailesh Lolam on 11/3/17.
//  Copyright © 2017 Shailesh Lolam. All rights reserved.
//

#ifndef Printer_h

#define Printer_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Receipt.h"

@interface PrinterInfo: NSObject
- (id)initWithPortName:(NSString *)portName_ macAddress:(NSString *)macAddress_ modelName:(NSString *)modelName_;

@property(retain, readonly) NSString *portName;
@property(retain, readonly) NSString *macAddress;
@property(retain, readonly) NSString *modelName;

@end

@interface PrinterInfo()
@property(retain) NSString *portName;
@property(retain) NSString *macAddress;
@property(retain) NSString *modelName;
@end

@interface PrinterStatus: NSObject
@property (readonly) bool offline;
@property (readonly) bool outOfPaper;
@property (readonly) bool paperJam;
@property (readonly) bool printed;
@property (readonly) NSString* error;
@end

@interface PrinterStatus()
@property bool offline;
@property bool outOfPaper;
@property bool paperJam;
@property bool printed;
@property NSString* error;
@end

@interface Printer : NSObject

-(instancetype) init __attribute__((unavailable("init not available")));

+ (void) searchPrinters: (void(^)(NSArray<PrinterInfo *> *)) completeBlock;

+ (Printer *) getPrinter: (NSString *) portName timeout: (int) timeout;

-(PrinterStatus *) getStatus;

-(void) printReceipt: (Receipt *) receipt withDelay: (float) delay andRetry: (int) retry onSuccess: (void (^) (PrinterStatus *)) successBlock onFail: (void (^)(PrinterStatus *)) failedBlock;

-(void) createReceiptText: (bool) text PaperSize: (int) paperSize Handler: (void (^)(Receipt *)) completeBlock;

@property (retain, readonly) NSString* portName;

@property (retain, readonly) NSString* modelName;

@property (retain, readonly) NSString* macAddress;

@property (atomic) NSString *fontName;

@property (atomic) int fontSize;
@end

@interface Printer()
@property(retain) NSString *portName;
@property(retain) NSString *macAddress;
@property(retain) NSString *modelName;
@end


@interface PrinterQueue: NSObject
    @property (retain) dispatch_queue_t queue;
@end
#endif /* Printer_h */

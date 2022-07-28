#import "StarprinterPlugin.h"
#import "Printer.h"
#import "Receipt.h"
#import "BarcodeReader.h"

@implementation PrinterReceipt
@synthesize printer;
@synthesize receipt;
-(id) initWithPrinter: (Printer*) printer {
    self = [super init];

    self.printer = printer;
    return self;
}
@end


@implementation StarprinterPlugin
NSDictionary *printerReceipts;
BarcodeScanner *barcodeReader;
FlutterMethodChannel* channel;
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    printerReceipts = [[NSMutableDictionary<NSString*,PrinterReceipt*> alloc]init];
  channel = [FlutterMethodChannel
      methodChannelWithName:@"getzuza.starprinter"
            binaryMessenger:[registrar messenger]];
  StarprinterPlugin* instance = [[StarprinterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}


- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    if ([call.method  isEqual: @"searchPrinters"]) {
        [Printer searchPrinters:^(NSArray<PrinterInfo *> *searchData) {
            
            NSMutableArray *printers = [[NSMutableArray alloc] init];
            
            for (PrinterInfo *printer in searchData) {
                [printers addObject:@{
                    @"modelName": printer.modelName,
                    @"macAddress": printer.macAddress,
                    @"portName": printer.portName
                }];
            }
            result(printers);
        }];
    } else if ([call.method  isEqual: @"getPrinter"]){
        NSString *portName = call.arguments[@"portName"];
        NSNumber *timeOut = call.arguments[@"timeOut"];

        Printer *printer = [Printer getPrinter:portName timeout:[timeOut intValue]];
        PrinterReceipt *printerReceipt = [[PrinterReceipt alloc] initWithPrinter:printer];
        [printerReceipts setValue:printerReceipt forKey:portName];
        result(portName);

    } else if ([call.method  isEqual: @"createReceipt"]){
        NSString *portName = call.arguments[@"portName"];
        bool textValue = call.arguments[@"text"];
        NSNumber *paperSize = call.arguments[@"paperSize"];

        PrinterReceipt *printerReceipt = [printerReceipts objectForKey:portName];
        [printerReceipt.printer createReceiptText:textValue PaperSize:[paperSize intValue] Handler:^(Receipt *receipt) {
            printerReceipt.receipt = receipt;
            result(portName);
        }];

    } else if ([call.method  isEqual: @"addAlignLeft"]){
        NSString *portName = call.arguments[@"portName"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        [receipt.receipt addAlignLeft];
        result(nil);

    } else if([call.method  isEqual: @"addAlignRight"]){
        NSString *portName = call.arguments[@"portName"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        [receipt.receipt addAlignRight];
        result(nil);

    } else if ([call.method  isEqual: @"addAlignCenter"]){
        NSString *portName = call.arguments[@"portName"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        [receipt.receipt addAlignCenter];
        result(nil);

    } else if ([call.method  isEqual: @"setBlackColor"]){
        NSString *portName = call.arguments[@"portName"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        [receipt.receipt setBlackColor];
        result(nil);

    } else if ([call.method  isEqual: @"setRedColor"]){
        NSString *portName = call.arguments[@"portName"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        [receipt.receipt setRedColor];
        result(nil);

    } else if ([call.method  isEqual: @"addText"]){
        NSString *portName = call.arguments[@"portName"];
        NSString *value = call.arguments[@"value"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        [receipt.receipt addText:value];
        result(nil);

    } else if ([call.method  isEqual: @"addDoubleText"]){
        NSString *portName = call.arguments[@"portName"];
        NSString *value = call.arguments[@"value"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        [receipt.receipt addDoubleText:value];
        result(nil);

    } else if ([call.method  isEqual: @"addBoldText"]){
        NSString *portName = call.arguments[@"portName"];
        NSString *value = call.arguments[@"value"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        [receipt.receipt addBoldText:value];
        result(nil);

    } else if ([call.method  isEqual: @"addUnderlinedText"]){
        NSString *portName = call.arguments[@"portName"];
        NSString *value = call.arguments[@"value"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        [receipt.receipt addUnderlinedText:value];
        result(nil);

    }else if ([call.method  isEqual: @"addInverseText"]){
        NSString *portName = call.arguments[@"portName"];
        NSString *value = call.arguments[@"value"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        [receipt.receipt addInverseText:value];
        result(nil);

    } else if ([call.method  isEqual: @"addLine"]){
        NSString *portName = call.arguments[@"portName"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        [receipt.receipt addLine];
        result(nil);

    } else if ([call.method  isEqual: @"addImage"]){
        NSString *portName = call.arguments[@"portName"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        FlutterStandardTypedData *imgBytes = call.arguments[@"bytes"];
        NSNumber *width = call.arguments[@"width"];
        UIImage *imageData = [UIImage imageWithData:imgBytes.data];
        [receipt.receipt addImage:imageData width:[width intValue]];
        result(nil);

    } else if ([call.method  isEqual: @"addBarcode"]){
        NSString *portName = call.arguments[@"portName"];
        NSString *value = call.arguments[@"value"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        NSNumber *height = call.arguments[@"height"];
        [receipt.receipt addBarcode:value height:[height intValue]];
        result(nil);

    } else if ([call.method  isEqual: @"addQrCode"]){
        NSString *portName = call.arguments[@"portName"];
        NSString *value = call.arguments[@"value"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        [receipt.receipt addQrCode:value];
        result(nil);
        
    } else if ([call.method  isEqual: @"openCashDrawer"]){
        NSString *portName = call.arguments[@"portName"];
        NSNumber *drawer = call.arguments[@"drawer"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        [receipt.receipt openCashDrawer:[drawer intValue]];
        result(nil);
        
    } else if ([call.method  isEqual: @"cutPaper"]){
        NSString *portName = call.arguments[@"portName"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        [receipt.receipt cutPaper];
        result(nil);
        
    } else if ([call.method  isEqual: @"closeReceipt"]){
        NSString *portName = call.arguments[@"portName"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        [receipt.receipt closeReceipt];
        result(nil);
        
    } else if ([call.method  isEqual: @"setCommand"]){
        NSString *portName = call.arguments[@"portName"];
        NSString *command = call.arguments[@"command"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        [receipt.receipt setCommand:command];
        result(nil);
        
    } else if ([call.method  isEqual: @"setFontSize"]){
        NSString *portName = call.arguments[@"portName"];
        NSNumber *size = call.arguments[@"size"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        [receipt.receipt setFontSize: [size doubleValue]];
        result(nil);
        
    } else if ([call.method  isEqual: @"printReceipt"]){
        NSString *portName = call.arguments[@"portName"];
        NSNumber *delay = call.arguments[@"delay"];
        NSNumber *retry = call.arguments[@"retry"];
        NSLog(@"printReceipt called");
        PrinterReceipt *printer = [printerReceipts objectForKey:portName];
        [printer.printer printReceipt:printer.receipt withDelay:[delay doubleValue] andRetry:[retry intValue] onSuccess:^(PrinterStatus *printerStatus) {
            NSDictionary *status = @{
                @"offline": [NSNumber numberWithBool:printerStatus.offline],
                @"error": printerStatus.error,
                @"outOfPaper": [NSNumber numberWithBool: printerStatus.outOfPaper],
                @"paperJam": [NSNumber numberWithBool: printerStatus.paperJam],
                @"printed": [NSNumber numberWithBool: printerStatus.printed]
            };
            result(status);
        } onFail:^(PrinterStatus *printerStatus) {
            NSDictionary *status = @{
                @"offline": [NSNumber numberWithBool:printerStatus.offline],
                @"error": printerStatus.error,
                @"outOfPaper": [NSNumber numberWithBool: printerStatus.outOfPaper],
                @"paperJam": [NSNumber numberWithBool: printerStatus.paperJam],
                @"printed": [NSNumber numberWithBool: printerStatus.printed]
            };
            result(status);
        }];
    } else if ([call.method  isEqual: @"connect"]){
        NSString *portName = call.arguments[@"portName"];
        barcodeReader = [[BarcodeScanner alloc] initWithPortName:portName];
        [barcodeReader setBarcodeScanner:^(NSString *code) {
            NSMutableDictionary<NSString*,NSString*> *data =  [[NSMutableDictionary<NSString*,NSString*> alloc]init];
            [data setValue:code forKey:@"code"];
            [channel invokeMethod:@"onBarcodeRead" arguments:data];
        }];
        result(nil);
    } else if ([call.method  isEqual: @"disconnect"]){
        NSString *portName = call.arguments[@"portName"];
        [barcodeReader disconnect];
        barcodeReader = nil;
        result(nil);
    } else {

    }
}

@end

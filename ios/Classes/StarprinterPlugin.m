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
            NSData *data = [NSJSONSerialization dataWithJSONObject:searchData options:0 error:nil];

            NSString *searchPrinters = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            result(searchPrinters);
        }];
    } else if ([call.method  isEqual: @"getPrinter"]){
        NSString *portName = call.arguments[@"portName"];
        int timeOut = call.arguments[@"timeOut"];

        Printer *printer = [Printer getPrinter:portName timeout:timeOut];
        PrinterReceipt *printerReceipt = [[PrinterReceipt alloc] initWithPrinter:printer];
        [printerReceipts setValue:printerReceipt forKey:portName];
        result(portName);

    } else if ([call.method  isEqual: @"createReceipt"]){
        NSString *portName = call.arguments[@"portName"];
        bool textValue = call.arguments[@"text"];
        int paperSize = call.arguments[@"paperSize"];

        PrinterReceipt *printerReceipt = [printerReceipts objectForKey:portName];
        [printerReceipt.printer createReceiptText:textValue PaperSize:paperSize Handler:^(Receipt *receipt) {
            printerReceipt.receipt = receipt;
            result(portName);
        }];

    } else if ([call.method  isEqual: @"addAlignLeft"]){
        NSString *portName = call.arguments[@"portName"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        [receipt.receipt addAlignLeft];

    } else if([call.method  isEqual: @"addAlignRight"]){
        NSString *portName = call.arguments[@"portName"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        [receipt.receipt addAlignRight];

    } else if ([call.method  isEqual: @"addAlignCenter"]){
        NSString *portName = call.arguments[@"portName"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        [receipt.receipt addAlignCenter];

    } else if ([call.method  isEqual: @"setBlackColor"]){
        NSString *portName = call.arguments[@"portName"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        [receipt.receipt setBlackColor];

    } else if ([call.method  isEqual: @"setRedColor"]){
        NSString *portName = call.arguments[@"portName"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        [receipt.receipt setRedColor];

    } else if ([call.method  isEqual: @"addText"]){
        NSString *portName = call.arguments[@"portName"];
        NSString *value = call.arguments[@"value"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        [receipt.receipt addText:value];

    } else if ([call.method  isEqual: @"addDoubleText"]){
        NSString *portName = call.arguments[@"portName"];
        NSString *value = call.arguments[@"value"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        [receipt.receipt addDoubleText:value];

    } else if ([call.method  isEqual: @"addBoldText"]){
        NSString *portName = call.arguments[@"portName"];
        NSString *value = call.arguments[@"value"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        [receipt.receipt addBoldText:value];

    } else if ([call.method  isEqual: @"addUnderlinedText"]){
        NSString *portName = call.arguments[@"portName"];
        NSString *value = call.arguments[@"value"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        [receipt.receipt addUnderlinedText:value];

    }else if ([call.method  isEqual: @"addInverseText"]){
        NSString *portName = call.arguments[@"portName"];
        NSString *value = call.arguments[@"value"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        [receipt.receipt addInverseText:value];

    } else if ([call.method  isEqual: @"addLine"]){
        NSString *portName = call.arguments[@"portName"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        [receipt.receipt addLine];

    } else if ([call.method  isEqual: @"addImage"]){
        NSString *portName = call.arguments[@"portName"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        FlutterStandardTypedData *imgBytes = call.arguments[@"bytes"];
        int width = call.arguments[@"width"];
        UIImage *imageData = [UIImage imageWithData:imgBytes.data];
        [receipt.receipt addImage:imageData width:width];

    } else if ([call.method  isEqual: @"addBarcode"]){
        NSString *portName = call.arguments[@"portName"];
        NSString *value = call.arguments[@"value"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        int height = call.arguments[@"height"];
        [receipt.receipt addBarcode:value height:height];

    } else if ([call.method  isEqual: @"addQrCode"]){
        NSString *portName = call.arguments[@"portName"];
        NSString *value = call.arguments[@"value"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        [receipt.receipt addQrCode:value];
        
    } else if ([call.method  isEqual: @"openCashDrawer"]){
        NSString *portName = call.arguments[@"portName"];
        int drawer = call.arguments[@"drawer"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        [receipt.receipt openCashDrawer:drawer];
        
    } else if ([call.method  isEqual: @"cutPaper"]){
        NSString *portName = call.arguments[@"portName"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        [receipt.receipt cutPaper];
        
    } else if ([call.method  isEqual: @"closeReceipt"]){
        NSString *portName = call.arguments[@"portName"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        [receipt.receipt closeReceipt];
        
    } else if ([call.method  isEqual: @"setCommand"]){
        NSString *portName = call.arguments[@"portName"];
        NSString *command = call.arguments[@"command"];
        PrinterReceipt *receipt = [printerReceipts objectForKey:portName];
        [receipt.receipt setCommand:command];
        
    } else if ([call.method  isEqual: @"printReceipt"]){
        NSString *portName = call.arguments[@"portName"];
        int delay = call.arguments[@"delay"];
        int retry = call.arguments[@"retry"];
        PrinterReceipt *printer = [printerReceipts objectForKey:portName];
        [printer.printer printReceipt:printer.receipt withDelay:delay andRetry:retry onSuccess:^(PrinterStatus *printerStatus) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:printerStatus options:0 error:nil];
            NSString *printeResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            result(printeResult);
        } onFail:^(PrinterStatus *printerStatus) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:printerStatus options:0 error:nil];
            NSString *printeResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            result(printeResult);
        }];
    } else if ([call.method  isEqual: @"connect"]){
        NSString *portName = call.arguments[@"portName"];
        barcodeReader = [[BarcodeScanner alloc] initWithPortName:portName];
        [barcodeReader setBarcodeScanner:^(NSString *code) {
            NSMutableDictionary<NSString*,NSString*> *data =  [[NSMutableDictionary<NSString*,NSString*> alloc]init];
            [data setValue:code forKey:@"code"];
            [channel invokeMethod:@"onBarcodeRead" arguments:data];
        }];
    }
}

@end

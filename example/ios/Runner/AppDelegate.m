#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
//#import "Printer.h"
//#import "Receipt.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
    
    FlutterMethodChannel* starPrinterChannel = [FlutterMethodChannel
                                                methodChannelWithName:@"starPrinter"
                                                binaryMessenger:controller.binaryMessenger];

   // NSDictionary* printerDictionary = [[NSMutableDictionary<NSString*,Printer*> alloc]init];
   // NSDictionary* receiptDictionary = [[NSMutableDictionary<NSString*,Receipt*> alloc]init];

    [starPrinterChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {

//        if ([call.method  isEqual: @"searchPrinter"]) {
//            [Printer searchPrinters:^(NSArray<PrinterInfo *> *searchData) {
//                NSData *data = [NSJSONSerialization dataWithJSONObject:searchData options:0 error:nil];
//
//                NSString *searchPrinters = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                result(searchPrinters);
//            }];
//        }else if([call.method  isEqual: @"getPrinter"]){
//            NSString *portName = call.arguments[@"portName"];
//            int timeOut = call.arguments[@"timeOut"];
//
//            Printer *printer = [Printer getPrinter:portName timeout:timeOut];
//
//            [printerDictionary setValue:printer forKey:portName];
//            result(portName);
//
//        }else if([call.method  isEqual: @"createReceipt"]){
//            NSString *portName = call.arguments[@"portName"];
//            bool textValue = call.arguments[@"text"];
//            int paperSize = call.arguments[@"paperSize"];
//
//            Printer *printer = [printerDictionary objectForKey:portName];
//            [printer createReceiptText:textValue PaperSize:paperSize Handler:^(Receipt *receipt) {
//                [receiptDictionary setValue:receipt forKey:portName];
//                result(portName);
//            }];
//
//        }else if([call.method  isEqual: @"addAlignLeft"]){
//            NSString *portName = call.arguments[@"portName"];
//            Receipt *receipt = [receiptDictionary objectForKey:portName];
//            [receipt addAlignLeft];
//            [receiptDictionary setValue:receipt forKey:portName];
//
//        }else if([call.method  isEqual: @"addAlignRight"]){
//            NSString *portName = call.arguments[@"portName"];
//            Receipt *receipt = [receiptDictionary objectForKey:portName];
//            [receipt addAlignRight];
//            [receiptDictionary setValue:receipt forKey:portName];
//
//        }else if([call.method  isEqual: @"addAlignCenter"]){
//            NSString *portName = call.arguments[@"portName"];
//            Receipt *receipt = [receiptDictionary objectForKey:portName];
//            [receipt addAlignCenter];
//            [receiptDictionary setValue:receipt forKey:portName];
//
//        }else if([call.method  isEqual: @"setBlackColor"]){
//            NSString *portName = call.arguments[@"portName"];
//            Receipt *receipt = [receiptDictionary objectForKey:portName];
//            [receipt setBlackColor];
//            [receiptDictionary setValue:receipt forKey:portName];
//
//        }else if([call.method  isEqual: @"setRedColor"]){
//            NSString *portName = call.arguments[@"portName"];
//            Receipt *receipt = [receiptDictionary objectForKey:portName];
//            [receipt setRedColor];
//            [receiptDictionary setValue:receipt forKey:portName];
//
//        }else if([call.method  isEqual: @"addText"]){
//            NSString *portName = call.arguments[@"portName"];
//            NSString *value = call.arguments[@"value"];
//            Receipt *receipt = [receiptDictionary objectForKey:portName];
//            [receipt addText:value];
//            [receiptDictionary setValue:receipt forKey:portName];
//
//        }else if([call.method  isEqual: @"addDoubleText"]){
//            NSString *portName = call.arguments[@"portName"];
//            NSString *value = call.arguments[@"value"];
//            Receipt *receipt = [receiptDictionary objectForKey:portName];
//            [receipt addDoubleText:value];
//            [receiptDictionary setValue:receipt forKey:portName];
//
//        }else if([call.method  isEqual: @"addBoldText"]){
//            NSString *portName = call.arguments[@"portName"];
//            NSString *value = call.arguments[@"value"];
//            Receipt *receipt = [receiptDictionary objectForKey:portName];
//            [receipt addBoldText:value];
//            [receiptDictionary setValue:receipt forKey:portName];
//
//        }else if([call.method  isEqual: @"addUnderlinedText"]){
//            NSString *portName = call.arguments[@"portName"];
//            NSString *value = call.arguments[@"value"];
//            Receipt *receipt = [receiptDictionary objectForKey:portName];
//            [receipt addUnderlinedText:value];
//            [receiptDictionary setValue:receipt forKey:portName];
//
//        }else if([call.method  isEqual: @"addLine"]){
//            NSString *portName = call.arguments[@"portName"];
//            Receipt *receipt = [receiptDictionary objectForKey:portName];
//            [receipt addLine];
//            [receiptDictionary setValue:receipt forKey:portName];
//
//        }else if([call.method  isEqual: @"addImage"]){
//            NSString *portName = call.arguments[@"portName"];
//            Receipt *receipt = [receiptDictionary objectForKey:portName];
//            FlutterStandardTypedData *imgBytes = call.arguments[@"bytes"];
//            int width = call.arguments[@"width"];
//            UIImage *imageData = [UIImage imageWithData:imgBytes.data];
//            [receipt addImage:imageData width:width];
//            [receiptDictionary setValue:receipt forKey:portName];
//
//        }else if([call.method  isEqual: @"addBarcode"]){
//            NSString *portName = call.arguments[@"portName"];
//            NSString *value = call.arguments[@"value"];
//            Receipt *receipt = [receiptDictionary objectForKey:portName];
//            int height = call.arguments[@"height"];
//            [receipt addBarcode:value height:height];
//            [receiptDictionary setValue:receipt forKey:portName];
//
//        }else if([call.method  isEqual: @"printReceipt"]){
//            NSString *portName = call.arguments[@"portName"];
//            int delay = call.arguments[@"delay"];
//            int retry = call.arguments[@"retry"];
//            Printer *printer = [printerDictionary objectForKey:portName];
//            Receipt *receipt = [receiptDictionary objectForKey:portName];
//            [printer printReceipt:receipt withDelay:delay andRetry:retry onSuccess:^(PrinterStatus *printerStatus) {
//                NSData *data = [NSJSONSerialization dataWithJSONObject:printerStatus options:0 error:nil];
//                NSString *printeResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                result(printeResult);
//            } onFail:^(PrinterStatus *printerStatus) {
//                NSData *data = [NSJSONSerialization dataWithJSONObject:printerStatus options:0 error:nil];
//                NSString *printeResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                result(printeResult);
//            }];
//
//        }
        
    }];
    
    [GeneratedPluginRegistrant registerWithRegistry:self];
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end

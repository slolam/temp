#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "Printer.h"
#import "Receipt.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
    
    FlutterMethodChannel* starPrinterChannel = [FlutterMethodChannel
                                                methodChannelWithName:@"starPrinter"
                                                binaryMessenger:controller.binaryMessenger];
    
    NSDictionary* printerDictionary = [[NSMutableDictionary<NSString*,Printer*> alloc]init];
    NSDictionary* receiptDictionary = [[NSMutableDictionary<NSString*,Receipt*> alloc]init];
    
    [starPrinterChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        
        if ([call.method  isEqual: @"searchPrinter"]) {
            [Printer searchPrinters:^(NSArray<PrinterInfo *> *searchData) {
                NSData *data = [NSJSONSerialization dataWithJSONObject:searchData options:0 error:nil];
                
                NSString *searchPrinters = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                result(searchPrinters);
            }];
        }else if([call.method  isEqual: @"getPrinter"]){
            NSString *portName = call.arguments[@"portName"];
            int timeOut = call.arguments[@"timeOut"];
            
            Printer *printer = [Printer getPrinter:portName timeout:timeOut];
            
            [printerDictionary setValue:printer forKey:portName];
            result(portName);
            
        }else if([call.method  isEqual: @"createReceipt"]){
            NSString *portName = call.arguments[@"portName"];
            bool textValue = call.arguments[@"text"];
            int paperSize = call.arguments[@"paperSize"];
            
            Printer *printer = [printerDictionary objectForKey:portName];
            [printer createReceiptText:textValue PaperSize:paperSize Handler:^(Receipt *receipt) {
                [receiptDictionary setValue:receipt forKey:portName];
                result(portName);
            }];
            
        }else if([call.method  isEqual: @"changeStyle"]){
            NSString *portName = call.arguments[@"portName"];
            NSString *methodName = call.arguments[@"methodName"];
            NSString *value = call.arguments[@"value"];
            Receipt *receipt = [receiptDictionary objectForKey:portName];
            NSArray *items = @[@"addAlignLeft", @"addAlignRight", @"addAlignCenter",@"setBlackColor",@"setRedColor",@"addText",@"addDoubleText",@"addBoldText",@"addUnderlinedText",@"addInverseText",@"addLine",@"addImage"];
            int item = [items indexOfObject:methodName];
            if (receipt != NULL) {
                switch (item) {
                    case 0:
                    {
                        [receipt addAlignLeft];
                    }
                        break;
                    case 1:
                    {
                        [receipt addAlignRight];
                    }
                        break;
                    case 2:
                    {
                        [receipt addAlignCenter];
                    }
                        break;
                    case 3:
                    {
                        [receipt setBlackColor];
                    }
                        break;
                        
                    case 4:
                    {
                        [receipt setRedColor];
                    }
                        break;
                    case 5:
                    {
                        [receipt addText:value];
                    }
                        break;
                    case 6:
                    {
                        [receipt addDoubleText:value];
                    }
                        break;
                    case 7:
                    {
                        [receipt addBoldText:value];
                    }
                        break;
                    case 8:
                    {
                        [receipt addUnderlinedText:value];
                    }
                        break;
                        
                    case 9:
                    {
                        [receipt addInverseText:value];
                    }
                        break;
                    case 10:
                    {
                        [receipt addLine];
                    }
                        break;
                    case 11:
                    {
                        FlutterStandardTypedData *imgBytes = call.arguments[@"bytes"];
                        
                        int width = call.arguments[@"width"];
            
                        UIImage *imageData = [UIImage imageWithData:imgBytes.data];
                        
                        [receipt addImage:imageData width:width];
                        
                        
                    }
                        break;
                        
                }
            }
            
            //result(@("changeStyle"));
        }else if([call.method  isEqual: @"printReceipt"]){
            result(@("printReceipt"));
        }
        
    }];
    
    [GeneratedPluginRegistrant registerWithRegistry:self];
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end

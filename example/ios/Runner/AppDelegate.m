#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "Printer.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
  FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;

  FlutterMethodChannel* starPrinterChannel = [FlutterMethodChannel
                                          methodChannelWithName:@"starPrinter"
                                          binaryMessenger:controller.binaryMessenger];
    Printer *printer = [Printer alloc];


  [starPrinterChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {

      if ([call.method  isEqual: @"searchPrinter"]) {
        
        //  NSArray<PrinterInfo *> *dd =   [printer searchPrinters];
          
          result(@("searchPrinter"));
      }else if([call.method  isEqual: @"getPrinter"]){
          result(@("getPrinter"));
      }else if([call.method  isEqual: @"createReceipt"]){
          result(@("createReceipt"));
      }else if([call.method  isEqual: @"changeStyle"]){
          result(@("changeStyle"));
      }else if([call.method  isEqual: @"printReceipt"]){
          result(@("printReceipt"));
      }

  }];

  [GeneratedPluginRegistrant registerWithRegistry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end

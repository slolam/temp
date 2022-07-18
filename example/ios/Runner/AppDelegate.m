#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "Printer.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
  FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;

  FlutterMethodChannel* starPrinterChannel = [FlutterMethodChannel
                                          methodChannelWithName:@"starPrinter"
                                          binaryMessenger:controller.binaryMessenger];

  [starPrinterChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {

      if ([call.method  isEqual: @"searchPrinter"]) {
          [Printer searchPrinters:^(NSArray<PrinterInfo *> *searchData) {
              NSData *data = [NSJSONSerialization dataWithJSONObject:searchData options:0 error:nil];
        
              NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
              result(jsonString);
          }];
      }else if([call.method  isEqual: @"getPrinter"]){
          NSString *portName = call.arguments[@"portName"];
         // NSDictionary* d = [NSD anagramMap];
         // [d add]
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

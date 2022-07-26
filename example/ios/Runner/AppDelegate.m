#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
    
    FlutterMethodChannel* starPrinterChannel = [FlutterMethodChannel
                                                methodChannelWithName:@"starPrinter"

    [starPrinterChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
    }];
    
    [GeneratedPluginRegistrant registerWithRegistry:self];
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end

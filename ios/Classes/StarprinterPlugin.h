#import <Flutter/Flutter.h>

@interface StarprinterPlugin : NSObject<FlutterPlugin>
@end

@interface PrinterReceipt : NSObject
@property (readonly, nonatomic) Printer *  printer;
@property (readonly, nonatomic) Receipt* receipt;

-(id) initWithPrinter: (Printer*) printer;
@end
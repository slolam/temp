#import <Flutter/Flutter.h>
#import "Printer.h"
#import "Receipt.h"

@interface StarprinterPlugin : NSObject<FlutterPlugin>
@end

@interface PrinterReceipt : NSObject
@property (nonatomic) Printer*  printer;
@property (nonatomic) Receipt* receipt;

-(id) initWithPrinter: (Printer*) printer;
@end

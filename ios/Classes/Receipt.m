//
//  Receipt.m
//  StarPrinter
//
//  Created by Shailesh Lolam on 11/8/17.
//  Copyright © 2017 Shailesh Lolam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Receipt.h"
#import "TextReceipt.h"
#import "GraphicReceipt.h"

@implementation Receipt
@synthesize builder;
@synthesize language;
@synthesize paperSize;
bool isClosed = false;

+(Receipt *) createReceiptFromText: (bool) isText Language: (Languages) language AndPaperSize: (int) paperSize;{
    Receipt *receipt = nil;
    PaperSizes size;
    NSLog(@"Creating receipt for text=%d", isText);
    if(isText){
        switch (paperSize) {
            case 2:
                size = PaperSizeTwoInchText;
                break;
            case 3:
                size = PaperSizeThreeInchText;
                break;
            case 4:
                size = PaperSizeFourInchText;
                break;
            default:
                size = PaperSizeThreeInchText;
                break;
        }
        receipt = [[TextReceipt alloc] initWithLanguage:language AndSize:size];
    } else{
        switch (paperSize) {
            case 2:
                size = PaperSizeTwoInch;
                break;
            case 3:
                size = PaperSizeThreeInch;
                break;
            case 4:
                size = PaperSizeFourInch;
                break;
            default:
                size = PaperSizeThreeInch;
                break;
        }
        receipt = [[GraphicReceipt alloc] initWithLanguage:language AndSize:size];
    }

    [receipt.builder beginDocument];
    return receipt;
}

-(void) setFont: (UIFont *) font{
    
}

-(void) setFontName: (NSString *) name{
    
}

-(void) setFontSize: (CGFloat) size{
    
}

-(void) addAlignLeft{
    
}
-(void) addAlignCenter{
    
}
-(void) addAlignRight{
    
}
-(void) addText: (NSString *) string{
    
}

-(void) addDoubleText: (NSString *) string{
    
}

-(void) addBoldText: (NSString *) string{
    
}

-(void) addUnderlinedText: (NSString *) string{
    
}

-(void) addInverseText: (NSString *) string{
    
}

-(void) addBarcode: (NSString *) string  height: (int) height{
    string = [NSString stringWithFormat:@"{B%@", string];
    [self.builder appendBarcodeDataWithAlignment:[string dataUsingEncoding:NSASCIIStringEncoding] symbology:SCBBarcodeSymbologyCode128 width:SCBBarcodeWidthMode2 height:height hri:YES position:SCBAlignmentPositionCenter];
}

-(int) paperWidth {
    switch (paperSize) {
        default:
        case PaperSizeDotImpactThreeInch:
        case PaperSizeThreeInchText:
        case PaperSizeThreeInch:
        case PaperSizeEscPosThreeInch:
            return PaperSizeThreeInch;

        case PaperSizeFourInch:
        case PaperSizeFourInchText:
            return PaperSizeFourInch;
            
        case PaperSizeTwoInch:
        case PaperSizeTwoInchText:
            return PaperSizeTwoInch;
    }
}

-(void) addImage: (UIImage *) source width:(int)width{
    //[self drawPrevious];
    if(source){
        int w = [self paperWidth];
        if(width <= 0 || width > w) {
            width = w;
        }
        [self.builder appendBitmapWithAlignment:source diffusion:NO width:width bothScale:YES position:SCBAlignmentPositionCenter];
    }
}

-(void) addQrCode: (NSString *) data{
    if(data){

        NSData* raw = [data dataUsingEncoding:1];
        
        [self.builder appendQrCodeDataWithAlignment:raw model:SCBQrCodeModelNo2 level:SCBQrCodeLevelM cell:8 position:SCBAlignmentPositionCenter];
    }
}


-(void) openCashDrawer: (int) drawer{
    [self.builder endDocument];
    if (drawer > 1) {
        [self.builder appendPeripheral:SCBPeripheralChannelNo2];
    } else {
        [self.builder appendPeripheral:SCBPeripheralChannelNo1];
    }
    [self.builder beginDocument];
}

-(void) cutPaper{
    [self.builder appendCutPaper:SCBCutPaperActionPartialCutWithFeed];
}

-(void) setBlackColor{
}

-(void) setRedColor{
}

-(void) closeReceipt{
    if(!isClosed) {
        [[self builder] endDocument];
        isClosed = true;
    }
}

-(void) setCommand: (NSString *) command {
        const void *cmd = (const void *)[command UTF8String];
        [self.builder appendBytes:cmd length:command.length];
}

-(void) addLine{
    [self addText: @"--------------------\n"];
}

+(void) beginGraphicContext: (CGSize) size {
    if ([UIScreen.mainScreen respondsToSelector:@selector(scale)]) {
        if (UIScreen.mainScreen.scale == 2.0) { //Retina screen
            UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
        } else { //Non-retina
            UIGraphicsBeginImageContext(size);
        }
    } else {
        UIGraphicsBeginImageContext(size);
    }
}

+(UIImage *)imageWithString:(NSString *)string Width:(CGFloat)width Attributes:(NSDictionary*) attributes{
    
    //string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, 1000)
                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
                                    attributes:attributes
                                       context:nil].size;
    //Reset the width to full
    size.width = width;
    
    [self beginGraphicContext:size];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
//    CGContextSetFillColorWithColor(context, [(UIColor*)[attributes objectForKey:NSForegroundColorAttributeName] CGColor]);
//
//    CGContextSetStrokeColorWithColor(context, [(UIColor*)[attributes objectForKey:NSBackgroundColorAttributeName] CGColor]);
    
    [(UIColor*)[attributes objectForKey:NSBackgroundColorAttributeName] set];

    //[(UIColor*)[attributes objectForKey:NSForegroundColorAttributeName] setStroke];

    CGRect rect = CGRectMake(0, 0, size.width + 1, size.height + 1);
    
    CGContextFillRect(context, rect);
    
    [string drawInRect:rect withAttributes:attributes];
    
    UIImage *imageToPrint = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imageToPrint;
}

+(UIImage *)imageWithString:(NSAttributedString *)string Width:(CGFloat)width {
    
    if (!string || string.length == 0){
        return nil;
    }
    
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
                                    //attributes:attributes
                                       context:nil].size;

    //Reset the width to full
    size.width = width;
    
    [self beginGraphicContext:size];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor whiteColor] set];

    CGRect rect = CGRectMake(0, 0, size.width + 1, size.height + 1);
    
    CGContextFillRect(context, rect);
    
    [string drawInRect:rect];
    
    UIImage *imageToPrint = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imageToPrint;
}
@end

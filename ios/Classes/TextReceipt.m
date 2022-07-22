//
//  TextReceipt.m
//  StarPrinter
//
//  Created by Shailesh Lolam on 11/14/17.
//  Copyright © 2017 Shailesh Lolam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StarIO_Extension/StarIoExt.h>
#import "TextReceipt.h"


@implementation TextReceipt

SCBAlignmentPosition alignment;

-(instancetype) initWithLanguage: (Languages) language AndSize: (PaperSizes) paperSize{
    self.language = language;
    self.paperSize = paperSize;
    self.builder = [StarIoExt createCommandBuilder: StarIoExtEmulationStarLine];
    alignment = SCBAlignmentPositionLeft;
    return self;
}

-(void) addAlignLeft{
    alignment = SCBAlignmentPositionLeft;
    [self.builder appendAlignment:SCBAlignmentPositionLeft];
}
-(void) addAlignCenter{
    alignment = SCBAlignmentPositionCenter;
    [self.builder appendAlignment:SCBAlignmentPositionCenter];
}
-(void) addAlignRight{
    alignment = SCBAlignmentPositionRight;
    [self.builder appendAlignment:SCBAlignmentPositionRight];
}

-(void) setBlackColor{
    [self.builder appendBytes:"\x1b\x35" length:sizeof("\x1b\x34") - 1];
}

-(void) setRedColor{
    [self.builder appendBytes:"\x1b\x34" length:sizeof("\x1b\x34") - 1];
}

-(void) addText: (NSString *) string{
    [self.builder appendData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

-(void) addDoubleText: (NSString *) string{
    [self.builder appendDataWithMultiple:[string dataUsingEncoding:NSUTF8StringEncoding] width:2 height:2];
}

-(void) addBoldText: (NSString *) string{
    [self.builder appendDataWithEmphasis:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

-(void) addUnderlinedText: (NSString *) string{
    [self.builder appendDataWithUnderLine:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

-(void) addInverseText: (NSString *) string{
    [self.builder appendDataWithInvert:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

//-(void) addBarcode: (NSString *) string  height: (int) height{
//    [self.builder appendBarcodeData:[string dataUsingEncoding:NSASCIIStringEncoding] symbology:SCBBarcodeSymbologyCode128 width:SCBBarcodeWidthMode2 height:height hri:YES];
//}

-(void) cutPaper{
    [self.builder appendCutPaper:SCBCutPaperActionPartialCutWithFeed];
}

@end

//
//  GraphicReceipt.m
//  StarPrinter
//
//  Created by Shailesh Lolam on 11/14/17.
//  Copyright © 2017 Shailesh Lolam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StarIO_Extension/StarIoExt.h>
//#import "StarIO_Extension-Bridging-Header.h"
#import "GraphicReceipt.h"

@implementation GraphicReceipt
NSMutableDictionary * attributes;
static NSMutableParagraphStyle *leftAlign;
static NSMutableParagraphStyle *centerAlign;
static NSMutableParagraphStyle *rightAlign;
static UIColor *black, *white;
NSMutableAttributedString * previous;


__attribute__((constructor))
static void constructor_paragraph() {
    leftAlign = [[NSMutableParagraphStyle alloc] init];
    [leftAlign setAlignment: NSTextAlignmentLeft];
    centerAlign = [[NSMutableParagraphStyle alloc] init];
    [centerAlign setAlignment: NSTextAlignmentCenter];
    rightAlign = [[NSMutableParagraphStyle alloc] init];
    [rightAlign setAlignment: NSTextAlignmentRight];
    white = [UIColor whiteColor];
    black = [UIColor blackColor];
}

-(instancetype) initWithLanguage: (Languages) language AndSize: (PaperSizes) paperSize{
    self.language = language;
    self.paperSize = paperSize;
    self.builder = [StarIoExt createCommandBuilder: StarIoExtEmulationStarGraphic];
    
    attributes = [[NSMutableDictionary alloc] init];

    [attributes setObject:leftAlign forKey:NSParagraphStyleAttributeName];
    
    [attributes setObject: black forKey:NSForegroundColorAttributeName];
    [attributes setObject: white forKey:NSBackgroundColorAttributeName];
    
    return self;
}

-(void) drawPrevious{
    if(previous) {
        UIImage *image = [Receipt imageWithString:previous Width:self.paperSize];
        if(image){
            [self.builder appendBitmap:image diffusion:NO];
            previous = nil;
        }
    }
}

-(void) copyString: (NSString *) string{
    if(!previous) {
        previous = [[NSMutableAttributedString alloc] init];
    }
    [previous appendAttributedString: [[NSAttributedString alloc] initWithString:string attributes:[attributes copy]]];
}

-(void) addImage: (UIImage *) source width:(int)width{
    [self drawPrevious];
    [super addImage:source width:width];
}

-(void) addQrCode:(NSString *)data{
    [self drawPrevious];
    [super addQrCode:data];
}

-(void) addBarcode: (NSString *) string  height: (int) height{
    [self drawPrevious];
    [super addBarcode:string height:height];
}

-(void) openCashDrawer: (int) drawer{
    [self drawPrevious];
    [super openCashDrawer: drawer];
}

-(void) cutPaper{
    [self drawPrevious];
    [super cutPaper];
}

-(void) setFont: (UIFont *) font{
    [attributes setObject:font forKey:NSFontAttributeName];
}

-(void) setFontName: (NSString *) name{
    UIFont * font = [attributes objectForKey:NSFontAttributeName];
    [attributes setObject:[UIFont fontWithName:name size:font.pointSize] forKey:NSFontAttributeName];
}

-(void) setFontSize: (CGFloat) size{
    UIFont * font = [attributes objectForKey:NSFontAttributeName];
    [attributes setObject:[UIFont fontWithName:font.fontName size:size] forKey:NSFontAttributeName];
}

-(void) addAlignLeft{
    [attributes setObject:leftAlign forKey:NSParagraphStyleAttributeName];
}

-(void) addAlignCenter{
    [attributes setObject:centerAlign forKey:NSParagraphStyleAttributeName];
}

-(void) addAlignRight{
    [attributes setObject:rightAlign forKey:NSParagraphStyleAttributeName];
}

-(void) addText: (NSString *) string{
    
    [self copyString:string];
    
//    UIImage *image = [Receipt imageWithString:string Width:self.paperSize Attributes: attributes];
//    [self.builder appendBitmap:image diffusion:NO];
}

-(void) addBoldText: (NSString *) string{
    UIFont * font = [attributes objectForKey:NSFontAttributeName];
    UIFontDescriptor * fontD = [font.fontDescriptor
                                fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    UIFont *boldFont = [UIFont fontWithDescriptor:fontD size:0];
    [attributes setObject:boldFont forKey:NSFontAttributeName];
    [self copyString:string];
    
//    UIImage *image = [Receipt imageWithString:string Width:self.paperSize Attributes: attributes];
//    [self.builder appendBitmap:image diffusion:NO];
    [attributes setObject:font forKey:NSFontAttributeName];
}

-(void) addUnderlinedText: (NSString *) string{
    [attributes setObject:[NSNumber numberWithInt:NSUnderlineStyleSingle] forKey:NSUnderlineStyleAttributeName];
    [self copyString:string];

//    UIImage *image = [Receipt imageWithString:string Width:self.paperSize Attributes: attributes];
//    [self.builder appendBitmap:image diffusion:NO];
    [attributes removeObjectForKey: NSUnderlineStyleAttributeName];
}

-(void) addInverseText: (NSString *) string{
    [attributes setObject: white forKey:NSForegroundColorAttributeName];
    [attributes setObject: black forKey:NSBackgroundColorAttributeName];
    [self copyString:string];
    
    //UIImage *image = [Receipt imageWithString:string Width:self.paperSize Attributes: attributes];
    //[self.builder appendBitmap:image diffusion:NO];
    
    [attributes setObject: black forKey:NSForegroundColorAttributeName];
    [attributes setObject: white forKey:NSBackgroundColorAttributeName];
    
    
}

-(void) closeReceipt{
    [self drawPrevious];
    [super closeReceipt];
}

//- (NSString *)applicationDocumentsDirectory
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
//    return basePath;
//}
@end

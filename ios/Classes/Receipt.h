//
//  Receipt.h
//  StarPrinter
//
//  Created by Shailesh Lolam on 11/8/17.
//  Copyright © 2017 Shailesh Lolam. All rights reserved.
//

#ifndef Receipt_h
#define Receipt_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <StarIO/SMPort.h>
#import <StarIO_Extension/ISCBBuilder.h>


typedef NS_ENUM(NSInteger, Languages) {
    LanguageEnglish = 0,
    LanguageJapanese,
    LanguageFrench,
    LanguagePortuguese,
    LanguageSpanish,
    LanguageGerman,
    LanguageRussian,
    LanguageSimplifiedChinese,
    LanguageTraditionalChinese
};

typedef NS_ENUM(NSInteger, PaperSizes) {
    PaperSizeThreeInchImpact = 42,
    PaperSizeTwoInchText = 32,
    PaperSizeThreeInchText = 48,
    PaperSizeFourInchText = 69,
    PaperSizeTwoInch = 384,
    PaperSizeThreeInch = 576,
    PaperSizeFourInch = 832,
    PaperSizeEscPosThreeInch = 512,
    PaperSizeDotImpactThreeInch = 210
};

@interface Receipt : NSObject

-(instancetype) init __attribute__((unavailable("init not available")));

+(Receipt *) createReceiptFromText: (bool) isText Language: (Languages) language AndPaperSize: (int) paperSize;

+(UIImage *)imageWithString:(NSString *)string Width:(CGFloat)width Attributes:(NSDictionary*) attributes;
+(UIImage *)imageWithString:(NSAttributedString *)string Width:(CGFloat)width;

+(void) beginGraphicContext: (CGSize) size;

-(void) addText: (NSString *) string;
-(void) addDoubleText: (NSString *) string;
-(void) addBoldText: (NSString *) string;
-(void) addUnderlinedText: (NSString *) string;
-(void) addInverseText: (NSString *) string;
-(void) addBarcode: (NSString *) string height: (int) height;
-(void) addAlignCenter;
-(void) addAlignLeft;
-(void) addAlignRight;
-(void) addImage: (UIImage *) source width: (int)width;
-(void) addQrCode: (NSString *) data;
-(void) addLine;
-(void) cutPaper;
-(void) openCashDrawer: (int) drawer;
-(void) setFontName: (NSString *) name;
-(void) setFontSize: (CGFloat) size;
-(void) setFont: (UIFont *) font;
-(void) setBlackColor;
-(void) setRedColor;
-(void) setCommand: (NSString *) command;
-(void) closeReceipt;

@property (readonly, nonatomic) ISCBBuilder *  builder;
@property (readonly, nonatomic) Languages  language;
@property (readonly, nonatomic) PaperSizes paperSize;
@end

@interface Receipt()
@property (nonatomic) ISCBBuilder *  builder;
@property (nonatomic) Languages  language;
@property (nonatomic) PaperSizes paperSize;
@end

#endif /* Receipt_h */

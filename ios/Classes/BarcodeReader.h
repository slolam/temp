//
//  BarcodeReader.h
//  StarPrinter
//
//  Created by Shailesh Lolam on 3/18/19.
//  Copyright © 2019 Shailesh Lolam. All rights reserved.
//

#ifndef BarcodeReader_h
#define BarcodeReader_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <StarIO_Extension/StarIoExtManager.h>


@interface BarcodeScanner : NSObject <StarIoExtManagerDelegate>

+(BarcodeScanner*) scanner;
@property (nonatomic, readonly) StarIoExtManager* manager;
@property (nonatomic, readonly) SMPort* port;
-(void)setBarcodeScanner: (void (^) (NSString *)) scanned;
-(instancetype) initWithPortName: (NSString *)portName;

-(BOOL) connect;
-(BOOL) disconnect;
@end

#endif /* BarcodeReader_h */

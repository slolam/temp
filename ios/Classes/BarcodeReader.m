//
//  BarcodeReader.m
//  StarPrinter
//
//  Created by Shailesh Lolam on 3/18/19.
//  Copyright © 2019 Shailesh Lolam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BarcodeReader.h"

@implementation BarcodeScanner {
    void (^_barcodeCallback) (NSString *);
    StarIoExtManager *_starIoExtManager;
}
static BarcodeScanner* _instance = nil;

-(void) setBarcodeScanner:(void (^)(NSString *))scanned {
    _barcodeCallback = scanned;
}

-(BOOL) disconnect {
    return [_starIoExtManager disconnect];
}

-(BOOL) connect {
    return [_starIoExtManager connect];
}

+(BarcodeScanner*) scanner {
    return _instance;
}

-(SMPort*) port {
    return _starIoExtManager.port;
}

-(StarIoExtManager*) manager {
    return _starIoExtManager;
}

-(instancetype) initWithPortName: (NSString *)portName {
    self = [super init];
    
    _instance = self;
    
    _starIoExtManager = [[StarIoExtManager alloc] initWithType:StarIoExtManagerTypeWithBarcodeReader
                                                      portName:portName
                                                  portSettings: @""
                                               ioTimeoutMillis:10000];
    
    
    _starIoExtManager.delegate = self;
    
    NSLog(@"Creating the barcode scanner");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive)  name:UIApplicationDidBecomeActiveNotification  object:nil];
    
    return self;
}

- (void)dealloc
{
    [self->_starIoExtManager disconnect];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification  object:nil];
}

- (void)didBarcodeDataReceive:(StarIoExtManager *)manager data:(NSData *)data {

    NSString *code = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(@"Barcode scanned %@", code);
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_barcodeCallback(code);
    });
}

- (void)didBarcodeReaderConnect:(StarIoExtManager *)manager {
    NSLog(@"Barcode scanner connected");
}


- (void)applicationDidBecomeActive {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshBarcodeReader];
    });
}

- (void)applicationWillResignActive {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_starIoExtManager disconnect];
    });
}

- (void)refreshBarcodeReader {
   
    [_starIoExtManager disconnect];
    
    [_starIoExtManager connect];
}

@end

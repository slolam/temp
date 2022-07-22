//
//  TextReceipt.h
//  StarPrinter
//
//  Created by Shailesh Lolam on 11/14/17.
//  Copyright © 2017 Shailesh Lolam. All rights reserved.
//

#ifndef TextReceipt_h
#define TextReceipt_h
#import "Receipt.h"

@interface TextReceipt: Receipt

-(instancetype) initWithLanguage: (Languages) language AndSize: (PaperSizes) paperSize;

@end
#endif /* TextReceipt_h */

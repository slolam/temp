//
//  GraphicReceipt.h
//  StarPrinter
//
//  Created by Shailesh Lolam on 11/14/17.
//  Copyright © 2017 Shailesh Lolam. All rights reserved.
//

#ifndef GraphicReceipt_h
#define GraphicReceipt_h
#import "Receipt.h"

@interface GraphicReceipt: Receipt
-(instancetype) initWithLanguage: (Languages) language AndSize: (PaperSizes) paperSize;


@end

#endif /* GraphicReceipt_h */

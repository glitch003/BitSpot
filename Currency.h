//
//  Currency.h
//  BitSpot
//
//  Created by Christopher Cassano on 4/5/13.
//  Copyright (c) 2013 ChrisVCo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Currency : NSObject

@property (nonatomic) NSString *name, *price;
@property int idNum;
@property float priceFloat;
@property BOOL hasBeenSet;

@end

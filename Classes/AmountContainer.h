//
//  AmountContainer.h
//  BoardGame
//
//  Created by Liz on 10-9-8.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TypeDef.h"

@interface AmountContainer : NSObject <NSCoding>{
	NSMutableArray * amounts;
}

+ (id)emptyAmountContainer;
+ (id)amountContainerWithArray:(int *)array;

- (int)amountForIndex:(int)index;
- (void)setAmount:(int)amount forIndex:(int)index;
- (void)modifyAmountForIndex:(int)index by:(int)value;

- (void)substractAmount:(AmountContainer *)ac;
- (void)sddAmount:(AmountContainer *)ac;

@end

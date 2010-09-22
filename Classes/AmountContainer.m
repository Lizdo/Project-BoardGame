//
//  AmountContainer.m
//  BoardGame
//
//  Created by Liz on 10-9-8.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "AmountContainer.h"


@implementation AmountContainer

- (id)init{
	if (self = [super init]) {
		amounts = [[NSMutableArray arrayWithCapacity:0]retain];
		for (int i=0; i< MAX(NumberOfTokenTypes, NumberOfRumbleTargetTypes); i++) {
			[amounts addObject:[NSNumber numberWithInt:0]];
		}
	}
	return self;
}

+ (id)emptyAmountContainer{
	AmountContainer * ac = [[AmountContainer alloc] init];
	return [ac autorelease];
}

+ (id)amountContainerWithArray:(int *)array{
	AmountContainer * ac = [AmountContainer emptyAmountContainer];
	int count = sizeof(array)/sizeof(int);
	for (int i=0; i<count; i++) {
		[ac setAmount:array[i] forIndex:i];
	}
	return ac;
}

- (int)amountForIndex:(int)index{
	return [[amounts objectAtIndex:index]intValue];
}

- (void)setAmount:(int)amount forIndex:(int)index{
	[amounts replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:amount]];
}

- (void)modifyAmountForIndex:(int)index by:(int)value{
	int originalAmount = [self amountForIndex:index];
	[self setAmount:originalAmount+value forIndex:index];
}


- (void)substractAmount:(AmountContainer *)ac{
	for (int i=0; i< MAX(NumberOfTokenTypes, NumberOfRumbleTargetTypes); i++) {
		[self modifyAmountForIndex:i by:[ac amountForIndex:i]*(-1)];
	}
}

- (void)addAmount:(AmountContainer *)ac{
	for (int i=0; i< MAX(NumberOfTokenTypes, NumberOfRumbleTargetTypes); i++) {
		[self modifyAmountForIndex:i by:[ac amountForIndex:i]];
	}
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:amounts forKey:@"amounts"];
}


- (id)initWithCoder:(NSCoder *)coder {
	self = [[AmountContainer alloc]init];
	amounts = [[coder decodeObjectForKey:@"amounts"]retain];
	return self;
}


- (void)dealloc{
	[amounts removeAllObjects];
	[amounts release];
	[super dealloc];
}

@end

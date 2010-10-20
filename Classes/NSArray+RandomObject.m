//
//  NSArray+RandomObject.m
//  BoardGame
//
//  Created by Liz on 10-10-20.
//  Copyright 2010 StupidTent co. All rights reserved.
//


@interface NSArray (RandomObject)

- (id)randomObject;

@end


@implementation NSArray (RandomObject)

- (id)randomObject{
	int seed = rand()%[self count];
	return [self objectAtIndex:seed];
}

@end
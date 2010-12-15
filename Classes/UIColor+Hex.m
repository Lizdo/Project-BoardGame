//
//  UIColor+Hex.m
//  BoardGame
//
//  Created by Liz on 10-12-15.
//  Copyright 2010 StupidTent co. All rights reserved.
//

@interface UIColor (Hex)

+ (UIColor *)colorWithHex:(int)hex;

@end

@implementation UIColor (Hex)

+ (UIColor *)colorWithHex:(int)hex{
	float r = ( hex >> 16 ) & 0xFF;
	float g = ( hex >> 8 ) & 0xFF;
	float b = hex & 0xFF;
	return [UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:1];
}

@end

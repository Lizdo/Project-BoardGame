//
//  GameVisual.h
//  BoardGame
//
//  Created by Liz on 10-5-4.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TypeDef.h"
#import "Token.h"


@interface GameVisual : NSObject {

}

+ (UIColor *)boardBackgroundColor;
+ (UIColor *)tileColorForState:(TileState)state andStyle:(int)style;
+ (UIImage *)tileImageForState:(TileState)state andStyle:(int)style;

+ (UIImage *)imageForRumbleTarget;

+ (UIColor *)colorForPlayerID:(int)theID;
+ (UIImage *)imageForTokenType:(TokenType)aType andPlayerID:(int)anOwnerID placeholder:(BOOL)isPlaceholder;
+ (UIImage *)imageForSharedTokenWithType:(TokenType)aType;
+ (UIImage *)playerTokenImageForPlayerID:(int)anOwnerID onTile:(BOOL)onTile;


+ (UIImage *)imageForResourceType:(ResourceType)aType;
+ (UIImage *)imageForRumbleType:(RumbleTargetType)aType andPlayerID:(int)anOwnerID;

+ (UIImage *)imageForBadgeType: (BadgeType)aType;

+ (UIImage *)colorizeImage:(UIImage *)baseImage color:(UIColor *)theColor;


+ (UIColor *)colorWithHex:(int)hex;

+ (CGPoint)infoCenterForPlayerID:(int)theID;
+ (CGPoint)rumbleInfoCenterForPlayerID:(int)i;


+ (CGPoint)positionForPlayerID:(int)theID withOffsetFromInfoCenter:(CGSize)offset;

+ (CGAffineTransform)transformForPlayerID:(int)theID;
+ (UIViewAutoresizing)infoResizingMaskForPlayerID:(int)theID;

+ (CGPoint)boardCenter;

@end

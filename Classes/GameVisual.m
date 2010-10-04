//
//  GameVisual.m
//  BoardGame
//
//  Created by Liz on 10-5-4.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "GameVisual.h"
#import "GameLogic.h"
#import "Board.h"
#import "Token.h"


@implementation GameVisual



+ (UIColor *)boardBackgroundColor{
	return [UIColor whiteColor];
}

+ (UIColor *)boardBackgroundImage{
	UIColor * color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundTile.png"]];
	return color;
}

+ (UIColor *)tileColorForState:(TileState)state andStyle:(int)style{
	NSString * imageName;
	switch (state) {
		case TileStateAvailable:
			imageName = @"TileBackgroundAvailable";
			break;
		case TileStateSelected:
			imageName = @"TileBackgroundSelected";
			break;
		case TileStateRejected:
		case TileStateDisabled:
			imageName = @"TileBackgroundUnavailable";
			break;
		case TileStateHidden:
		default:
			return [GameVisual boardBackgroundColor];
			break;
	}
	imageName = [imageName stringByAppendingFormat:@"%d.png",style+1];
	UIColor * color = [UIColor colorWithPatternImage:[UIImage imageNamed:imageName]];
	return color;
}

+ (UIImage *)tileImageForState:(TileState)state andStyle:(int)style{
	NSString * imageName;
	switch (state) {
		case TileStateAvailable:
			imageName = @"TileBackgroundAvailable";
			break;
		case TileStateSelected:
			imageName = @"TileBackgroundSelected";
			break;
		case TileStateRejected:
		case TileStateDisabled:
			imageName = @"TileBackgroundUnavailable";
			break;
		case TileStateHidden:
		default:
			return nil;
		break;
	}
	//TODO: remove reference to TileStyle
	imageName = [imageName stringByAppendingFormat:@".png"];
	return [UIImage imageNamed:imageName];
}

+ (UIImage *)imageForRumbleTarget{
	return [UIImage imageNamed:@"Postit_Rumble.png"];
}


+ (UIColor *)colorForPlayerID:(int)theID{
	UIColor * color;
	switch (theID) {
		case 0:
			color = [UIColor colorWithRed:0.702 green:0.753 blue:1.000 alpha:1.000];
			break;
		case 1:
			color = [UIColor colorWithRed:1.000 green:0.512 blue:0.211 alpha:1.000];
			break;
		case 2:
			color = [UIColor colorWithRed:0.791 green:1.000 blue:0.253 alpha:1.000];
			break;
		case 3:
			color = [UIColor colorWithRed:1.000 green:0.958 blue:0.709 alpha:1.000];
			break;			
		default:
			color = [UIColor grayColor];
			break;
	}
	return color;
}

+ (UIImage *)imageForTokenType:(TokenType)aType andPlayerID:(int)anOwnerID placeholder:(BOOL)isPlaceholder{
	UIColor * color = isPlaceholder ? [UIColor colorWithWhite:0.400 alpha:1.000] : [GameVisual colorForPlayerID:anOwnerID];
	NSString * imageName;
	switch (aType) {
		case TokenTypePlayer:
			imageName = @"Producer";
			break;
		case TokenTypeRect:
			imageName = @"Rect";
			break;
		case TokenTypeRound:
			imageName = @"Round";
			break;
		case TokenTypeSquare:
			imageName = @"Square";
			break;			
		default:
			//Change to unknown image
			imageName = @"Square";			
			break;
	}
	if (isPlaceholder) {
		imageName = [imageName stringByAppendingString:@"_Placeholder"];
	}
	
	imageName = [imageName stringByAppendingString:@".png"];
	
	UIImage * image = [GameVisual colorizeImage:[UIImage imageNamed:imageName] color:color];
	return image;
}


+ (UIImage *)playerTokenImageForPlayerID:(int)anOwnerID onTile:(BOOL)onTile{
	UIColor * color = [GameVisual colorForPlayerID:anOwnerID];
	NSString * imageName = onTile ? @"ProducerOnTile.png" : @"Producer.png";
	UIImage * image = [GameVisual colorizeImage:[UIImage imageNamed:imageName] color:color];
	return image;
}


+ (UIImage *)imageForSharedTokenWithType:(TokenType)aType{
	UIColor * color = [UIColor colorWithRed:1.000 green:0.791 blue:0.893 alpha:1.000];
	NSString * imageName;
	switch (aType) {
		case TokenTypePlayer:
			imageName = @"PlayerToken.png";
			break;
		case TokenTypeRect:
			imageName = @"Rect.png";
			break;
		case TokenTypeRound:
			imageName = @"Round.png";
			break;
		case TokenTypeSquare:
			imageName = @"Square.png";
			break;			
		default:
			//Change to unknown image
			imageName = @"Square.png";			
			break;
	}
	UIImage * image = [GameVisual colorizeImage:[UIImage imageNamed:imageName] color:color];
	return image;	
}

+ (UIImage *)imageForRumbleType:(RumbleTargetType)aType andPlayerID:(int)anOwnerID{
	//UIColor * color = [GameVisual colorForPlayerID:anOwnerID];
	UIColor * color = [UIColor grayColor];
	NSString * imageName;
	switch (aType) {
		case RumbleTargetTypeRobot:
			imageName = @"Rumble_Robot.png";
			break;
		case RumbleTargetTypeSnake:
			imageName = @"Rumble_Snake.png";
			break;
		case RumbleTargetTypePalace:
			imageName = @"Rumble_Palace.png";
			break;	
		default:
			//Change to unknown image
			imageName = @"Rumble_Robot.png";
			break;
	}
	UIImage * image = [GameVisual colorizeImage:[UIImage imageNamed:imageName] color:color];
	return image;	
}


+ (UIImage *)imageForResourceType:(ResourceType)aType{
	NSString * imageName;
	switch (aType) {
		case ResourceTypeRect:
			imageName = @"Rect.png";
			break;
		case ResourceTypeRound:
			imageName = @"Round.png";
			break;
		case ResourceTypeSquare:
			imageName = @"Square.png";
			break;			
		default:
			//Change to unknown image
			imageName = @"Square.png";			
			break;
	}
	return [UIImage imageNamed:imageName];
}

+ (UIImage *)imageForBadgeType: (BadgeType)aType{
	return [UIImage imageNamed:@"BadgeTypeMostRound.png"];
}


+ (UIImage *)colorizeImage:(UIImage *)baseImage color:(UIColor *)theColor {
    UIGraphicsBeginImageContext(baseImage.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, baseImage.size.width, baseImage.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSaveGState(ctx);
    CGContextClipToMask(ctx, area, baseImage.CGImage);
    
    [theColor set];
    CGContextFillRect(ctx, area);
	
    CGContextRestoreGState(ctx);
    
    CGContextSetBlendMode(ctx, kCGBlendModeLuminosity);
    
    CGContextDrawImage(ctx, area, baseImage.CGImage);
	
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIColor *)colorWithHex:(int)hex{
	float r = ( hex >> 16 ) & 0xFF;
	float g = ( hex >> 8 ) & 0xFF;
	float b = hex & 0xFF;
	return [UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:1];
}

+ (CGPoint)infoCenterForPlayerID:(int)i{
	float boardWidth = [GameLogic sharedInstance].board.bounds.size.width;
	float boardHeight = [GameLogic sharedInstance].board.bounds.size.height;
	switch (i) {
		case 1:
			return CGPointMake(InfoHeight/2, boardHeight - InfoWidth/2);								
			break;
		case 2:
			return CGPointMake(InfoWidth/2, InfoHeight/2);				
			break;
		case 3:
			return CGPointMake(boardWidth - InfoHeight/2, InfoWidth/2);
			break;
		case 0:
			return CGPointMake(boardWidth - InfoWidth/2, boardHeight - InfoHeight/2);				
			break;				
		default:
			break;
	}
	return CGPointZero;
}


+ (CGPoint)rumbleInfoCenterForPlayerID:(int)i{
	float boardWidth = [GameLogic sharedInstance].board.bounds.size.width;
	float boardHeight = [GameLogic sharedInstance].board.bounds.size.height;
	switch (i) {
		case 1:
			return CGPointMake(RumbleInfoHeight/2, boardHeight - RumbleInfoWidth/2);								
			break;
		case 2:
			return CGPointMake(RumbleInfoWidth/2, RumbleInfoHeight/2);				
			break;
		case 3:
			return CGPointMake(boardWidth - RumbleInfoHeight/2, RumbleInfoWidth/2);
			break;
		case 0:
			return CGPointMake(boardWidth - RumbleInfoWidth/2, boardHeight - RumbleInfoHeight/2);				
			break;				
		default:
			break;
	}
	return CGPointZero;
}


+ (CGPoint)positionForPlayerID:(int)theID withOffsetFromInfoCenter:(CGSize)offset{
	CGPoint infoCenter = [GameVisual infoCenterForPlayerID:theID];
	switch (theID) {
		case 1:
			return CGPointMake(infoCenter.x - offset.height, infoCenter.y + offset.width);				
			break;
		case 2:
			return CGPointMake(infoCenter.x - offset.width, infoCenter.y - offset.height);				
			break;
		case 3:
			return CGPointMake(infoCenter.x + offset.height, infoCenter.y - offset.width);				
			break;
		case 0:
			return CGPointMake(infoCenter.x + offset.width, infoCenter.y + offset.height);				
			break;				
		default:
			break;
	}
	return CGPointZero;
}

+ (CGAffineTransform)transformForPlayerID:(int)theID{
	return CGAffineTransformMakeRotation(90*theID*PI/180);
}

+ (CGPoint)boardCenter{
	float boardWidth = [GameLogic sharedInstance].board.bounds.size.width;
	float boardHeight = [GameLogic sharedInstance].board.bounds.size.height;
	return CGPointMake(boardWidth/2, boardHeight/2);
}

+ (UIViewAutoresizing)infoResizingMaskForPlayerID:(int)i{
	switch (i) {
		case 1:
			return UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin;
			break;
		case 2:
			return UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
			break;
		case 3:
			return UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin;
			break;
		case 0:
			return UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
			break;				
		default:
			break;
	}
	return 0;
}

	

@end

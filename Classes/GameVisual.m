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

+ (UIColor *)rumbleBoardBackgroundImage{
	UIColor * color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"RumbleBackgroundTile.png"]];
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

+ (UIImage *)imageForRumbleTarget:(BOOL)isAvailable{
	if (isAvailable) {
		return [UIImage imageNamed:@"Postit_Rumble.png"];
	}else {
		return [UIImage imageNamed:@"Postit_Rumble_Unavailable.png"];
	}
}

+ (UIImage *)infoBackgroundForPlayerID:(int)playerID{
	return [GameVisual colorizeImage:[UIImage imageNamed:@"InfoBackground.png"] 
							   color:[GameVisual colorForPlayerID:playerID]];
}

+ (UIImage *)rumbleInfoBackgroundForPlayerID:(int)playerID{
	return [GameVisual colorizeImage:[UIImage imageNamed:@"RumbleInfoBackground.png"] 
							   color:[GameVisual colorForPlayerID:playerID]];	
}

+ (UIColor *)colorForPlayerID:(int)theID{
	UIColor * color;
	switch (theID) {
		case 0:
			color = [UIColor colorWithHex:0xC7FFF2];
			break;
		case 1:
			color = [UIColor colorWithHex:0xC9BBFF];
			break;
		case 2:
			color = [UIColor colorWithHex:0xFFBBD3];
			break;
		case 3:
			color = [UIColor colorWithHex:0xFFE6C7];
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
		imageName = [imageName stringByAppendingString:@"Placeholder.png"];

	}else {
		imageName = [imageName stringByAppendingString:@".png"];
	}
	
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
	UIColor * color = [UIColor colorWithHex:0xE0E5CA];
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

+ (UIImage *)imageForRumbleType:(RumbleTargetType)aType{
	return [UIImage imageNamed:[GameVisual imageNameForRumbleType:aType]];
}

+ (NSString *)imageNameForRumbleType:(RumbleTargetType)aType{
	NSString * imageName;
	switch (aType) {
		case RumbleTargetTypeRobot:
			imageName = @"Robot.png";
			break;
		case RumbleTargetTypeSnake:
			imageName = @"Snake.png";
			break;
		case RumbleTargetTypePalace:
			imageName = @"Palace.png";
			break;
		case RumbleTargetTypeCart:
			imageName = @"Cart.png";
			break;
		case RumbleTargetTypeSignal:
			imageName = @"Signal.png";
			break;
		case RumbleTargetTypeTank:
			imageName = @"Tank.png";
			break;			
		default:
			//Change to unknown image
			imageName = @"Rumble_Robot.png";
			break;
	}
	return imageName;
}


+ (UIImage *)imageForResourceType:(ResourceType)aType{
	NSString * imageName;
	switch (aType) {
		case ResourceTypeRect:
			imageName = @"RectPlaceholder.png";
			break;
		case ResourceTypeRound:
			imageName = @"RoundPlaceholder.png";
			break;
		case ResourceTypeSquare:
			imageName = @"SquarePlaceholder.png";
			break;			
		default:
			//Change to unknown image
			imageName = @"Square.png";			
			break;
	}
	return [UIImage imageNamed:imageName];
}

+ (UIImage *)imageForBadgeType: (BadgeType)aType{
	return [UIImage imageNamed:[GameVisual imageNameForBadgeType:aType]];
}

+ (NSString *)imageNameForBadgeType:(BadgeType)aType{
	switch (aType) {
		case BadgeTypeMostRound:
			return @"BadgeMostDesigner.png";
			break;
		case BadgeTypeMostRect:
			return @"BadgeMostArtist.png";
			break;
		case BadgeTypeMostSquare:
			return @"BadgeMostCoder.png";
			break;
		case BadgeTypeEnoughRound:
			return @"BadgeEnoughDesigner.png";
			break;
		case BadgeTypeEnoughRect:
			return @"BadgeEnoughArtist.png";
			break;
		case BadgeTypeEnoughSquare:
			return @"BadgeEnoughCoder.png";
			break;
		case BadgeTypeFirstBuilder:
			return @"BadgeFirstBuilder.png";
			break;
		case BadgeTypeFastBuilder:
			return @"BadgeFastBuilder.png";
			break;
		case BadgeTypeAllProjects:
			return @"BadgeAllProjects.png";
			break;			
		case BadgeTypeOneProject:
			return @"BadgeFirstProject.png";
			break;		
		case BadgeTypeThreeProjects:
			return @"BadgeThirdProject.png";
			break;		
		case BadgeTypeFiveProjects:
			return @"BadgeFifthProject.png";
			break;
		case BadgeTypeSevenProjects:
			return @"BadgeSeventhProject.png";
			break;			
		default:
			return @"BadgeTypeMostRound.png";
			break;
	}
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



+ (UIColor *)scoreColor{
	return [UIColor colorWithHex:0x50BAB7];
}


+ (CGPoint)infoCenterForPlayerID:(int)i{
	float boardWidth = [GameLogic sharedInstance].board.bounds.size.width;
	float boardHeight = [GameLogic sharedInstance].board.bounds.size.height;
	if ([Game TotalNumberOfPlayers] == 2) {
		i *= 2;
	}
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
	if ([Game TotalNumberOfPlayers] == 2) {
		i *= 2;
	}	
	switch (i) {
		case 1:
			return CGPointMake(RumbleInfoHeight/2, boardHeight/2);
			break;
		case 2:
			return CGPointMake(boardWidth/2, RumbleInfoHeight/2);
			break;
		case 3:
			return CGPointMake(boardWidth - RumbleInfoHeight/2, boardHeight/2);
			break;
		case 0:
			return CGPointMake(boardWidth/2, boardHeight - RumbleInfoHeight/2);
			break;
		default:
			break;
	}
	return CGPointZero;
}


+ (CGPoint)positionForPlayerID:(int)theID withOffsetFromInfoCenter:(CGSize)offset{
	CGPoint infoCenter = [GameVisual infoCenterForPlayerID:theID];
	if ([Game TotalNumberOfPlayers] == 2) {
		theID *= 2;
	}	
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
	if ([Game TotalNumberOfPlayers] == 2) {
		theID *= 2;
	}	
	return CGAffineTransformMakeRotation(90*theID*PI/180);
}

+ (CGPoint)boardCenter{
	float boardWidth = [GameLogic sharedInstance].board.bounds.size.width;
	float boardHeight = [GameLogic sharedInstance].board.bounds.size.height;
	return CGPointMake(boardWidth/2, boardHeight/2);
}

+ (UIViewAutoresizing)infoResizingMaskForPlayerID:(int)i{
	if ([Game TotalNumberOfPlayers] == 2) {
		i *= 2;
	}	
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

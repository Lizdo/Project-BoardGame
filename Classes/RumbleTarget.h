//
//  RumbleTarget.h
//  BoardGame
//
//  Created by Liz on 10-5-14.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameVisual.h"
#import "TypeDef.h"
#import "Rumble.h"
#import "TokenPlaceholder.h"
#import "BGViewWithPopup.h"
#import "AmountContainer.h"

@class GameLogic;
@class RumbleInfo;
@class Project;

@interface RumbleTarget : BGViewWithPopup {
	BOOL allMatched;
	GameLogic * gameLogic;
	Player * player;
	RumbleTargetType type;
	
	NSMutableArray * tokenPlaceholders;
	RumbleInfo * info;
	
	UISwipeGestureRecognizer * recognizerUp;
	UISwipeGestureRecognizer * recognizerDown;
	
	UIPinchGestureRecognizer * recognizerPinch;
	UITapGestureRecognizer * recognizerTap;	
		
	UILabel * nameLabel;
	UILabel * timeLabel;
	
	BOOL isAvailable;
}

@property (nonatomic,assign) Player * player;
@property (nonatomic,assign) RumbleInfo * info;
@property (nonatomic,assign) RumbleTargetType type;
@property (nonatomic,retain) NSMutableArray * tokenPlaceholders;

@property (nonatomic,assign) BOOL isAvailable;


+ (RumbleTarget *)rumbleTargetWithType:(RumbleTargetType)aType;
- (void)addTokenPlaceholderWithInfo:(int *)info;

- (void)triggerEvent:(TokenEvent)e withToken:(Token *)t atPosition:(CGPoint)p;
- (void)updateAllMatchedStatus;
- (void)reset;

- (void)activate;
- (void)deactivate;
- (void)remove;

- (void)enableSelection;
- (AmountContainer *)tokenAmount;

#pragma mark -
#pragma mark AI
- (CGPoint)emptyPointForToken:(Token *)t;

@end

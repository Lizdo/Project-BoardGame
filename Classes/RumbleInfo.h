//
//  RumbleInfo.h
//  BoardGame
//
//  Created by Liz on 10-5-17.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameVisual.h"
#import "TypeDef.h"
#import "Rumble.h"
#import "Player.h"
#import "ContainerView.h"

#define RandomSlices 10
#define RandomSeedsNeeded 20

@class GameLogic;
@class RumbleTarget;

@interface RumbleInfo : ContainerView {
	UIImageView * backgroundImage;	
	
	Player * player;
	
	GameLogic * gameLogic;
	NSMutableArray * rumbleTargets;
	
	RumbleTarget * currentRumbleTarget;
	RumbleTarget * nextRumbleTarget;
	
	BOOL swapInProgress;
	BOOL rumbleAlone;

	CGPoint currentPosition;
	
}

@property (nonatomic,assign) Player * player;
@property (nonatomic,assign) RumbleTarget * currentRumbleTarget;
@property (nonatomic,retain) NSMutableArray * rumbleTargets;



- (void)initGame;
- (void)enterRumble;
- (void)enterRumbleWithPlayerID:(int)playerID;
- (void)exitRumble;

- (void)addRandomTokenWithType:(TokenType)type;
- (void)activateRumbleTargetWithType:(RumbleTargetType)type;
- (void)swapRumbleTarget:(BOOL)up;
- (void)enterRumbleAnimDidStop;

- (void)zoomOutWithAnim:(BOOL)withAnim;
- (void)selectRumbleTarget:(RumbleTarget *)rt;
- (void)validateRumbleTargetAmount;

- (void)reset;
- (void)update;

@end

//
//  RumbleBoard.h
//  BoardGame
//
//  Created by Liz on 10-5-12.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameVisual.h"
#import "TypeDef.h"
#import "Rumble.h"
#import "RumbleInfo.h"
#import "ContainerView.h"
#import "AmountContainer.h"

#define RBRandomSlices 6
#define RBRandomSeedsNeeded 20

@class GameLogic;
@class BoardGameViewController;
@class BoardGameView;

@interface RumbleBoard : UIView <BGPopupBoard>{
	GameLogic * gameLogic;
	
	Rumble * rumble;
	UILabel * countDown;
	
	NSMutableArray * rumbleInfos;
	
	CGRect randomTokenRect;
	
	int randomPositions[RBRandomSlices*RBRandomSlices*2];
	int randomSeedUsed[RBRandomSeedsNeeded];
	int randomSeedIndex;
	
	BOOL allRumble;
	int rumbleID;
	
	BoardGameViewController * controller;
	BoardGameView * bgv;
	
	ContainerView * rumbleView;
	ContainerView * tokenView;
	ContainerView * popupView;
	
	AmountContainer * sharedTokenAmount;
}

@property (retain,nonatomic) AmountContainer * sharedTokenAmount;
@property (readonly,nonatomic) 	ContainerView * rumbleView;


+ (RumbleBoard*)sharedInstance;

- (void)initGame;

- (void)enterRumble;
- (void)exitRumble;
- (void)update;

- (void)allRumble;
- (void)rumbleWithPlayerID:(int)playerID;
- (void)addSharedTokens;
- (void)addRumbleToken:(Token *)t;

- (void)validateRumbleTargetAmount;

- (void)enterRumbleAnimDidStop;
- (void)exitRumbleAnimDidStop;

- (void)reset;

@end

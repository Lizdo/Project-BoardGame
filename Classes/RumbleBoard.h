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

#define RBRandomSlices 6
#define RBRandomSeedsNeeded 20

@class GameLogic;

@interface RumbleBoard : UIView {
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
}

- (void)initGame;

- (void)enterRumble;
- (void)exitRumble;
- (void)update;

- (void)allRumble;
- (void)rumbleWithPlayerID:(int)playerID;
- (void)addSharedTokens;

- (void)enterRumbleAnimDidStop;

@end

//
//  Turn.h
//  BoardGame
//
//  Created by Liz on 10-5-1.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TypeDef.h"

@class GameLogic;
@class Player;
@class Tile;
@class Round;
@class Rumble;

typedef enum{
	TurnStateInit,
	TurnStateWaitForInput,
	TurnStateSelectionMade,	
	TurnStateConclusion,
	TurnStateBuild,
}TurnState;

@interface Turn : NSObject <NSCoding>{
	int count;
	
	GameLogic * gameLogic;
	TurnState state;
	Player * player;
	Tile * selectedTile;
	
	Round * round;
	Rumble * rumble;
	
	BOOL allowTurnEnd;
}

@property (nonatomic, assign) int count;
@property (nonatomic, assign) TurnState state;
@property (nonatomic, assign) Player * player;
@property (nonatomic, assign) Tile * selectedTile;

+ (Turn*)sharedInstance;
- (void)initGame;

- (void) enterTurn;
- (void) exitTurn;

- (void)pause;
- (void)resume;

- (void)inputMade;
- (void)endTurnButtonClicked;

- (void)buildComplete;
- (void)luckyComplete;

@end

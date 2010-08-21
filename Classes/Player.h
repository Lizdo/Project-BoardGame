//
//  Player.h
//  BoardGame
//
//  Created by Liz on 10-5-1.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TypeDef.h"
#import "Token.h"

@class Board;
@class GameLogic;

@interface Player : NSObject <NSCoding>{
	BOOL isHuman;
	Token * token;
	int ID;
	CGPoint initialTokenPosition;
	
	GameLogic * gameLogic;
	
	int roundAmount;
	int rectAmount;	
	int squareAmount;
	
	int robotAmount;
	int snakeAmount;
	int palaceAmount;
	
	int resourceScore;
	int buildScore;
	
	int score;
	
	Board * board;
	BOOL aiProcessInProgress;
	
	BOOL roundAmountUpdated;
	BOOL rectAmountUpdated;
	BOOL squareAmountUpdated;	
}

@property BOOL isHuman;
@property BOOL aiProcessInProgress;

@property int ID;
@property (nonatomic,retain) Token * token;
@property (nonatomic,assign) CGPoint initialTokenPosition;

@property int roundAmount;
@property int rectAmount;
@property int squareAmount;
@property int robotAmount;
@property int snakeAmount;
@property int palaceAmount;
@property int resourceScore;
@property int buildScore;
@property int score;


@property BOOL roundAmountUpdated;
@property BOOL rectAmountUpdated;
@property BOOL squareAmountUpdated;

- (void)initGameWithID:(int)playerID;

- (int)amountOfResource:(ResourceType)type;
- (BOOL)modifyResource:(ResourceType)type by:(int)value;

- (void)processAI;
- (void)AImoveComplete;
- (void)randomWait:(SEL)selector andDelay:(float)delay;

- (void)rumbleAI;

@end

//
//  GameLogic.h
//  BoardGame
//
//  Created by Liz on 10-5-1.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Game.h"
#import "Round.h"
#import "Turn.h"
#import "Player.h"
#import "TypeDef.h"
#import "RumbleTarget.h"

@class Tile;
@class Board;
@class RumbleBoard;

@interface GameLogic : NSObject {
	NSMutableArray * players;
	NSMutableArray * tiles;
	NSMutableArray * specialTiles;
	NSMutableArray * rumbleTargets;
	NSMutableArray * rumbleTokens;
	NSMutableArray * rumbleInfos;
	
	
	Board * board;
	RumbleBoard * rumbleBoard;
	Game * game;
	Round * round;
	Turn * turn;
	Rumble * rumble;
	int currentPlayerID;
	
	Player * currentPlayer;
	BOOL toBuild;
}

@property (nonatomic, retain) NSMutableArray * players;
@property (nonatomic, assign) Board * board;
@property (nonatomic, assign) Game * game;
@property (nonatomic, retain) Round * round;
@property (nonatomic, retain) Turn * turn;
@property (nonatomic, retain) Rumble * rumble;

@property (readonly, nonatomic) Player * currentPlayer;

@property (nonatomic, retain) NSMutableArray * tiles;
@property (nonatomic, retain) NSMutableArray * specialTiles;
@property (nonatomic, retain) NSMutableArray * rumbleTargets;
@property (nonatomic, retain) NSMutableArray * rumbleTokens;
@property (nonatomic, retain) NSMutableArray * rumbleInfos;


+ (GameLogic*)sharedInstance;


//Inits
- (void)initGameWithPlayerNumber:(int)number;
- (void)resumeGame;

//Updates
- (void)triggerEvent:(TokenEvent)e withToken:(Token *)t atPosition:(CGPoint)p;

- (void)updateNewRound;
- (void)updateNewTurn;

- (void)exitTurn;
- (void)exitRound;

- (void)enterRumbleToBuild:(BOOL)tobuld;
- (void)enterRumbleAnimDidStop;
- (void)exitRumble;
- (void)exitRumbleAnimDidStop;

//Events
- (void)endTurnButtonClicked;

//Helper Functions
- (Player *)playerWithID:(int)theID;
- (Tile *)randomTile;
- (void)unlockNewTile;
- (void)calculateScore;
- (NSArray *)rumbleTargetsOfPlayer:(Player *)p;
- (RumbleTarget *)rumbleTargetForPlayer:(Player *)p;

- (TokenType)randomTokenType;
- (CGPoint)randomPositionInRect:(CGRect)rect;

- (Token *)randomRumbleTokenForPlayer:(Player *)p;
- (CGPoint)randomRumblePositionForPlayer:(Player *)p withToken:(Token *)t;

- (CGPoint)convertedPoint:(CGPoint)point;
- (CGRect)convertedRect:(CGRect)rect;

+ (int)scoreForBadgeType:(BadgeType)type;
+ (NSString *)descriptionForBadgeType:(BadgeType)type;

//- (Player *)currentPlayer;

@end

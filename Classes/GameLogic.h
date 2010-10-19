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
#import "SoundManager.h"

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
	
	BOOL animationInProgress;
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

@property (nonatomic, assign) BOOL animationInProgress;


+ (GameLogic*)sharedInstance;


#pragma mark -
#pragma mark Inits

- (void)initGameWithPlayerNumber:(int)number;
- (void)resumeGame;


#pragma mark -
#pragma mark Updates

- (void)triggerEvent:(TokenEvent)e withToken:(Token *)t atPosition:(CGPoint)p;

- (void)updateNewRound;
- (void)updateNewTurn;

- (void)exitTurn;
- (void)exitRound;

- (void)enterRumbleToBuild:(BOOL)tobuld;
- (void)enterRumbleAnimDidStop;
- (void)exitRumble;
- (void)exitRumbleAnimDidStop;

#pragma mark -
#pragma mark Events

- (void)endTurnButtonClicked;


#pragma mark -
#pragma mark Helper Functions

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
- (BOOL)rumbleTargetIsUsableForPlayer:(Player *)p;
- (void)swapRumbleTargetForPlayer:(Player *)p;

- (CGPoint)convertedPoint:(CGPoint)point;
- (CGRect)convertedRect:(CGRect)rect;
- (BOOL)isInRumble;

- (BOOL)isBadgeTypeUsed:(BadgeType)t;

#pragma mark -
#pragma mark Tunings

+ (int)scoreForBadgeType:(BadgeType)type;
+ (NSString *)descriptionForBadgeType:(BadgeType)type;
+ (NSString *)descriptionForResourceType:(ResourceType)type;

- (int)numberOfSharedTokens;
- (float)buildTime;


//- (Player *)currentPlayer;

@end

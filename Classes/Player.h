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
#import "Badge.h"
#import "AmountContainer.h"

@class Project;
@class Board;
@class GameLogic;

@interface Player : NSObject <NSCoding>{
	BOOL isHuman;
	Token * token;
	int ID;
	CGPoint initialTokenPosition;
	
	GameLogic * gameLogic;
	
	AmountContainer * tokenAmounts;
	AmountContainer * rumbleTargetAmounts;
	
	AmountContainer * lockedAmounts;
		
	int badgeScore;	
	int resourceScore;
	int buildScore;
	
	int score;
	
	Board * board;
	BOOL aiProcessInProgress;
	
	BOOL roundAmountUpdated;
	BOOL rectAmountUpdated;
	BOOL squareAmountUpdated;
	
	NSMutableArray * badges;
	NSMutableArray * projects;
	
	NSString * name;
	
}

@property BOOL isHuman;
@property BOOL aiProcessInProgress;

@property int ID;
@property (nonatomic,retain) Token * token;
@property (nonatomic,retain) NSMutableArray * projects;
@property (nonatomic,retain) NSMutableArray * badges;


@property (nonatomic,assign) CGPoint initialTokenPosition;
@property (nonatomic,copy) NSString * name;


@property (nonatomic,retain) AmountContainer * tokenAmounts;
@property (nonatomic,retain) AmountContainer * rumbleTargetAmounts;
@property (nonatomic,retain) AmountContainer * lockedAmounts;

//@property int roundAmount;
//@property int rectAmount;
//@property int squareAmount;
//@property int robotAmount;
//@property int snakeAmount;
//@property int palaceAmount;
@property int resourceScore;
@property int buildScore;
@property int badgeScore;
@property int score;


@property BOOL roundAmountUpdated;
@property BOOL rectAmountUpdated;
@property BOOL squareAmountUpdated;

- (void)initGameWithID:(int)playerID;

- (int)amountOfResource:(ResourceType)type;
- (void)modifyResource:(ResourceType)type by:(int)value;
- (int)amountOfUsableResource:(ResourceType)type;

- (int)amountOfRumbleTarget:(RumbleTargetType)type;

- (void)processAI;
- (void)AImoveComplete;
- (void)randomWait:(SEL)selector andDelay:(float)delay;

- (void)rumbleAI;

- (void)removeAllBadges;
- (void)addBadgeWithType:(BadgeType)type;
- (void)addMaximumResourceBadgeWithType:(ResourceType)type;
- (void)addEnoughResourceBadgeWithType:(ResourceType)type;
- (void)addHasRumbleTargetBadgeWithType:(RumbleTargetType)type;

- (BOOL)hasBadgeWithType:(BadgeType)type;

- (NSArray *)badges;

- (void)enterRound;

- (void)addProject:(Project *)p;
- (void)projectComplete:(Project *)p;

@end

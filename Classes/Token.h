//
//  Token.h
//  BoardGame
//
//  Created by Liz on 10-5-1.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeDef.h"
@class Player;

@class GameLogic;
@class GameVisual;


//Token can be moved around, sometimes there's a restrictive area for where the 
//token must stay within.

@interface Token : UIImageView {
	BOOL isMatched;
	BOOL hasMoved;
	BOOL pickedUp;
	BOOL shared;
	BOOL locked;
	//int ownerID; // Color of the token will be accessed by the ownerID;
	Player * player;
	TokenType type;
	
	CGRect boundary;
	GameLogic * gameLogic;
	RoundState roundState;
	
	CGPoint lastPosition;
	MoveFlag moveFlag;
	
	int onBoardID;
}

@property (nonatomic, assign) BOOL pickedUp;
@property (nonatomic, assign) BOOL shared;
@property (nonatomic, assign) BOOL isMatched;
@property (nonatomic, assign) BOOL locked;
@property (nonatomic, assign) BOOL hasMoved;
@property (nonatomic, assign) int onBoardID;


@property (nonatomic, assign) TokenType type;
@property (nonatomic, assign) CGRect boundary;
@property (nonatomic, assign) Player * player;
@property (nonatomic, assign) CGPoint lastPosition;



+ (id)tokenWithType:(TokenType)aType andPosition:(CGPoint)p;
- (void)moveTo:(CGPoint)position withMoveFlag:(MoveFlag)flag;
- (void)moveToLastPosition;
- (void)AImoveComplete;

- (void)tokenOnTile:(BOOL)onTile;
- (void)removeAnimDidStop;

@end

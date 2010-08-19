//
//  Player.m
//  BoardGame
//
//  Created by Liz on 10-5-1.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "Player.h"
#import "GameLogic.h"
#import "Tile.h"
#import "Board.h"

@interface Player (Private)

- (void)highlightComplete;

@end

@implementation Player

@synthesize isHuman,token,ID,initialTokenPosition,roundAmount,squareAmount,rectAmount;
@synthesize robotAmount,snakeAmount,palaceAmount,aiProcessInProgress,score,buildScore,resourceScore;
@synthesize roundAmountUpdated, rectAmountUpdated, squareAmountUpdated;

#pragma mark -
#pragma mark Common

- (CGPoint)initialTokenPosition{
	return [gameLogic convertedPoint:initialTokenPosition];
}

- (id)init{
	if (self = [super init]){
		gameLogic = [GameLogic sharedInstance];
		roundAmount = 0;
		squareAmount = 0;
		rectAmount = 0;
		robotAmount = 0;
		snakeAmount = 0;
		palaceAmount = 0;
		
		rectAmountUpdated = NO;
		roundAmountUpdated = NO;
		squareAmountUpdated = NO;
	}
	return self;
}

- (void)initGameWithID:(int)playerID{
	board = gameLogic.board;
	
	//int position[] = {100,924,100,100,668,100,668,924};
	////initialTokenPosition = CGPointMake(position[playerID*2], position[playerID*2+1]);
	
	self.token = [Token tokenWithType:TokenTypePlayer andPosition:initialTokenPosition];
	ID = playerID;
	token.player = self;
	
	[board addView:token];
	
}


- (void)setRobotAmount:(int)newAmount{
	robotAmount = newAmount;
	[board update];
}

- (void)setSnakeAmount:(int)newAmount{
	snakeAmount = newAmount;
	[board update];
}

- (void)setPalaceAmount:(int)newAmount{
	palaceAmount = newAmount;
	[board update];
}

- (void)setToken:(Token *)newToken{
	newToken.player = self;
	[token release];
	token = newToken;
	[newToken retain];
}


- (void)setRectAmount:(int)newAmount{
	rectAmount = newAmount;
	rectAmountUpdated = YES;
	[board update];	
	[self performSelector:@selector(highlightComplete) withObject:self afterDelay:HighlightTime];
}

- (void)setRoundAmount:(int)newAmount{
	roundAmount = newAmount;
	roundAmountUpdated = YES;
	[board update];	
	[self performSelector:@selector(highlightComplete) withObject:self afterDelay:HighlightTime];
}

- (void)setSqareAmount:(int)newAmount{
	squareAmount = newAmount;
	squareAmountUpdated = YES;
	[board update];	
	[self performSelector:@selector(highlightComplete) withObject:self afterDelay:HighlightTime];
}

- (void)highlightComplete{
	rectAmountUpdated = NO;
	roundAmountUpdated = NO;
	squareAmountUpdated = NO;
	[board update];		
}

- (int)amountOfResource:(ResourceType)type{
	switch (type) {
		case ResourceTypeRect:
			return rectAmount;
			break;
		case ResourceTypeRound:
			return roundAmount;
			break;
		case ResourceTypeSquare:
			return squareAmount;
			break;
		default:
			return 0;
			break;
	}
}

- (BOOL)modifyResource:(ResourceType)type by:(int)value{
	switch (type) {
		case ResourceTypeRect:
			self.rectAmount+=value;
			break;
		case ResourceTypeRound:
			self.roundAmount+=value;
			break;
		case ResourceTypeSquare:
			self.squareAmount+=value;
			break;
		default:
			return NO;
			break;
	}	
	return YES;
}

#pragma mark -
#pragma mark Normal Round AI

- (void)processAI{
	if (aiProcessInProgress) {
		return;
	}
	aiProcessInProgress = YES;
	[self randomWait:@selector(waitComplete) andDelay:WaitTime];
}

- (void)randomWait:(SEL)selector andDelay:(float)delay{
	[self performSelector:selector withObject:nil afterDelay:rand()%100*0.01*delay+delay];
}

- (void)waitComplete{
	Tile * tile;
	do {
		tile = [gameLogic randomTile];
	} while (tile.state == TileStateSelected || ![tile availableForPlayer:self]);
	[token moveTo:CGPointMake(tile.center.x + 20, tile.center.y + 10) byAI:YES inState:gameLogic.round.state];
}

- (void)AImoveComplete{
	[self randomWait:@selector(nextTurn) andDelay:WaitTime/2];
}

- (void)nextTurn{
	aiProcessInProgress = NO;
	[gameLogic endTurnButtonClicked];
}


#pragma mark -
#pragma mark Rumble AI

// Wait for a random delay
// Find a random token to move
// Move to a random position

- (void)rumbleAI{
	[self randomWait:@selector(rumbleMove) andDelay:RumbleWaitTime+(rand()%10)/10-0.5];	
}

- (void)rumbleMove{
	//Check if still in rumble
	
	if (gameLogic.round.state != RoundStateRumble && gameLogic.turn.state != TurnStateBuild) {
		return;
	}
	
	Token * randomToken = [gameLogic randomRumbleTokenForPlayer:self];
	if (randomToken == nil) {
		return;
	}
	
	CGPoint targetPosition = [gameLogic randomRumblePositionForPlayer:self withToken:randomToken];	
	
	if (!CGPointEqualToPoint(targetPosition, CGPointZero)) {
		[randomToken moveTo:targetPosition byAI:YES inState:RoundStateRumble];
	}
	[self randomWait:@selector(rumbleMove) andDelay:RumbleWaitTime+(rand()%10)/10-0.5];	

}


#pragma mark -
#pragma mark Serialization

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeBool:isHuman forKey:@"isHuman"];
    [coder encodeInt:ID forKey:@"ID"];
    [coder encodeInt:roundAmount forKey:@"roundAmount"];
    [coder encodeInt:rectAmount forKey:@"rectAmount"];	
    [coder encodeInt:squareAmount forKey:@"squareAmount"];
	
    [coder encodeInt:robotAmount forKey:@"robotAmount"];	
    [coder encodeInt:snakeAmount forKey:@"snakeAmount"];	
    [coder encodeInt:palaceAmount forKey:@"palaceAmount"];
}


- (id)initWithCoder:(NSCoder *)coder {
	self = [[Player alloc]init];
	
    isHuman = [coder decodeBoolForKey:@"isHuman"];
    ID = [coder decodeIntForKey:@"ID"];
	
    roundAmount = [coder decodeIntForKey:@"roundAmount"];
    rectAmount = [coder decodeIntForKey:@"rectAmount"];
    squareAmount = [coder decodeIntForKey:@"squareAmount"];

    robotAmount = [coder decodeIntForKey:@"robotAmount"];
    snakeAmount = [coder decodeIntForKey:@"snakeAmount"];
    palaceAmount = [coder decodeIntForKey:@"palaceAmount"];	
	
	//additional inits
	gameLogic = [GameLogic sharedInstance];
	
	[self initGameWithID:ID];
	
    return self;
}


@end

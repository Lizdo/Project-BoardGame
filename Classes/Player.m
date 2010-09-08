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
#import "Project.h"

@interface Player (Private)

- (void)highlightComplete;
- (void)swapRumbleTarget;

@end

@implementation Player

@synthesize isHuman,token,ID,initialTokenPosition, tokenAmounts, rumbleTargetAmounts;
@synthesize aiProcessInProgress,score,buildScore,resourceScore,badgeScore;
@synthesize roundAmountUpdated, rectAmountUpdated, squareAmountUpdated, name, projects;

#pragma mark -
#pragma mark Common

- (CGPoint)initialTokenPosition{
	return [gameLogic convertedPoint:initialTokenPosition];
}

- (id)init{
	if (self = [super init]){
		gameLogic = [GameLogic sharedInstance];
//		roundAmount = 0;
//		squareAmount = 0;
//		rectAmount = 0;
//		robotAmount = 0;
//		snakeAmount = 0;
//		palaceAmount = 0;
		
		self.tokenAmounts = [AmountContainer emptyAmountContainer];
		self.rumbleTargetAmounts = [AmountContainer emptyAmountContainer];
		
		rectAmountUpdated = NO;
		roundAmountUpdated = NO;
		squareAmountUpdated = NO;
		
		self.projects = [NSMutableArray arrayWithCapacity:0];
	}
	return self;
}

- (void)initGameWithID:(int)playerID{
	board = [Board sharedInstance];
	
	//int position[] = {100,924,100,100,668,100,668,924};
	////initialTokenPosition = CGPointMake(position[playerID*2], position[playerID*2+1]);
	
	self.token = [Token tokenWithType:TokenTypePlayer andPosition:initialTokenPosition];
	ID = playerID;
	token.player = self;
	self.name = [NSString stringWithFormat:@"Player %d", playerID]; 
	[board addView:token];
	
}


//- (void)setRobotAmount:(int)newAmount{
//	robotAmount = newAmount;
//	[board update];
//}
//
//- (void)setSnakeAmount:(int)newAmount{
//	snakeAmount = newAmount;
//	[board update];
//}
//
//- (void)setPalaceAmount:(int)newAmount{
//	palaceAmount = newAmount;
//	[board update];
//}

- (void)setToken:(Token *)newToken{
	newToken.player = self;
	[token release];
	token = newToken;
	[newToken retain];
}

//
//- (void)setRectAmount:(int)newAmount{
//	rectAmount = newAmount;
//	rectAmountUpdated = YES;
//	[board update];	
//	[self performSelector:@selector(highlightComplete) withObject:self afterDelay:HighlightTime];
//}
//
//- (void)setRoundAmount:(int)newAmount{
//	roundAmount = newAmount;
//	roundAmountUpdated = YES;
//	[board update];	
//	[self performSelector:@selector(highlightComplete) withObject:self afterDelay:HighlightTime];
//}
//
//- (void)setSqareAmount:(int)newAmount{
//	squareAmount = newAmount;
//	squareAmountUpdated = YES;
//	[board update];	
//	[self performSelector:@selector(highlightComplete) withObject:self afterDelay:HighlightTime];
//}
//
//- (void)highlightComplete{
//	rectAmountUpdated = NO;
//	roundAmountUpdated = NO;
//	squareAmountUpdated = NO;
//	[board update];		
//}

- (int)amountOfResource:(ResourceType)type{
	return [tokenAmounts amountForIndex:type];
}

- (void)modifyResource:(ResourceType)type by:(int)value{
	[tokenAmounts modifyAmountForIndex:type by:value];
}

- (int)amountOfRumbleTarget:(RumbleTargetType)type{
	return [rumbleTargetAmounts amountForIndex:type];

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
	[token moveTo:CGPointMake(tile.center.x + 20, tile.center.y + 10) byAI:YES inState:[Round sharedInstance].state];
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

// If current Rumble Target is useless, switch after a delay
// Else
//   Wait for a random delay
//   Find a random token to move
//   Move to a random position

- (void)rumbleAI{
	//Check if is useless
	if (![gameLogic rumbleTargetIsUsableForPlayer:self]) {
		[self randomWait:@selector(swapRumbleTarget) andDelay:RumbleWaitTime+(rand()%10)/10-0.5];	
	}else {
		[self randomWait:@selector(rumbleMove) andDelay:RumbleWaitTime+(rand()%10)/10-0.5];	

	}
}

- (void)swapRumbleTarget{
	[gameLogic swapRumbleTargetForPlayer:self];
}

- (void)rumbleMove{
	//Check if still in rumble
	if ([Round sharedInstance].state != RoundStateRumble && [Turn sharedInstance].state != TurnStateBuild) {
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


- (void)removeAllBadges{
	if(badges){
		[badges removeAllObjects];
	}else {
		badges = [NSMutableArray arrayWithCapacity:0];
		[badges retain];
	}
}

- (void)addBadgeWithType:(BadgeType)type{
	if (badges == nil) {
		[self removeAllBadges];
	}
	Badge * b = [Badge badgeWithType:type];
	b.player = self;
	[badges addObject:b];
	[badges sortUsingSelector:@selector(compare:)];
}

- (void)addMaximumResourceBadgeWithType:(ResourceType)type{
	[self addBadgeWithType:[Badge maximumBadgeTypeForResource:type]];
}

- (NSArray *)badges{
	return badges;
}

- (NSComparisonResult)compare:(Player *)p{
	return [[NSNumber numberWithInt:self.score] compare:[NSNumber numberWithInt:p.score]];
}


- (void)enterRound{
	for (Project * p in projects){
		[p enterRound];
	}
}

- (void)addProject:(Project *)p{
	if ([projects indexOfObject:p] == NSNotFound) {
		[projects addObject:p];
		//update locked resource
		
	}
}


- (void)projectComplete:(Project *)p{
	
}


#pragma mark -
#pragma mark Serialization

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeBool:isHuman forKey:@"isHuman"];
    [coder encodeInt:ID forKey:@"ID"];
//    [coder encodeInt:roundAmount forKey:@"roundAmount"];
//    [coder encodeInt:rectAmount forKey:@"rectAmount"];	
//    [coder encodeInt:squareAmount forKey:@"squareAmount"];
//	
//    [coder encodeInt:robotAmount forKey:@"robotAmount"];	
//    [coder encodeInt:snakeAmount forKey:@"snakeAmount"];	
//    [coder encodeInt:palaceAmount forKey:@"palaceAmount"];
	
	[coder encodeObject:tokenAmounts forKey:@"tokenAmounts"];
	[coder encodeObject:rumbleTargetAmounts forKey:@"rumbleTargetAmounts"];
	
    [coder encodeObject:name forKey:@"name"];
	[coder encodeObject:projects forKey:@"projects"];

	
}


- (id)initWithCoder:(NSCoder *)coder {
	self = [[Player alloc]init];
	
    isHuman = [coder decodeBoolForKey:@"isHuman"];
    ID = [coder decodeIntForKey:@"ID"];
	
//    roundAmount = [coder decodeIntForKey:@"roundAmount"];
//    rectAmount = [coder decodeIntForKey:@"rectAmount"];
//    squareAmount = [coder decodeIntForKey:@"squareAmount"];
//
//    robotAmount = [coder decodeIntForKey:@"robotAmount"];
//    snakeAmount = [coder decodeIntForKey:@"snakeAmount"];
//    palaceAmount = [coder decodeIntForKey:@"palaceAmount"];
	
	self.tokenAmounts = [coder decodeObjectForKey:@"tokenAmounts"];
	self.rumbleTargetAmounts = [coder decodeObjectForKey:@"rumbleTargetAmounts"];
	
	self.name = [coder decodeObjectForKey:@"name"];
	self.projects = [coder decodeObjectForKey:@"projects"];

	//additional inits
	gameLogic = [GameLogic sharedInstance];
	
	[self initGameWithID:ID];
	
    return self;
}



- (void)dealloc{
	[badges release];
	[super dealloc];
}

@end

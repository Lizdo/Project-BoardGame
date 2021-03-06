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
- (void)addTokenForBoard:(NSNumber *)info;
- (void)removeTokenForBoard:(NSNumber *)info;

@end

@implementation Player

@synthesize isHuman,token,ID,initialTokenPosition, tokenAmounts, rumbleTargetAmounts, lockedAmounts;
@synthesize aiProcessInProgress,score,buildScore,resourceScore,badgeScore;
@synthesize roundAmountUpdated, rectAmountUpdated, squareAmountUpdated, name, projects, badges;

#pragma mark -
#pragma mark Common

- (CGPoint)initialTokenPosition{
	return [gameLogic convertedPoint:initialTokenPosition];
}

- (id)init{
	if (self = [super init]){
		gameLogic = [GameLogic sharedInstance];
		
		self.tokenAmounts = [AmountContainer emptyAmountContainer];
		self.rumbleTargetAmounts = [AmountContainer emptyAmountContainer];
		self.lockedAmounts = [AmountContainer emptyAmountContainer];
		
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
	self.token.transform = [GameVisual transformForPlayerID:playerID];
	ID = playerID;
	token.player = self;
	self.name = [NSString stringWithFormat:@"Player %d", playerID]; 
	[board addView:token];
	
	//Give tokens according to token number
	for (int i = 0; i < NumberOfTokenTypes; i++) {
		for (int j = 0; j < [tokenAmounts amountForIndex:i]; j++) {
			[board addTokenForPlayerID:ID withType:i andAnim:NO];
		}
	}
		
}


- (void)setToken:(Token *)newToken{
	newToken.player = self;
	[token release];
	token = newToken;
	[newToken retain];
}

- (int)amountOfResource:(ResourceType)type{
	return [tokenAmounts amountForIndex:type];
}

- (int)amountOfUsableResource:(ResourceType)type{
	return [tokenAmounts amountForIndex:type] - [lockedAmounts amountForIndex:type];
}

- (void)modifyResource:(ResourceType)type by:(int)value{
	//Inform Board to Spawn a new Token
	if (value > 0) {
		int num = value;
		while (num > 0){
			NSNumber * info = [NSNumber numberWithInt:type];
			[self performSelector:@selector(addTokenForBoard:) withObject:info afterDelay:num*TokenSpawnInterval];
			num --;
		}
	}else {
		int num = -value;
		while (num > 0) {
			NSNumber * info = [NSNumber numberWithInt:type];
			[self performSelector:@selector(removeTokenForBoard:) withObject:info afterDelay:num*TokenSpawnInterval];			
			num --;
		}
	}
	[tokenAmounts modifyAmountForIndex:type by:value];
}
							   
- (void)addTokenForBoard:(NSNumber *)info{
	int type = [info intValue];
	[board addTokenForPlayerID:ID withType:type andAnim:YES];

}

- (void)removeTokenForBoard:(NSNumber *)info{
	int type = [info intValue];	
	[board removeTokenForPlayerID:ID withType:type];
}

- (int)amountOfRumbleTarget:(RumbleTargetType)type{
	return [rumbleTargetAmounts amountForIndex:type];

}


- (void)moveTokenToTile:(Tile *)tile{
	[token moveTo:CGPointMake(tile.center.x + 20, tile.center.y + 10) withMoveFlag:MoveFlagAINormal];
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
	[token moveTo:CGPointMake(tile.center.x + 20, tile.center.y + 10) withMoveFlag:MoveFlagAINormal];
}

- (void)AImoveComplete{
	[self randomWait:@selector(nextTurn) andDelay:WaitTime/2];
}

- (void)nextTurn{
	if ([Game sharedInstance].paused) {
		[self AImoveComplete];
		return;
	}
	if (gameLogic.currentPlayer == self) {
		aiProcessInProgress = NO;
		[gameLogic endTurnButtonClicked];
	}else {
		return;
	}

}


#pragma mark -
#pragma mark Rumble AI

// If current Rumble Target is useless, switch after a delay
// Else
//   Wait for a random delay
//   Find a random token to move
//   Move to a random position

- (void)rumbleAI{
	if ([Rumble sharedInstance].timeRemaining <= RumbleWaitTime ) {
		return;
	}
	//Check if is useless
	if ([gameLogic allRumbleTargetsNotUsableForPlayer:self]) {
		return;
	}
	
	if (![gameLogic rumbleTargetIsUsableForPlayer:self]) {
		[self randomWait:@selector(swapRumbleTarget) andDelay:RumbleWaitSwapTime+(rand()%10)/10-0.5];	
	}else {
		[self randomWait:@selector(rumbleMove) andDelay:RumbleWaitTime+(rand()%10)/10-0.5];	

	}
}

- (void)swapRumbleTarget{
	[gameLogic swapRumbleTargetForPlayer:self];
	[self randomWait:@selector(rumbleAI) andDelay:RumbleWaitSwapTime+(rand()%10)/10-0.5];
}

- (void)rumbleMove{
	//Check if still in rumble
	if (![gameLogic isInRumble] || [Game sharedInstance].paused) {
		return;
	}
	
	Token * randomToken = [gameLogic randomRumbleTokenForPlayer:self];
	if (randomToken == nil) {
		return;
	}
	
	CGPoint targetPosition = [gameLogic randomRumblePositionForPlayer:self withToken:randomToken];	
	
	if (!CGPointEqualToPoint(targetPosition, CGPointZero)) {
		[randomToken moveTo:targetPosition withMoveFlag:MoveFlagAIRumble];
	}
	[self randomWait:@selector(rumbleAI) andDelay:RumbleWaitTime+(rand()%10)/10-0.5];	

}


- (void)removeAllBadges{
	if(badges && [badges count] > 0){
		//[badges removeAllObjects];
		NSMutableArray * newArray = [NSMutableArray arrayWithCapacity:0];
		for (Badge * b in badges) {
			if (b.isPermanent) {
				[newArray addObject:b];
			}
		}
		[badges removeAllObjects];
		self.badges = newArray;
	}else {
		self.badges = [NSMutableArray arrayWithCapacity:0];
	}
}

- (void)addBadgeWithType:(BadgeType)type{
	if ([self hasBadgeWithType:type]) {
		return;
	}
	
	if ([Badge isBadgeTypeExclusive:type] && [gameLogic isBadgeTypeUsed:type]) {
		DebugLog(@"Type @d used", type);
		return;
	}
	
	if (badges == nil) {
		self.badges = [NSMutableArray arrayWithCapacity:0];
	}

	Badge * b = [Badge badgeWithType:type];
	b.player = self;
	[badges addObject:b];
	[badges sortUsingSelector:@selector(compare:)];
	DebugLog(@"Badge Type %@ added for player ID: %d", [GameLogic descriptionForBadgeType:b.type], ID);
}

- (void)addMaximumResourceBadgeWithType:(ResourceType)type{
	[self addBadgeWithType:type];
}

- (void)addEnoughResourceBadgeWithType:(ResourceType)type{
	[self addBadgeWithType:type+20];
}

- (BOOL)hasBadgeWithType:(BadgeType)type{
	if (!badges) {
		return NO;
	}
	for (Badge * b in badges) {
		if (b.type == type) {
			return YES;
		}
	}
	return NO;
}

- (NSArray *)badges{
	return badges;
}

- (NSComparisonResult)compare:(Player *)p{
	return [[NSNumber numberWithInt:self.score] compare:[NSNumber numberWithInt:p.score]];
}


- (void)enterRound{
}

- (void)exitRumble{
	for (Project * p in projects){
		[p exitRumble];
	}
	
	self.lockedAmounts = [AmountContainer emptyAmountContainer];
	
	for (Project * p in projects){
		if (!p.isCompleted) {
			[lockedAmounts addAmount:p.lockedResource];
		}
	}
	
	//set locked tokens
	[board setLockedTokenForPlayerID:ID];
}


- (void)addProject:(Project *)p{
	if ([projects indexOfObject:p] == NSNotFound) {
		[projects insertObject:p atIndex:0];
		//[rumbleTargetAmounts modifyAmountForIndex:p.type by:1];
		//Add amount when project completes
	}
}


- (void)projectComplete:(Project *)p{
	
}

- (NSString *)scoreDescription{
	//header
	NSString * s = @"";
	
	//Resources
	s = [s stringByAppendingFormat:@"<H2>Resources<span class = 'score'>%d</span></H2>", resourceScore];
	for (int i = 0; i<NumberOfTokenTypes; i++) {
		s = [s stringByAppendingFormat:@"<p>%@: %d x %d<span class = 'score'>%d</span></p>",
			 [GameLogic descriptionForResourceType:i], 
			 [self amountOfResource:i], 
			 TokenScoreModifier[i],
			 [self amountOfResource:i] * TokenScoreModifier[i]];
	}
	
	//Projects
	s = [s stringByAppendingFormat:@"<H2>Projects<span class = 'score'>%d</span></H2>", buildScore];
	for (int i = 0; i<[projects count]; i++) {
		Project * p = [projects objectAtIndex:i];
		if (p.isCompleted) {
			s = [s stringByAppendingFormat:@"<img src = '%@'/>", [GameVisual imageNameForRumbleType:p.type]];
		}
	}
	
	//Badgess
	s = [s stringByAppendingFormat:@"<H2>Badges<span class = 'score'>%d</span></H2>", badgeScore];
	for (int i = 0; i<[badges count]; i++) {
		Badge * b = [badges objectAtIndex:i];
		s = [s stringByAppendingFormat:@"<img src = '%@'/>", [GameVisual imageNameForBadgeType:b.type]];
	}
	return s;
}



#pragma mark -
#pragma mark Serialization

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeBool:isHuman forKey:@"isHuman"];
    [coder encodeInt:ID forKey:@"ID"];
	
	[coder encodeObject:tokenAmounts forKey:@"tokenAmounts"];
	[coder encodeObject:rumbleTargetAmounts forKey:@"rumbleTargetAmounts"];
	
    [coder encodeObject:name forKey:@"name"];
	[coder encodeObject:projects forKey:@"projects"];

	
}


- (id)initWithCoder:(NSCoder *)coder {
	self = [[Player alloc]init];
	
    isHuman = [coder decodeBoolForKey:@"isHuman"];
    ID = [coder decodeIntForKey:@"ID"];
	
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

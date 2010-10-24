//
//  GameLogic.m
//  BoardGame
//
//  Created by Liz on 10-5-1.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "GameLogic.h"
#import "Tile.h"
#import "Board.h"
#import "RumbleBoard.h"
#import "Project.h"


@interface GameLogic (Private)
- (void)initPlayers:(int)playerNumber;
- (void)initTiles;
- (void)addTileWithType:(TileType)aType andPosition:(CGPoint)position;
- (Tile *)addTileWithInfo:(int *)info;
- (NSArray *)playersWithMaximumResource:(ResourceType)type;

- (void)enterRound;
- (void)processTile;

@end

static GameLogic *sharedInstance = nil;

@implementation GameLogic

@synthesize players,board,game,round,turn,rumble,currentPlayer,tiles,specialTiles,rumbleTargets,rumbleTokens,rumbleInfos,animationInProgress;

#pragma mark -
#pragma mark Inits

- (id)init{
	if (self = [super init]){
		//[self initPlayers];
		self.tiles = [NSMutableArray arrayWithCapacity:0];
		self.specialTiles = [NSMutableArray arrayWithCapacity:0];
		rumbleTargets = [[NSMutableArray arrayWithCapacity:0] retain];
		rumbleTokens = [[NSMutableArray arrayWithCapacity:0] retain];
		rumbleInfos = [[NSMutableArray arrayWithCapacity:0] retain];		

	}
	return self;
}

//  [Type, x, y, sourceType, sourceAmount, targetType, targetAmount, accumulateRate]
static int tileInfos[18][8] = {
	//row 0
	//{TileTypeGetResource, 0, 0, 0,0,ResourceTypeRound,2,0},
	{TileTypeAccumulateResource, 0, 0, 0,0,ResourceTypeRound,0,1},
	{TileTypeGetResource, 0, 0, 0,0,ResourceTypeRect,1,0},
	{TileTypeExchangeResource, 0, 0, ResourceTypeRound,1,ResourceTypeRect,1,0},	
	{TileTypeAccumulateResource, 0, 0, 0,0,ResourceTypeRound,0,1},
	{TileTypeGetResource, 0, 0, 0,0,ResourceTypeSquare,1,0},
	{TileTypeBuild, 0, 0, 0,0,ResourceTypeRect,0,0},
	//row 1
	{TileTypeExchangeResource, 0, 0, ResourceTypeRect,1,ResourceTypeRound,4,0},	
	{TileTypeAccumulateResource, 0, 0, 0,0,ResourceTypeRect,0,1},
	{TileTypeExchangeResource, 0, 0, ResourceTypeSquare,1,ResourceTypeRect,3,0},	
	{TileTypeBuild, 0, 0, 0,0,ResourceTypeRound,0,0},	
	{TileTypeExchangeResource, 0, 0, ResourceTypeRound,1,ResourceTypeRect,2,0},	
	{TileTypeLucky, 0, 0, 0,0,ResourceTypeRect,0,0},
	//row 2
	{TileTypeAccumulateResource, 0, 0, 0,0,ResourceTypeSquare,0,1},
	{TileTypeBuild, 0, 0, 0,0,ResourceTypeRect,0,0},
	{TileTypeLucky, 0, 0, 0,0,ResourceTypeRect,0,0},
	{TileTypeGetResource, 0, 0, 0,0,ResourceTypeRound,1,0},
	{TileTypeGetResource, 0, 0, 0,0,ResourceTypeRect,1,0},
	{TileTypeGetResource, 0, 0, 0,0,ResourceTypeSquare,1,0},
};


- (void)initPlayers:(int)playerNumber{
	int HumanPlayers[5][4] = {
		{0,0,0,0},
		{1,0,0,0},
		{1,0,1,0},
		{1,1,1,0},
		{1,1,1,1},
	};
	
	self.players = [NSMutableArray arrayWithCapacity:0];
	for (int i=0; i<=3; i++) {
		Player * p = [[Player alloc]init];
		p.isHuman = HumanPlayers[playerNumber][i];//NO
		[players addObject:p];
		[p initGameWithID:i];
		[p release];
	}
	currentPlayerID = -2;	
}

- (void)initTiles{
	//init tiles
	for (int i=0;i<6;i++){
		for (int j=0; j<3;j++) {
			int x = TileStartingX + j * (TileWidth+TileInterval) + TileWidth/2;
			int y = TileStartingY + i * (TileHeight+TileInterval) + TileHeight/2;
			//  [Type, x, y, sourceType, sourceAmount, targetType, targetAmount, accumulateRate]
			int * tileInfo = tileInfos[i*3+j];
			tileInfo[1] = x;
			tileInfo[2] = y;
			//[self addTileWithType:TileTypeGetResource andPosition:CGPointMake(x, y)];
			Tile * t = [self addTileWithInfo:tileInfo];
			t.ID = i*3+j;
			if(i == 5){
				[specialTiles addObject:t];
				t.isSpecial = YES;
				t.state = TileStateAvailable;
			}
		}
	}
	
}

- (void)initGameWithPlayerNumber:(int)playerNumber{
	[self initTiles];
	[self initPlayers:playerNumber];
	
	[board initGame];
	rumbleBoard = [RumbleBoard sharedInstance];
	[rumbleBoard initGame];
	
}

- (void)resumeGame{
	//Player & Tile has already been restored.
	[board initGame];
	rumbleBoard = [RumbleBoard sharedInstance];
	[rumbleBoard initGame];
}


- (void)addTileWithType:(TileType)aType andPosition:(CGPoint)position{
	Tile * tile = [Tile tileWithType:aType andPosition:position];
	[board addView:tile];
	[tiles addObject:tile];
}
			 
- (Tile *)addTileWithInfo:(int *)info{
	 Tile * tile = [Tile tileWithInfo:info];
	 [board addView:tile];
	 [tiles addObject:tile];
	 tile.state = TileStateHidden;
	 return tile;
 }

			 
#pragma mark -
#pragma mark Updates


- (void)triggerEvent:(TokenEvent)event withToken:(Token *)token atPosition:(CGPoint)point{
	//Play Sound
	switch (event) {
		case TokenEventPickedUp:
			[[SoundManager sharedInstance] playSoundWithTag:SoundTagPickup];
			break;
		case TokenEventDroppedDown:
			[[SoundManager sharedInstance] playSoundWithTag:SoundTagDropDown];
			break;			
		default:
			break;
	}
	
	//Process Tiles in Normal State
	if (![self isInRumble]) {
		if (token.player != self.currentPlayer || token.type != TokenTypePlayer)
			return;
		// For Tile we don't care about the event type
		BOOL selectedTileFound = NO;
		for (Tile * tile in tiles){
			if (tile.state == TileStateAvailable || tile.state == TileStateSelected || tile.state == TileStateRejected){
				if (CGRectContainsPoint(tile.frame, point)){
					if ([tile availableForPlayer:[self currentPlayer]]) {
						tile.state = TileStateSelected;
						turn.selectedTile = tile;
						selectedTileFound = YES;
					}else {
						tile.state = TileStateRejected;
					}
				}else {
					tile.state = TileStateAvailable;
				}
			}
		}
		selectedTileFound ? [board enableEndTurnButton] : [board disableEndTurnButton];
		selectedTileFound ? [token tokenOnTile:YES] : [token tokenOnTile:NO];

	}
	
	//Process RumbleTargets in Rumble State
	if ([self isInRumble]) {
		//check which player
		NSArray * rumbleTargetsToCheck;
		if (turn.state == TurnStateBuild) {
			rumbleTargetsToCheck = [self rumbleTargetsOfPlayer:currentPlayer];
		}
		else if (token.shared) {
			rumbleTargetsToCheck = rumbleTargets;
		}else {
			rumbleTargetsToCheck = [self rumbleTargetsOfPlayer:token.player];
		}

		for (RumbleTarget * rt in rumbleTargetsToCheck){
			CGPoint pointInRT = [rt convertPoint:point fromView:rumbleBoard];
			if (CGRectContainsPoint(rt.bounds, pointInRT)){
				[rt triggerEvent:event withToken:token atPosition:pointInRT];
			}
		}
	}

}


- (void)updateNewRound{
	//One new tile each round
	[self unlockNewTile];
	[self performSelector:@selector(enterRound) withObject:self afterDelay:WaitTime];
}
	
- (void)enterRound{
	//For special tiles, update the value
	for (int i = 0; i<[specialTiles count];i++) {
		Tile * t = [specialTiles objectAtIndex:i];
		t.targetAmount = MAX(round.count/(i+3)-2,1);
	}
	
	for (Tile * t in tiles) {
		if (t.state != TileStateHidden) {
			[t update];
		}
	}		
	
	currentPlayerID++;
	if (currentPlayerID>=4)
		currentPlayerID = 0;
	
	for (Player * p in players) {
		[p enterRound];
	}
	[board enterRound];
}

- (void)exitTurn{
	//[board removeAllBadges];
	[self calculateScore];
	[board addBadges];
	[board update];

}

- (void)exitRound{
	for (Player * p in players) {
		[p.token moveTo:p.initialTokenPosition withMoveFlag:MoveFlagPlayerNormal];
		[p.token tokenOnTile:NO];	
	}	
	for (Tile * t in tiles) {
		if (t.state != TileStateHidden) {
			t.state = TileStateAvailable;
		}
	}	
}


- (void)enterRumbleToBuild:(BOOL)tobuild{
	toBuild = tobuild;
	if (toBuild) {
		[rumbleBoard rumbleWithPlayerID:currentPlayerID];	
	}else {
		[rumbleBoard allRumble];
	}

	[board enterRumble];


}

- (void)enterRumbleAnimDidStop{
	[rumble enterRumbleAnimDidStop];
	if (toBuild) {
		if (!currentPlayer.isHuman) {
			[currentPlayer rumbleAI];
		}
	}else {
		for (Player * p in players) {
			if (!p.isHuman) {
				[p rumbleAI];
			}
		}
	}
}

- (void)exitRumbleAnimDidStop{
	for (Token * t in rumbleTokens) {
		[t removeFromSuperview];
	}
	[rumbleTokens removeAllObjects];
	[rumble exitRumbleAnimDidStop];
}

- (void)exitRumble{
	[rumbleBoard removeAllPopups];
	[board exitRumble];	
//	for (RumbleTarget * rt in rumbleTargets) {
//		[rt removeFromSuperview];
//	}
//	[rumbleTargets removeAllObjects];
//	[rumbleTargets release];
	[self calculateScore];
	[board addBadges];
	
	for (Player * p in players) {
		[p exitRumble];
	}

}


- (void)updateNewTurn{
	//[currentPlayer.token tokenOnTile:NO];	
	currentPlayerID++;
	if (currentPlayerID>=4)
		currentPlayerID = 0;
	[board disableEndTurnButton];
	turn.selectedTile = nil;
    [board update];
	[board enterTurn];
}


- (void)endTurnButtonClicked{
	turn.selectedTile.state = TileStateDisabled;
	[turn.selectedTile processForPlayer:self.currentPlayer];
	[board disableEndTurnButton];
	[self performSelector:@selector(processTile) withObject:self afterDelay:TurnWaitTime];
}

- (void)processTile{
	[turn endTurnButtonClicked];
}


#pragma mark -
#pragma mark Helper Function

- (Player *)playerWithID:(int)theID{
	if (theID >= [players count])
		return nil;
	return [players objectAtIndex:theID];
}

- (void)setCurrentPlayerID:(int)newID{
	currentPlayerID = newID;
	currentPlayer = [self playerWithID:currentPlayerID];
}

- (Player *)currentPlayer{
	currentPlayer = [self playerWithID:currentPlayerID];
	return currentPlayer;
}

- (Tile *)randomTile{
	int count = [tiles count];
	Tile * tile;
	do {
		tile = [tiles objectAtIndex:rand()%count];
	} while (tile.state != TileStateAvailable);
	return tile;
}

- (TokenType)randomTokenType{
	int i = rand()%NumberOfTokenTypes;
	return i;
}


- (CGPoint)randomPositionInRect:(CGRect)rect{
	float randX = rand()%100*rect.size.width/100;
	float randY = rand()%100*rect.size.height/100;	
	return CGPointMake(randX+rect.origin.x, randY+rect.origin.y);
}

- (NSArray *)rumbleTargetsOfPlayer:(Player *)p{
	NSMutableArray * returnArray = [NSMutableArray arrayWithCapacity:0];
	for (RumbleTarget * t in rumbleTargets){
		if (t.player == p) {
			[returnArray addObject:t];
		}
	}
	return [NSArray arrayWithArray:returnArray];
}


- (RumbleTarget *)rumbleTargetForPlayer:(Player *)p{
	for (RumbleInfo * ri in rumbleInfos) {
		if (ri.player == p) {
			return ri.currentRumbleTarget;
		}
	}
	return nil;
}

- (void)unlockNewTile{
	for (Tile * t in tiles){
		if (t.state == TileStateHidden){
			t.state = TileStateAvailable;
			[t setNeedsDisplay];
			[t flipIn];
			return;
		}
	}
}

//Scoring
// Round  = 1
// Rect   = 3
// Square = 5
// Round > 5/10  = 3/7
// Rect > 4/8 = 5/11
// Square > 3/6 = 7/15
// Max Round/Rect/Square & > 5 = 7

- (void)calculateScore{
	for (int i = 0; i<4; i++){
		Player * p = [self playerWithID:i];
		[p removeAllBadges];
		
		//Enough Resource Badge
		p.resourceScore = 0;
		for (int j=0; j<NumberOfTokenTypes; j++) {
			p.resourceScore += [p amountOfResource:j]*TokenScoreModifier[j];
			if ([p amountOfResource:j] >= EnoughResource[j]) {
				[p addEnoughResourceBadgeWithType:j];
			}
		}

		//Has Project Badge		
		p.buildScore = 0;
		for (int j=0; j<NumberOfRumbleTargetTypes; j++) {
			p.buildScore += [p amountOfRumbleTarget:j]*RumbleTargetScoreModifier[j];
		}
		
		//Project Number Badge
		int projectCount = 0;
		for (Project * pr in p.projects) {
			if (pr.isCompleted) {
				projectCount++;
			}
		}
		
		if (projectCount >= 7) {
			[p addBadgeWithType:BadgeTypeSevenProjects];
		}else if (projectCount >= 5) {
			[p addBadgeWithType:BadgeTypeFiveProjects];
		}else if (projectCount >= 3) {
			[p addBadgeWithType:BadgeTypeThreeProjects];
		}else if (projectCount >=1) {
			[p addBadgeWithType:BadgeTypeOneProject];
		}

		
	}
	
	
	for (int i=0; i<NumberOfTokenTypes; i++) {
		NSArray * array = [self playersWithMaximumResource:i];
		for (Player * p in array){
			[p addMaximumResourceBadgeWithType:i];
		}
	}
	
	for (int i = 0; i<4; i++){
		Player * p = [self playerWithID:i];

		p.badgeScore = 0;
		for (Badge * b in [p badges]) {
			p.badgeScore += [b score];
		}
		
		p.score = p.buildScore + p.resourceScore + p.badgeScore;
		
	}
	
}

- (NSArray *)playersWithMaximumResource:(ResourceType)type{
	int max = 5;
	for (int i = 0; i<4; i++){
		Player * p = [self playerWithID:i];
		if ([p amountOfResource:type] > max) {
			max = [p amountOfResource:type];
		}
	}
	
	NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
	for (Player * p in players){
		if ([p amountOfResource:type] == max) {
			[array addObject:p];
		}
	}
	return [NSArray arrayWithArray:array];

}


- (Token *)randomRumbleTokenForPlayer:(Player *)p{
	Token * t;
	int iterations = 0;
	if ([rumbleTokens count] == 0) {
		//Can do nothing when there's no token on the board
		return nil;
	}
	do{
		t = [rumbleTokens objectAtIndex:rand()%[rumbleTokens count]];
		iterations ++;
	}while (((t.player != p && !t.shared) || t.isMatched) && iterations < 30);
	
	if (iterations >= 30) {
		return nil;
	}
	
	return t;
}


- (CGPoint)randomRumblePositionForPlayer:(Player *)p withToken:(Token *)t{
	RumbleTarget * rt = [self rumbleTargetForPlayer:p];
	if (!rt) {
		return CGPointZero;
	}
	CGPoint point = [rt emptyPointForToken:t];
	if (!CGPointEqualToPoint(point,CGPointZero)) {
		return point;
	}
	return CGPointZero;
}


- (BOOL)rumbleTargetIsUsableForPlayer:(Player *)p{
	RumbleTarget * rt = [self rumbleTargetForPlayer:p];
	if (!rt) {
		return NO;
	}	
	int rtTokens[5] = {0,0,0,0,0};
	for (TokenPlaceholder * t in rt.tokenPlaceholders) {
		if (!t.hasMatch) {
			rtTokens[t.type]++;
		}
	}
	
	int numTokens[5] = {0,0,0,0,0};
	for (Token * t in rumbleTokens) {
		if (t.player == p || t.shared) {
			if (!t.isMatched) {
				numTokens[t.type]++;
			}
		}
	}
	
	for (int i=1;i<4;i++) {
		if (numTokens[i] < rtTokens[i]) {
			return NO;
		}
	}
	
	return YES;
}

- (void)swapRumbleTargetForPlayer:(Player *)p{
	RumbleTarget * rt = [self rumbleTargetForPlayer:p];
	[rt.info swapRumbleTarget:YES];

}

- (CGPoint)convertedPoint:(CGPoint)point{
	UIInterfaceOrientation interfaceOrientation = [board interfaceOrientation];
	if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
		return point;
	}
	
	//convert a portrait point to landscape point
	return CGPointMake(point.x/768*1024, point.y/1004*748);
}

- (CGRect)convertedRect:(CGRect)rect{
	UIInterfaceOrientation interfaceOrientation = [board interfaceOrientation];
	if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
		return rect;
	}
	
	CGPoint newOrigin = [self convertedPoint:rect.origin];
	return CGRectMake(newOrigin.x, newOrigin.y, rect.size.height, rect.size.width);
	
}

- (BOOL)isInRumble{
	if ([Round sharedInstance].state == RoundStateRumble || [Turn sharedInstance].state == TurnStateBuild) {
		return YES;
	}
	return NO;
}

- (BOOL)isBadgeTypeUsed:(BadgeType)t{
	for (Player * p in players) {
		for (Badge * b in p.badges) {
			if (b.type == t) {
				return YES;
			}
		}
	}
	return NO;
}

#pragma mark -
#pragma mark Tunings


+ (int)scoreForBadgeType:(BadgeType)type{
	switch (type) {
		case BadgeTypeMostRound:
			return 7;
			break;
		case BadgeTypeMostRect:
			return 7;
			break;
		case BadgeTypeMostSquare:
			return 7;
			break;
		case BadgeTypeEnoughRound:
			return 4;
			break;
		case BadgeTypeEnoughRect:
			return 6;
			break;
		case BadgeTypeEnoughSquare:
			return 8;
			break;
		case BadgeTypeFirstBuilder:
			return 5;
			break;
		case BadgeTypeFastBuilder:
			return 7;
			break;
		case BadgeTypeOneProject:
			return 1;
			break;		
		case BadgeTypeThreeProjects:
			return 4;
			break;		
		case BadgeTypeFiveProjects:
			return 9;
			break;
		case BadgeTypeSevenProjects:
			return 16;
			break;			
		default:
			break;
	}
	return 0;
}

+ (NSString *)shortDescriptionForBadgeType:(BadgeType)type{
	switch (type) {
		case BadgeTypeMostRound:
			return @"Most Designers";
			break;
		case BadgeTypeMostRect:
			return @"Most Artists";
			break;
		case BadgeTypeMostSquare:
			return @"Most Coders";
			break;
		case BadgeTypeEnoughRound:
			return [NSString stringWithFormat:@"Designers > %d", EnoughResource[ResourceTypeRound] - 1];
			break;
		case BadgeTypeEnoughRect:
			return [NSString stringWithFormat:@"Artists > %d", EnoughResource[ResourceTypeRect] - 1];
			break;
		case BadgeTypeEnoughSquare:
			return [NSString stringWithFormat:@"Coders > %d", EnoughResource[ResourceTypeSquare] - 1];
			break;
		case BadgeTypeFirstBuilder:
			return @"First Builder";
			break;
		case BadgeTypeFastBuilder:
			return @"Build 3+ Projects in 1 Week";
			break;
		case BadgeTypeOneProject:
			return @"First Project Built";
			break;		
		case BadgeTypeThreeProjects:
			return @"3 Projects Built";
			break;		
		case BadgeTypeFiveProjects:
			return @"5 Projects Built";
			break;
		case BadgeTypeSevenProjects:
			return @"7 Projects Built";
			break;			
		default:
			break;
	}
	return @"";
}

+ (NSString *)descriptionForBadgeType:(BadgeType)type{
	switch (type) {
		case BadgeTypeMostRound:
			return @"You're the master of Designers.";
			break;
		case BadgeTypeMostRect:
			return @"You're the king of Artists.";
			break;
		case BadgeTypeMostSquare:
			return @"Code monkeys at your disposal.";
			break;
		case BadgeTypeEnoughRound:
			return @"You have a fair amount of designers now.";
			break;
		case BadgeTypeEnoughRect:
			return @"You have a fair amount of artists now.";
			break;
		case BadgeTypeEnoughSquare:
			return @"You have a fair amount of coders now.";
			break;
		case BadgeTypeFirstBuilder:
			return @"Early bird gets the job done.";
			break;
		case BadgeTypeFastBuilder:
			return @"You're fast, lightning fast.";
			break;
		case BadgeTypeOneProject:
			return @"First step for everyone.";
			break;		
		case BadgeTypeThreeProjects:
			return @"On the road.";
			break;		
		case BadgeTypeFiveProjects:
			return @"Keep it up.";
			break;
		case BadgeTypeSevenProjects:
			return @"Now that's something.";
			break;			
		default:
			break;
	}
	return @"";
}


+ (NSString *)descriptionForResourceType:(ResourceType)type{
	switch (type) {
		case ResourceTypeRect:
			return @"Artist";
			break;
		case ResourceTypeRound:
			return @"Designer";
			break;
		case ResourceTypeSquare:
			return @"Coder";
			break;			
		default:
			break;
	}
	return @"";
}


- (int)numberOfSharedTokens{
	int numOfTokens = (round.count/3+1) * 2;
	if (round.moreSharedTokens) {
		numOfTokens *= 2;
	}
	return numOfTokens;
}


- (float)buildTime{
	float buildTime = (round.count/3+1) * 2 + 10;
	if (round.moreBuildTime) {
		buildTime *= 2;
	}
	return buildTime;
}


#pragma mark -
#pragma mark Singleton methods

+ (GameLogic*)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
			sharedInstance = [[GameLogic alloc] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

@end
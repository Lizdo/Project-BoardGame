//
//  Turn.m
//  BoardGame
//
//  Created by Liz on 10-5-1.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "Turn.h"
#import "GameLogic.h"
#import "Player.h"
#import "Tile.h"
#import "Rumble.h"


@interface Turn (Private)

- (void)turnInit;
- (void)waitForInput;
- (void)gotoNextState;
- (void)turnCleanup;
- (void)enterBuild;
- (void)enterLucky;

@end

@implementation Turn

@synthesize count, state, player, selectedTile;

static Turn *sharedInstance = nil;

- (Player *)player{
	return [gameLogic currentPlayer];
}

- (id)init{
	if (self = [super init]){

	}
	return self;
}

- (void)initGame{
	gameLogic = [GameLogic sharedInstance];
	gameLogic.turn = self;
	round = [Round sharedInstance];
	rumble = [Rumble sharedInstance];
}

#pragma mark -
#pragma mark Turn Logic


- (void) enterTurn{
	DebugLog(@"Entering Turn %d...", count);
	state = TurnStateInit;
	allowTurnEnd = NO;
	[self turnInit];
}


- (void)turnInit{
	//TODO:play some anim. wait until finish then call gotoNextState
	[gameLogic updateNewTurn];
	[self gotoNextState];
}

- (void)gotoNextState{
	switch (state) {
		case TurnStateInit:
			state = TurnStateWaitForInput;
			[self waitForInput];
			break;
		case TurnStateWaitForInput:
			state = TurnStateSelectionMade;
			break;
		case TurnStateSelectionMade:
			state = TurnStateConclusion;
			[self turnCleanup];
			break;
		case TurnStateConclusion:
			[self exitTurn];
			break;
		default:
			break;
	}
	
}

- (void)pause{
	if (state == TurnStateWaitForInput && selectedTile) {
		selectedTile.state == TileStateAvailable;
		selectedTile = nil;
	}
}

- (void)resume{
	if (state == TurnStateWaitForInput) {
		[self waitForInput];
	}
}


- (void)waitForInput{
	allowTurnEnd = YES;	
	if (!gameLogic.currentPlayer.isHuman) {
		[gameLogic.currentPlayer processAI];
	}
}

- (void)inputMade{
	if (state == TurnStateWaitForInput) {
		[self gotoNextState];
	}
}

- (void)endTurnButtonClicked{
	if (state == TurnStateSelectionMade)
		[self gotoNextState];
}


- (void)turnCleanup{
	if (selectedTile.type == TileTypeBuild) {
		[self enterBuild];
		return;
	}else if (selectedTile.type == TileTypeLucky) {
		[self enterLucky];
		return;		
	}else if (selectedTile.type == TileTypeOutsourcing) {
		round.moreSharedTokens = YES;
	}else if (selectedTile.type == TileTypeOvertime) {
		round.moreBuildTime = YES;
	}else if (selectedTile.type == TileTypeAnnualParty) {
		round.skipProjectUpdate = YES;
		selectedTile.isDisabled = YES;
	}
	
	//play some anim then		
	[self gotoNextState];
}

- (void)enterBuild{
	state = TurnStateBuild;
	[rumble enterBuild];
}

- (void)buildComplete{
	state = TurnStateConclusion;
	[self performSelector:@selector(gotoNextState) withObject:self afterDelay:WaitTime*2];
}

- (void)enterLucky{
	[self gotoNextState];	
}

- (void)luckyComplete{
	[self gotoNextState];	
}

- (void) exitTurn{
	DebugLog(@"Exiting Turn %d...", count);
	[gameLogic exitTurn];
	[round turnComplete]; 
}

#pragma mark -
#pragma mark Singleton methods

+ (Turn*)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
			sharedInstance = [[Turn alloc] init];
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


#pragma mark -
#pragma mark Serialization

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInt:count forKey:@"count"];
    [coder encodeInt:state forKey:@"state"];	
}


- (id)initWithCoder:(NSCoder *)coder {
	self = [Turn sharedInstance];
	
    self.count = [coder decodeIntForKey:@"count"];
    self.state = [coder decodeIntForKey:@"state"];
	
	DebugLog(@"Loaded from Save, Turn %d, State %d", count, state);
	
	
    return [self retain];
}



@end

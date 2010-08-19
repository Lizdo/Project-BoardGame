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

- (Player *)player{
	return [gameLogic currentPlayer];
}

- (id)init{
	if (self = [super init]){
		gameLogic = [GameLogic sharedInstance];
	}
	return self;
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
	rumble = gameLogic.rumble;
}

- (void)gotoNextState{
	switch (state) {
		case TurnStateInit:
			state = TurnStateWaitForInput;
			[self waitForInput];
			break;
		case TurnStateWaitForInput:
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

- (void)resume{
	[self enterTurn];
}


- (void)waitForInput{
	allowTurnEnd = YES;	
	if (!gameLogic.currentPlayer.isHuman) {
		[gameLogic.currentPlayer processAI];
	}
}

- (void)endTurnButtonClicked{
	if (allowTurnEnd)
		[self gotoNextState];
}


- (void)turnCleanup{
	if (selectedTile.type == TileTypeBuild) {
		[self enterBuild];
	}else if (selectedTile.type == TileTypeLucky) {
		[self enterLucky];
	}
	else {
		//play some anim then		
		[self gotoNextState];	
	}
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
	[gameLogic.round turnComplete]; 
}



#pragma mark -
#pragma mark Serialization

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInt:count forKey:@"count"];
    [coder encodeInt:state forKey:@"state"];	
}


- (id)initWithCoder:(NSCoder *)coder {
	self = [[Turn alloc]init];
	
    count = [coder decodeIntForKey:@"count"];
    state = [coder decodeIntForKey:@"state"];
	
    return self;
}



@end

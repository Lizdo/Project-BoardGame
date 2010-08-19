//
//  Round.m
//  BoardGame
//
//  Created by Liz on 10-5-1.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "Round.h"
#import "GameLogic.h"
#import "Turn.h"


@interface Round (Private)

- (void)roundInit;
- (void)gotoNextState;
- (void)roundCleanup;

@end


@implementation Round

@synthesize count,state;

- (id)init{
	if (self = [super init]){
		//[self initPlayers];
		count = -1;
		gameLogic = [GameLogic sharedInstance];
	}
	return self;
}

#pragma mark -
#pragma mark Round Logic


- (void)enterRound{
	count++;
	state = RoundStateInit;
	DebugLog(@"Entering Round %d...", count);
	[self performSelector:@selector(enterRoundWaitComplete) withObject:self afterDelay:WaitTime];
}

- (void)enterRoundWaitComplete{
	[gameLogic updateNewRound];
	[self performSelector:@selector(roundInit) withObject:self afterDelay:WaitTime*2];
}

- (void)roundInit{
	//TODO:play some anim. wait until finish then call gotoNextState
	[self gotoNextState];
}

- (void)gotoNextState{
	switch (state) {
		case RoundStateInit:
			state = RoundStateNormal;
			[self turnStart];
			break;
		case RoundStateNormal:
			state = RoundStateRumble;
			[self performSelector:@selector(startRumble) withObject:self afterDelay:WaitTime];
			break;			
		case RoundStateRumble:
			state = RoundStateConclusion;
			[self performSelector:@selector(exitRound) withObject:self afterDelay:WaitTime];
			break;
		case RoundStateConclusion:
			[self exitRound];
			break;
		default:
			break;
	}
	
}

- (void)resume{
	turn = gameLogic.turn;
	rumble = gameLogic.rumble;
	switch (state) {
		case RoundStateInit:
			[self turnStart];
			break;
		case RoundStateNormal:
			[turn resume];
			break;			
		case RoundStateRumble:
			[rumble resume];
			break;
		case RoundStateConclusion:
			[self exitRound];
			break;
		default:
			break;
	}
}

- (void)startRumble{
	rumble = gameLogic.rumble;
	[rumble enterRumble];
}

- (void)rumbleComplete{
	[self gotoNextState];
}


- (void)roundCleanup{
	//play some anim then
	[self gotoNextState];	
}

- (void)exitRound{
	DebugLog(@"Exiting Round %d...", count);
	[gameLogic exitRound];
	if (count <= MAX_ROUNDS)
		[self enterRound];
}

#pragma mark -
#pragma mark Turn Logic

//Start Turn here
- (void)turnStart{
	turn = gameLogic.turn;
	//allocat the player, turn ID
	turn.count = 0;
	[turn enterTurn];
}

- (void)gotoNextTurn{
	turn.count ++;
	//allocat the player, turn ID
	[turn enterTurn];	
}

//Called by the child turn
- (void)turnComplete{
	if (turn.count >= 3)
		[self gotoNextState];
	else {
		[self gotoNextTurn];
	}

}

#pragma mark -
#pragma mark Serialization

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInt:count forKey:@"count"];
    [coder encodeInt:state forKey:@"state"];
}


- (id)initWithCoder:(NSCoder *)coder {
	self = [[Round alloc]init];
	
    count = [coder decodeIntForKey:@"count"];
    state = [coder decodeIntForKey:@"state"];
	
    return self;
}




@end

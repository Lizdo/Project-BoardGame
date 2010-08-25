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

static Round *sharedInstance = nil;


- (id)init{
	if (self = [super init]){
		count = -1;
	}
	return self;
}

#pragma mark -
#pragma mark Round Logic

- (void)initGame{
	gameLogic = [GameLogic sharedInstance];
	gameLogic.round = self;
	turn = [Turn sharedInstance];
	rumble = [Rumble sharedInstance];		
}


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
	switch (state) {
		case RoundStateInit:
			[self gotoNextState];
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
#pragma mark Singleton methods

+ (Round*)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
			sharedInstance = [[Round alloc] init];
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
	sharedInstance = [[Round alloc]init];

    sharedInstance.count = [coder decodeIntForKey:@"count"];
    sharedInstance.state = [coder decodeIntForKey:@"state"];
	
	
    return sharedInstance;
}




@end

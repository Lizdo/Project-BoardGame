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
#import "Board.h"


@interface Round (Private)

- (void)roundInit;
- (void)gotoNextState;
- (void)roundCleanup;
- (BOOL)endGame;

@end


@implementation Round

@synthesize count,state,moreSharedTokens,moreBuildTime,skipProjectUpdate;

static Round *sharedInstance = nil;


- (id)init{
	if (self = [super init]){
		count = -1;
	}
	return self;
}

+ (void)initWithInstance:(Round *)instance{
	sharedInstance = instance;
}

#pragma mark -
#pragma mark Round Logic

- (void)initGame{
	gameLogic = [GameLogic sharedInstance];
	turn = [Turn sharedInstance];
	rumble = [Rumble sharedInstance];		
}


- (void)enterRound{
	count++;
	state = RoundStateInit;
	DebugLog(@"Entering Round %d...", count);
	[[Board sharedInstance]addRoundIntro];
}

- (void)enterRoundWaitComplete{
	[gameLogic updateNewRound];
	[self performSelector:@selector(roundInit) withObject:self afterDelay:WaitTime*2];
	//Reset the flag after Player/Projects are updated
	moreSharedTokens = NO;
	skipProjectUpdate = NO;
	moreBuildTime = NO;	
}



- (void)roundInit{
	//Stop update if we goto end game.
	if ([self endGame]) {
		return;
	}	
	
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

- (void)pause{
	//Only pause round update at Rumble, 
	if (state == RoundStateRumble) {
		[rumble pause];
	}else {
		[turn pause];
	}

}

- (void)startRumble{
	[[Board sharedInstance] addRumbleIntro];
}
	 
- (void)enterRumbleWaitComplete{
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
	
	//Stop update if we goto end game.
	if ([self endGame]) {
		return;
	}
	
	if (count < [Game NumberOfRounds]-1){
		[self enterRound];
	}else{
		[gameLogic cleanUpBeforeConclusion];
		[[Board sharedInstance] enterConclusion];
	}
}


- (BOOL)endGame{
	GameResult result = [[Game sharedInstance].gameMode validate];
	switch (result) {
		case GameResultSuccess:
			//Show Success
			DebugLog(@"Objective Complete...");
			return YES;
			break;
		case GameResultFailure:
			//Show Failure
			DebugLog(@"Objective Failed...");			
			return YES;
			break;
		default:
			break;
	}
	return NO;
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
	if (turn.count >= ([Game TotalNumberOfPlayers] - 1))
		[self gotoNextState];
	else {
		[self gotoNextTurn];
	}

}

- (void)reset{
	sharedInstance = nil;
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
    [coder encodeBool:moreSharedTokens forKey:@"moreSharedTokens"];	
    [coder encodeBool:skipProjectUpdate forKey:@"skipProjectUpdate"];	
    [coder encodeBool:moreBuildTime forKey:@"moreBuildTime"];	
	
}


- (id)initWithCoder:(NSCoder *)coder {
	self = [Round sharedInstance];
    self.count = [coder decodeIntForKey:@"count"];
    self.state = [coder decodeIntForKey:@"state"];
	self.moreSharedTokens = [coder decodeBoolForKey:@"moreSharedTokens"];
	self.skipProjectUpdate = [coder decodeBoolForKey:@"skipProjectUpdate"];
	self.moreBuildTime = [coder decodeBoolForKey:@"moreBuildTime"];	
	DebugLog(@"Loaded from Save, Round %d, State %d", count, state);
    return [self retain];
}




@end

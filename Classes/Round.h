//
//  Round.h
//  BoardGame
//
//  Created by Liz on 10-5-1.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TypeDef.h"
#import "Rumble.h"
@class GameLogic;
@class Turn;

@interface Round : NSObject <NSCoding>{
	int count;
	RoundState state;
	
	Turn * turn;
	Rumble * rumble;
	GameLogic * gameLogic;
	
	BOOL moreSharedTokens;
	BOOL skipProjectUpdate;
	BOOL moreBuildTime;
	
}

@property (nonatomic,assign) int count;
@property (nonatomic,assign) RoundState state;

@property (nonatomic,assign) BOOL moreSharedTokens;
@property (nonatomic,assign) BOOL skipProjectUpdate;
@property (nonatomic,assign) BOOL moreBuildTime;


+ (Round*)sharedInstance;
+ (void)initWithInstance:(Round *)instance;

- (void)initGame;

//Called by Game Object
- (void)enterRound;
- (void)exitRound;

- (void)pause;
- (void)resume;
- (void)reset;

//Called by Turn Object
- (void)turnStart;
- (void)turnComplete;

- (void)rumbleComplete;

- (void)enterRoundWaitComplete;
- (void)enterRumbleWaitComplete;


@end

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

#define MAX_ROUNDS 10



@interface Round : NSObject <NSCoding>{
	int count;
	RoundState state;
	
	Turn * turn;
	Rumble * rumble;
	GameLogic * gameLogic;
}

@property (nonatomic,assign) int count;
@property (nonatomic,assign) RoundState state;

//Called by Game Object
- (void)enterRound;
- (void)exitRound;
- (void)resume;

//Called by Turn Object
- (void)turnStart;
- (void)turnComplete;

- (void)rumbleComplete;

@end

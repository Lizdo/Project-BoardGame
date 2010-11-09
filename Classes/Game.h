//
//  Game.h
//  BoardGame
//
//  Created by Liz on 10-5-1.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TypeDef.h"

@class GameLogic;
@class Round;
@class Turn;
@class Rumble;

@interface Game : NSObject {
	GameLogic * gameLogic;
	BOOL paused;
	BOOL running;
}

@property (readonly) BOOL paused;  //Whether the game is paused
@property (readonly) BOOL running;  //Whether the game has started (Not in menu)

+ (Game*)sharedInstance;

- (void)pause;
- (void)resume;

+ (int)numberOfPlayers;
- (void)startWithPlayersNumber:(int)number totalPlayerNumber:(int)totalNumber;

- (void)save;
- (void)load;

@end

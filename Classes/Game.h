//
//  Game.h
//  BoardGame
//
//  Created by Liz on 10-5-1.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TypeDef.h"
#import "GameMode.h"

@class GameLogic;
@class Round;
@class Turn;
@class Rumble;
@class GameMode;

@interface Game : NSObject {
	GameLogic * gameLogic;
	BOOL paused;
	BOOL running;
	GameMode * gameMode;
}

@property (readonly) BOOL paused;  //Whether the game is paused
@property (readonly) BOOL running;  //Whether the game has started (Not in menu)
@property (retain) GameMode * gameMode;

+ (Game*)sharedInstance;

- (void)pause;
- (void)resume;

+ (int)TotalNumberOfPlayers;
+ (int)NumberOfPlayers;
+ (int)NumberOfRounds;

- (void)startWithOptions:(NSDictionary *)options;

- (void)save;
- (void)load;

@end

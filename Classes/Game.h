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
}

+ (Game*)sharedInstance;

- (void)start;
- (void)resume;
- (void)startWithPlayersNumber:(int)number;

- (void)save;

@end

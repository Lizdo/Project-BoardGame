//
//  Rumble.h
//  BoardGame
//
//  Created by Liz on 10-5-1.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TypeDef.h"
@class GameLogic;
@class Round;

@interface Rumble : NSObject <NSCoding>{
	GameLogic * gameLogic;
	NSDate * startingTime;
	
	NSTimer * timer;
	
	BOOL build;
	
	Round * round;
}

@property (nonatomic,assign) BOOL build;

+ (Rumble*)sharedInstance;
- (void)initGame;

- (void)enterRumble;
- (void)enterRumbleAnimDidStop;
- (void)exitRumble;
- (void)exitRumbleAnimDidStop;

- (void)resume;

- (void)enterBuild;
- (void)exitBuild;

- (void)update;
- (float)timeRemaining;

@end

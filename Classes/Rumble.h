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

#define RumbleTimeSlice 0.05

@interface Rumble : NSObject <NSCoding>{
	GameLogic * gameLogic;
	NSDate * startingTime;
	
	NSTimer * timer;
	
	BOOL build;
	
	Round * round;

	float buildTime;
	float currentTime;
}

@property (nonatomic,assign) BOOL build;

+ (Rumble*)sharedInstance;
- (void)initGame;

- (void)enterRumble;
- (void)enterRumbleAnimDidStop;
- (void)exitRumble;
- (void)exitRumbleAnimDidStop;

- (void)pause;
- (void)resume;

- (void)enterBuild;
- (void)exitBuild;

- (void)update;
- (float)timeRemaining;

@end

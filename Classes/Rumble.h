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

typedef enum{
	RumbleStateInit,
	RumbleStateInProgress,
	RumbleStateCompleted,	
}RumbleState;


@interface Rumble : NSObject <NSCoding>{
	GameLogic * gameLogic;
	
	NSTimer * timer;
	
	BOOL build;
	
	Round * round;

	float buildTime;
	float currentTime;
	
	RumbleState state;
}

@property (nonatomic,assign) BOOL build;

+ (Rumble*)sharedInstance;
+ (void)initWithInstance:(Rumble *)instance;


- (void)initGame;

- (void)enterRumble;
- (void)enterRumbleAnimDidStop;
- (void)exitRumble;
- (void)exitRumbleAnimDidStop;

- (void)pause;
- (void)resume;
- (void)reset;

- (void)enterBuild;
- (void)exitBuild;

- (void)update;
- (float)timeRemaining;

@end

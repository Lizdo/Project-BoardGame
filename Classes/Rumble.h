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

@interface Rumble : NSObject <NSCoding>{
	GameLogic * gameLogic;
	NSDate * startingTime;
	
	NSTimer * timer;
	
	BOOL build;
}

- (void)enterRumble;
- (void)exitRumble;
- (void)resume;

- (void)enterBuild;
- (void)exitBuild;

- (void)update;
- (float)timeRemaining;

@end

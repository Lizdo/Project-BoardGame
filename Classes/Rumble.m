//
//  Rumble.m
//  BoardGame
//
//  Created by Liz on 10-5-1.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "Rumble.h"
#import "GameLogic.h"
#import "Board.h"

@interface Rumble (Private)

- (void)startRumble;
- (void)stopRumble;

@end


@implementation Rumble

- (float)timeRemaining{
	float time = RumbleTime + [startingTime timeIntervalSinceNow];
	//DebugLog(@"remaining Time:%2.0f", time);
	return time;
}

- (id)init{
	if (self = [super init]){
		gameLogic = [GameLogic sharedInstance];
	}
	return self;
}

- (void)startRumble{
	startingTime =  [[NSDate date] retain];	
	//RUmble logic here...
	[gameLogic enterRumbleToBuild:build];
	[self performSelector:@selector(stopRumble) withObject:self afterDelay:RumbleTime];
	timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(update) userInfo:nil repeats:YES];
	[timer retain];
}

- (void)stopRumble{
	DebugLog(@"Exiting rumble...");
	[timer invalidate];
	[timer release];
	
	//remove all temp tokens
	[gameLogic exitRumble];	
	
	if (build) {
		[self exitBuild];
	}else {
		[self exitRumble];
	}

}


- (void)enterRumble{
	build = NO;
	[self startRumble];
}

- (void)exitRumble{
	[gameLogic.round rumbleComplete]; 	
}

- (void)resume{
	build ? [self enterBuild] : [self enterRumble];
}


- (void)enterBuild{
	build = YES;
	[self startRumble];	
}

- (void)exitBuild{
	[gameLogic.turn buildComplete];
}


- (void)update{
	[gameLogic.board updateRumble];
}

- (void)dealloc{
	[startingTime release];
	[super dealloc];
}

#pragma mark -
#pragma mark Serialization

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeBool:build forKey:@"build"];
}


- (id)initWithCoder:(NSCoder *)coder {
	self = [[Rumble alloc]init];
    build = [coder decodeBoolForKey:@"build"];	
    return self;
}

@end

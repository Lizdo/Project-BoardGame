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

@synthesize build;

static Rumble *sharedInstance = nil;

- (float)timeRemaining{	
	float time = buildTime - currentTime;
	if (time < 0) {
		time = 0;
	}
	return time;
}

- (id)init{
	if (self = [super init]){

	}
	return self;
}

- (void)initGame{
	gameLogic = [GameLogic sharedInstance];
	gameLogic.rumble = self;
	round = [Round sharedInstance];
}

- (void)startRumble{
	[gameLogic enterRumbleToBuild:build];
	if (![[Game sharedInstance] paused]) {
		buildTime = DebugMode ? DefaultRumbleTime : [gameLogic buildTime];
		currentTime = 0;
	}
	//if resumed from pause, the buildTime and currentTime should have been recovered
}

- (void)enterRumbleAnimDidStop{	
	timer = [NSTimer scheduledTimerWithTimeInterval:RumbleTimeSlice target:self selector:@selector(update) userInfo:nil repeats:YES];
	[timer retain];
}

- (void)stopRumble{
	DebugLog(@"Exiting rumble...");
	if (timer) {
		[timer invalidate];
		[timer release];
	}

	
	//remove all temp tokens
	[gameLogic exitRumble];	
}

- (void)exitRumbleAnimDidStop{
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
	[round rumbleComplete]; 	
}

- (void)pause{
	if (timer && timer.isValid) {
		[timer invalidate];
		[timer release];
	}
}


- (void)resume{
	build ? [self enterBuild] : [self enterRumble];
}


- (void)enterBuild{
	build = YES;
	[self startRumble];	
}

- (void)exitBuild{
	[[Turn sharedInstance] buildComplete];
}


- (void)update{
	if ([Game sharedInstance].paused) {
		return;
	}
	currentTime += RumbleTimeSlice;
	if (currentTime >= buildTime) {
		[self stopRumble];
	}
	[[Board sharedInstance] updateRumble];
}

- (void)dealloc{
	[startingTime release];
	[super dealloc];
}

#pragma mark -
#pragma mark Singleton methods

+ (Rumble*)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
			sharedInstance = [[Rumble alloc] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}


#pragma mark -
#pragma mark Serialization

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeBool:build forKey:@"build"];
	[coder encodeFloat:currentTime forKey:@"currentTime"];
	[coder encodeFloat:buildTime forKey:@"buildTime"];	
}


- (id)initWithCoder:(NSCoder *)coder {
	self = [Rumble sharedInstance];
    self.build = [coder decodeBoolForKey:@"build"];	
	currentTime = [coder decodeFloatForKey:@"currentTime"];
	buildTime = [coder decodeFloatForKey:@"buildTime"];
	
	DebugLog(@"Loaded from Save, Rumble Time: %f/%f", currentTime, buildTime);
	
    return [self retain];
}

@end

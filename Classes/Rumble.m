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
	float time = abs(RumbleTime + [startingTime timeIntervalSinceNow]);
	//DebugLog(@"remaining Time:%2.0f", time);
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
	[round rumbleComplete]; 	
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
}


- (id)initWithCoder:(NSCoder *)coder {
	sharedInstance = [[Rumble alloc]init];
    sharedInstance.build = [coder decodeBoolForKey:@"build"];	
	
    return sharedInstance;
}

@end

//
//  Game.m
//  BoardGame
//
//  Created by Liz on 10-5-1.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "Game.h"
#import "GameLogic.h"
#import "Tile.h"

@interface Game (Private)

- (void)deviceLocked;
- (void)deviceUnlocked;

@end

@implementation Game

@synthesize paused, running;

static Game *sharedInstance = nil;
static int NumberOfPlayers;

- (id)init{
	if (self = [super init]) {
		gameLogic = [GameLogic sharedInstance];
		gameLogic.game = self;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save) name:UIApplicationWillTerminateNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceLocked) name:UIApplicationWillResignActiveNotification object:nil];	
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceUnlocked) name:UIApplicationDidBecomeActiveNotification object:nil];			
		

	}
	return self;
}

+ (int)numberOfPlayers{
	return NumberOfPlayers;
}

- (void)deviceLocked{
	[self save];
	[self pause];
}

- (void)deviceUnlocked{
	if (self.running) {
		[self resume];
	}
}

//Pause Logic
//  if Rumble -> Save Rumble remaining time, pause timer
//  else -> Stop current turn completion
- (void)pause{
	paused = YES;
	[[Round sharedInstance] pause];
}

- (void)resume{
	paused = YES;
	[[Round sharedInstance] resume];
	paused = NO;
	running = YES;
}

- (void)load{
	//resume in GameLogic, GameLogic decode Players/Tiles
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *archivePath = [documentsDirectory stringByAppendingPathComponent:@"Game.archive"];
	
	NSMutableData *data;
	NSKeyedUnarchiver *unarchiver;
	
	data = [NSMutableData dataWithContentsOfFile:archivePath];
	unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];

	//always init the total player number first
	NumberOfPlayers = [unarchiver decodeIntForKey:@"NumberOfPlayers"];		
	
	gameLogic.round = [unarchiver decodeObjectForKey:@"Round"];
	gameLogic.turn = [unarchiver decodeObjectForKey:@"Turn"];
	gameLogic.rumble = [unarchiver decodeObjectForKey:@"Rumble"];
	gameLogic.players = [unarchiver decodeObjectForKey:@"Players"];	
	gameLogic.tiles = [unarchiver decodeObjectForKey:@"Tiles"];	
	
	
	[[Round sharedInstance] initGame];
	[[Turn sharedInstance] initGame];
	[[Rumble sharedInstance] initGame];	
	
	[unarchiver finishDecoding];
	[unarchiver release];
	
	[gameLogic resumeGame];
	
	[self resume];
	
	
}



- (void)save{
	//Save Round/Turn/Rumble
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *archivePath = [documentsDirectory stringByAppendingPathComponent:@"Game.archive"];
	
	NSMutableData *data;
	NSKeyedArchiver *archiver;
	
	data = [NSMutableData data];
	archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	// Customize archiver here
	[archiver encodeObject:[Round sharedInstance] forKey:@"Round"];
	[archiver encodeObject:[Turn sharedInstance] forKey:@"Turn"];
	[archiver encodeObject:[Rumble sharedInstance] forKey:@"Rumble"];
	[archiver encodeObject:gameLogic.players forKey:@"Players"];
	[archiver encodeObject:gameLogic.tiles forKey:@"Tiles"];
	
	[archiver encodeInt:NumberOfPlayers forKey:@"NumberOfPlayers"];
	
	
	[archiver finishEncoding];
	[data writeToFile:archivePath atomically:YES];
	[archiver release];	
	
}

- (void)startWithPlayersNumber:(int)number totalPlayerNumber:(int)totalNumber{
	//always init the total player number first
	NumberOfPlayers = totalNumber;

	[gameLogic initGameWithPlayerNumber:number];
	gameLogic.round = [Round sharedInstance];
	gameLogic.turn = [Turn sharedInstance];
	gameLogic.rumble = [Rumble sharedInstance];	
	
	[[Round sharedInstance] initGame];
	[[Turn sharedInstance] initGame];
	[[Rumble sharedInstance] initGame];		
	
	//TODO: Game Init Logic
	running = YES;
	[gameLogic.round enterRound];	
}

#pragma mark -
#pragma mark Singleton methods

+ (Game*)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
			sharedInstance = [[Game alloc] init];
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


@end

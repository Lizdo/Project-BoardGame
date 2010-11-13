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
- (NSMutableArray *)defaultTiles;

@end

@implementation Game

@synthesize paused, running;

static Game *sharedInstance = nil;

static int TotalNumberOfPlayers;
static int NumberOfPlayers;
static int NumberOfRounds;

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

+ (int)TotalNumberOfPlayers{
	return TotalNumberOfPlayers;
}

+ (int)NumberOfPlayers{
	return NumberOfPlayers;
}

+ (int)NumberOfRounds{
	return NumberOfRounds;	
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
	TotalNumberOfPlayers = [unarchiver decodeIntForKey:@"TotalNumberOfPlayers"];		
	
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
	[archiver encodeInt:TotalNumberOfPlayers forKey:@"TotalNumberOfPlayers"];
	
	[archiver finishEncoding];
	[data writeToFile:archivePath atomically:YES];
	[archiver release];	
	
}

//Stuff needs to be extracted
// Number of Players
// Total Number of Players
// Number of Rounds
// Tiles
// Winning Condition - TBD
// Losing Condition - TBD

- (void)startWithOptions:(NSDictionary *)options{
	NumberOfPlayers = [[options objectForKey:@"NumberOfPlayers"] intValue];
	TotalNumberOfPlayers = [[options objectForKey:@"TotalNumberOfPlayers"] intValue];
	if ([options objectForKey:@"NumberOfRounds"] != nil) {
		NumberOfRounds = [[options objectForKey:@"NumberOfRounds"] intValue];
	}else {
		NumberOfRounds = 15;
	}
	NSMutableArray * Tiles = [options objectForKey:@"Tiles"];
	if (Tiles == nil) {
		Tiles = [self defaultTiles];
	}
	gameLogic.tiles = Tiles;
	[gameLogic initGameWithPlayerNumber:NumberOfPlayers];
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

- (NSMutableArray *)defaultTiles{
	const int numberOfTiles = 18;
	int tileInfos[18][8] = {
		//row 0
		{TileTypeAccumulateResource, 0, 0, 0,0,ResourceTypeRect,0,1},
		{TileTypeGetResource, 0, 0, 0,0,ResourceTypeRect,2,0},
		{TileTypeExchangeResource, 0, 0, ResourceTypeRound,1,ResourceTypeRect,2,0},	
		{TileTypeGetResource, 0, 0, 0,0,ResourceTypeSquare,1,0},	
		{TileTypeExchangeResource, 0, 0, ResourceTypeRect,2,ResourceTypeSquare,2,0},	
		{TileTypeOutsourcing, 0, 0, 0,0,ResourceTypeRect,0,0},
		//row 1
		{TileTypeExchangeResource, 0, 0, ResourceTypeRect,1,ResourceTypeRound,4,0},	
		{TileTypeAccumulateResource, 0, 0, 0,0,ResourceTypeRect,0,1},
		{TileTypeExchangeResource, 0, 0, ResourceTypeSquare,1,ResourceTypeRect,3,0},	
		{TileTypeBuild, 0, 0, 0,0,ResourceTypeRound,0,0},	
		{TileTypeExchangeResource, 0, 0, ResourceTypeRect,1,ResourceTypeSquare,2,0},	
		{TileTypeAnnualParty, 0, 0, 0,0,ResourceTypeRect,0,0},
		//row 2
		{TileTypeAccumulateResource, 0, 0, 0,0,ResourceTypeSquare,0,1},
		{TileTypeOvertime, 0, 0, 0,0,ResourceTypeRect,0,0},
		{TileTypeGetResource, 0, 0, 0,0,ResourceTypeSquare,3,0},
		{TileTypeAccumulateResource, 0, 0, 0,0,ResourceTypeRound,0,1},
		{TileTypeGetResource, 0, 0, 0,0,ResourceTypeRect,1,0},
		{TileTypeGetResource, 0, 0, 0,0,ResourceTypeSquare,1,0},
	};
	
	NSMutableArray * tiles = [NSMutableArray arrayWithCapacity:0];
	for (int i = 0; i < numberOfTiles; i++) {
		[tiles addObject:[Tile tileWithInfo:tileInfos[i]]]; 
	}
	
	return tiles;
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

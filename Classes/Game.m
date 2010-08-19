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

@implementation Game

- (id)init{
	if (self = [super init]) {
		gameLogic = [GameLogic sharedInstance];
		gameLogic.game = self;
		

	}
	return self;
}

- (void)start{
	[self startWithPlayersNumber:0];
}

- (void)resume{
	//resume in GameLogic, GameLogic decode Players/Tiles
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *archivePath = [documentsDirectory stringByAppendingPathComponent:@"Game.archive"];
	
	NSMutableData *data;
	NSKeyedUnarchiver *unarchiver;
	
	data = [NSMutableData dataWithContentsOfFile:archivePath];
	unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	
	gameLogic.round = [unarchiver decodeObjectForKey:@"Round"];
	gameLogic.turn = [unarchiver decodeObjectForKey:@"Turn"];
	gameLogic.rumble = [unarchiver decodeObjectForKey:@"Rumble"];	
	gameLogic.players = [unarchiver decodeObjectForKey:@"Players"];	
	gameLogic.tiles = [unarchiver decodeObjectForKey:@"Tiles"];	
	
	[unarchiver finishDecoding];
	[unarchiver release];
	
	[gameLogic resumeGame];
	
	[gameLogic.round resume];
	
	
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
	[archiver encodeObject:gameLogic.round forKey:@"Round"];
	[archiver encodeObject:gameLogic.turn forKey:@"Turn"];
	[archiver encodeObject:gameLogic.rumble forKey:@"Rumble"];
	[archiver encodeObject:gameLogic.players forKey:@"Players"];
	[archiver encodeObject:gameLogic.tiles forKey:@"Tiles"];
	
	[archiver finishEncoding];
	[data writeToFile:archivePath atomically:YES];
	[archiver release];	
	
}

- (void)startWithPlayersNumber:(int)number{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save) name:UIApplicationWillTerminateNotification object:nil];		
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save) name:UIApplicationWillResignActiveNotification object:nil];		

	
	[gameLogic initGameWithPlayerNumber:number];
	gameLogic.round = [[[Round alloc]init]autorelease];
	gameLogic.turn = [[[Turn alloc]init]autorelease];
	gameLogic.rumble = [[[Rumble alloc]init] autorelease];	
	
	//TODO: Game Init Logic
	[gameLogic.round enterRound];	
}

@end

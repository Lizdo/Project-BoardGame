//
//  SoundManager.m
//  BoardGame
//
//  Created by Liz on 10-10-7.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "SoundManager.h"


@interface SoundManager (Private)

- (void)cleanUp;

@end


@implementation SoundManager

@synthesize playSound,playMusic;

static SoundManager *sharedInstance = nil;

- (id)init{
	if (self = [super init]) {
		sounds = [[NSMutableArray arrayWithCapacity:0]retain];
		audioPlayers = [[NSMutableSet setWithCapacity:0]retain];
		
		[sounds insertObject:[NSArray arrayWithObjects:@"pickup", nil]
					 atIndex:SoundTagPickup];
		
		[sounds insertObject:[NSArray arrayWithObjects:@"dropdown",@"dropdown2",@"dropdown3", nil]
						 atIndex:SoundTagDropDown];

		[sounds insertObject:[NSArray arrayWithObjects:@"paperfly", nil]
					 atIndex:SoundTagPaperFly];

		[sounds insertObject:[NSArray arrayWithObjects:@"papershort", @"papershort2", @"papershort3", nil]
					 atIndex:SoundTagPaperShort];		
		
		[sounds insertObject:[NSArray arrayWithObjects:@"slide", nil]
					 atIndex:SoundTagSlide];		
		
		[sounds insertObject:[NSArray arrayWithObjects:@"coin", @"coin2", @"coin3", nil]
					 atIndex:SoundTagCoin];	
		
		[sounds insertObject:[NSArray arrayWithObjects:@"tape", nil]
					 atIndex:SoundTagTape];
		
		[sounds insertObject:[NSArray arrayWithObjects:@"button", nil]
					 atIndex:SoundTagButton];			
		
		playMusic = YES;
		playSound = YES;
		
	}
	return self;
}



- (void)playSoundWithTag:(SoundTag)tag{
	if (!playSound) {
		return;
	}

	NSString * name = [(NSArray *)[sounds objectAtIndex:tag] randomObject];
	NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@.caf", 
										 [[NSBundle mainBundle] resourcePath], 
										 name]];	
	
	NSError * error = nil;
	AVAudioPlayer * p = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	p.volume = 3.0;
	[p play];
	
	[audioPlayers addObject:p];
	[self cleanUp];

}

- (void)cleanUp{
	//sounds are no longer playing gets dealloced here.
	NSMutableSet * playersToDelete = [NSMutableSet setWithCapacity:0];
	for (AVAudioPlayer * p in audioPlayers) {
		if (!p.playing) {
			[p release];
			[playersToDelete addObject:p];
		}
	}
	
	[audioPlayers minusSet:playersToDelete];
}



#pragma mark -
#pragma mark Singleton methods

+ (SoundManager*)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
			sharedInstance = [[SoundManager alloc] init];
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

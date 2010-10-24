//
//  SoundManager.m
//  BoardGame
//
//  Created by Liz on 10-10-7.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "SoundManager.h"


@implementation SoundManager

@synthesize playSound,playMusic;

static SoundManager *sharedInstance = nil;

- (id)init{
	if (self = [super init]) {
		sounds = [[NSMutableArray arrayWithCapacity:0]retain];
		
		[sounds insertObject:[NSArray arrayWithObjects:@"pickup", nil]
					 atIndex:SoundTagPickup];
		
		[sounds insertObject:[NSArray arrayWithObjects:@"dropdown",@"dropdown2",@"dropdown3", nil]
						 atIndex:SoundTagDropDown];

		[sounds insertObject:[NSArray arrayWithObjects:@"paperfly", nil]
					 atIndex:SoundTagPaperFly];

		[sounds insertObject:[NSArray arrayWithObjects:@"papershort", @"papershort2", @"papershort3", nil]
					 atIndex:SoundTagPaperShort];		
		
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
	AVAudioPlayer * p = [[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error] autorelease];
	p.volume = 3.0;
	[p play];
	
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

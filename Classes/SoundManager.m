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
		dic = [[NSMutableDictionary dictionaryWithCapacity:0]retain];
		[self addSystemSoundWithName:@"beep"];
		[self addSystemSoundWithName:@"clash"];
		playMusic = YES;
		playSound = YES;
	}
	return self;
}

- (void)addSystemSoundWithName:(NSString *)name{
	NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@.caf", 
										 [[NSBundle mainBundle] resourcePath], 
										 name]];

	SystemSoundID aSoundID;
	OSStatus error = AudioServicesCreateSystemSoundID((CFURLRef)url, &aSoundID);
	if (error == kAudioServicesNoError) { // success
		[dic setObject:[NSNumber numberWithInt:aSoundID] forKey:name];
	} else {
		NSLog(@"Error %d loading sound : %@", error, name);
	}
}

- (void)beep{
	if (!playSound) {
		return;
	}
	AudioServicesPlaySystemSound([[dic objectForKey:@"beep"]intValue]);
}

- (void)clash{
	if (!playSound) {
		return;
	}	
	AudioServicesPlaySystemSound([[dic objectForKey:@"clash"]intValue]);
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

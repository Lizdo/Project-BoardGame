//
//  SoundManager.h
//  BoardGame
//
//  Created by Liz on 10-10-7.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioServices.h>


@interface SoundManager : NSObject{
	NSMutableDictionary * dic;
}

+ (SoundManager*)sharedInstance;

- (void)addSystemSoundWithName:(NSString *)name;

- (void)beep;
- (void)clash;

@end

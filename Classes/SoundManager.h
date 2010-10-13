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
	
	BOOL playSound;
	BOOL playMusic;	
}

@property (nonatomic,assign) BOOL playSound;
@property (nonatomic,assign) BOOL playMusic;

+ (SoundManager*)sharedInstance;

- (void)addSystemSoundWithName:(NSString *)name;

- (void)beep;
- (void)clash;

@end

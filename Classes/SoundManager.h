//
//  SoundManager.h
//  BoardGame
//
//  Created by Liz on 10-10-7.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioServices.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "TypeDef.h"

typedef enum{
	SoundTagPickup,
	SoundTagDropDown,
	SoundTagPaperFly,
	SoundTagPaperShort,	
}SoundTag;

@interface SoundManager : NSObject{
	NSMutableArray * sounds;

	BOOL playSound;
	BOOL playMusic;	
}

@property (nonatomic,assign) BOOL playSound;
@property (nonatomic,assign) BOOL playMusic;

+ (SoundManager*)sharedInstance;

- (void)playSoundWithTag:(SoundTag)tag;

@end

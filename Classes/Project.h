//
//  Project.h
//  BoardGame
//
//  Created by Liz on 10-9-7.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TypeDef.h"
#import "RumbleTarget.h"
#import "Player.h"
#import "AmountContainer.h"

@interface Project : NSObject <NSCoding> {
	RumbleTargetType type;
	AmountContainer * lockedResource;	
	int timeNeeded;
	int timeRemaining;
	BOOL isCompleted;
	
	Player * player;
}

@property (nonatomic,assign) RumbleTargetType type;
@property (nonatomic,assign) int timeNeeded;
@property (nonatomic,assign) int timeRemaining;
@property (nonatomic,assign) BOOL isCompleted;
@property (nonatomic,retain) AmountContainer * lockedResource;

@property (nonatomic,assign) Player * player;

- (id)initWithRumbleTarget:(RumbleTarget *)rt;
- (void)exitRumble;
- (void)complete;

+ (int)timeNeededForRumbleTargetType:(RumbleTargetType)aType;
+ (int)scoreForRumbleTargetType:(RumbleTargetType)aType;
+ (NSString *)shortDescriptionForRumbleTargetType:(RumbleTargetType)aType;


@end

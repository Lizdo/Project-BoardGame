//
//  Project.m
//  BoardGame
//
//  Created by Liz on 10-9-7.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "Project.h"
#import "TokenPlaceholder.h"

@interface Project (Private)
@end

@implementation Project

@synthesize type, lockedResource, timeNeeded, timeRemaining, isCompleted, player;

- (id)initWithRumbleTarget:(RumbleTarget *)rt{
	
	if (self = [super init]) {
		self.lockedResource = [AmountContainer emptyAmountContainer];
		
		type = rt.type;
		for (TokenPlaceholder * t in rt.tokenPlaceholders) {
			if (!t.matchedToken.shared) {
				[lockedResource modifyAmountForIndex:t.type by:1];
			}
		}
		
		timeNeeded = [Project timeNeededForRumbleTargetType:type];
		timeRemaining = timeNeeded;
		isCompleted = NO;
	}
	return self;

}



- (void)enterRound{
	if (timeRemaining > 0 && [Round sharedInstance]) {
		timeRemaining--;
		if (timeRemaining == 0) {
			isCompleted = YES;
			[self complete];
		}
	}
}

- (void)complete{
	//popup a warning or something
	
	//Unlock Player Resource
}


+ (int)timeNeededForRumbleTargetType:(RumbleTargetType)aType{
	switch (aType) {
		case RumbleTargetTypeSignal:
			return 2;
			break;
		case RumbleTargetTypeCart:
			return 2;
			break;
		case RumbleTargetTypeSnake:
			return 3;
			break;			
		case RumbleTargetTypeRobot:
			return 3;
			break;
		case RumbleTargetTypeTank:
			return 4;
			break;
		case RumbleTargetTypePalace:
			return 4;
			break;
		default:
			return 0;
			break;
	}
}


+ (int)scoreForRumbleTargetType:(RumbleTargetType)aType{
	switch (aType) {
		case RumbleTargetTypeSignal:
			return 5;
			break;
		case RumbleTargetTypeCart:
			return 5;
			break;
		case RumbleTargetTypeSnake:
			return 9;
			break;			
		case RumbleTargetTypeRobot:
			return 9;
			break;
		case RumbleTargetTypeTank:
			return 17;
			break;
		case RumbleTargetTypePalace:
			return 17;
			break;
		default:
			return 0;
			break;
	}
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeBool:isCompleted forKey:@"isCompleted"];
    [coder encodeInt:type forKey:@"type"];
    [coder encodeInt:timeRemaining forKey:@"timeRemaining"];
    [coder encodeInt:timeNeeded forKey:@"timeNeeded"];
	[coder encodeObject:lockedResource forKey:@"lockedResource"];
}


- (id)initWithCoder:(NSCoder *)coder {
	self = [[Project alloc]init];
	
    isCompleted = [coder decodeBoolForKey:@"isCompleted"];
    type = [coder decodeIntForKey:@"type"];
	
    timeRemaining = [coder decodeIntForKey:@"timeRemaining"];
    timeNeeded = [coder decodeIntForKey:@"timeNeeded"];
	
	self.lockedResource = [coder decodeObjectForKey:@"lockedResource"];
	
    return self;
}

- (NSString *)description{
	if (isCompleted) {
		return @"Completed";
	}else {
		return [NSString stringWithFormat:@"%d Weeks Remaining", timeRemaining];
	}

}

- (void)dealloc{
	[super dealloc];
}

@end

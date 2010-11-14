//
//  GameMode.m
//  BoardGame
//
//  Created by Liz on 10-11-14.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "GameMode.h"
#import "GameLogic.h"
#import "Player.h"
#import "Project.h"
#import "Badge.h"


@implementation GameMode

- (GameResult)validate{
	return GameResultContinue;
}

@end



@implementation GameModeCollectResource

- (id)initWithResourceType:(ResourceType)aType targetAmount:(int)amount andRoundLimit:(int)limit{
	if ((self = [super init])) {
		type = aType;
		targetAmount = amount;
	}
	return self;
}

- (GameResult)validate{
	//always check the first player
	Player * p = [[GameLogic sharedInstance] playerWithID:0];
	
	if ([p.tokenAmounts amountForIndex:type] >= targetAmount) {
		return GameResultSuccess;
	}
	
	if ([Round sharedInstance].count >= roundLimit) {
		return GameResultFailure;
	}	
	
	return GameResultContinue;
}

@end



@implementation GameModeBuildProject

- (id)initWithRumbleTargetType:(ResourceType)aType andRoundLimit:(int)limit{
	if ((self = [super init])) {
		type = aType;
		roundLimit = limit;
	}
	return self;
}


- (GameResult)validate{
	//always check the first player
	Player * p = [[GameLogic sharedInstance] playerWithID:0];
	
	for (Project * project in p.projects) {
		if (project.isCompleted && project.type == type) {
			return GameResultSuccess;
		}
	}
	
	if ([Round sharedInstance].count >= roundLimit) {
		return GameResultFailure;
	}
	
	return GameResultContinue;
}

@end



@implementation GameModeGetBadge

- (id)initWithBadgeType:(BadgeType)aType andRoundLimit:(int)limit{
	if ((self = [super init])) {
		type = aType;
		roundLimit = limit;
	}
	return self;
}

- (GameResult)validate{
	//always check the first player
	Player * p = [[GameLogic sharedInstance] playerWithID:0];
	
	for (Badge * b in p.badges) {
		if (b.type == type) {
			return GameResultSuccess;
		}
	}
	
	if ([Round sharedInstance].count >= roundLimit) {
		return GameResultFailure;
	}
		
	return GameResultContinue;
}

@end

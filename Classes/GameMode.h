//
//  GameMode.h
//  BoardGame
//
//  Created by Liz on 10-11-14.
//  Copyright 2010 StupidTent co. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "TypeDef.h"


#pragma mark Base


@interface GameMode : NSObject {
	
}

- (GameResult)validate;

@end

#pragma mark CollectResource

@interface GameModeCollectResource:GameMode{
	ResourceType type;
	int targetAmount;
	int roundLimit;	
}

- (id)initWithResourceType:(ResourceType)atype targetAmount:(int)amount andRoundLimit:(int)limit;

@end

#pragma mark BuildProject

@interface GameModeBuildProject:GameMode{
	RumbleTargetType type;
	int roundLimit;
}

- (id)initWithRumbleTargetType:(ResourceType)atype andRoundLimit:(int)limit;

@end

#pragma mark GetBadge

@interface GameModeGetBadge:GameMode{
	BadgeType type;
	int roundLimit;
}

- (id)initWithBadgeType:(BadgeType)atype andRoundLimit:(int)limit;

@end

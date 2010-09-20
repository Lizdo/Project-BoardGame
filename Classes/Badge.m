//
//  Badge.m
//  BoardGame
//
//  Created by Liz on 10-8-22.
//  Copyright (c) 2010年 __MyCompanyName__. All rights reserved.
//

#import "Badge.h"


@implementation Badge

@synthesize type, player, image;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
        self.userInteractionEnabled = YES;
    }
    return self;
}


+ (Badge *)badgeWithType:(BadgeType)t{
	Badge * b = [[Badge alloc]initWithFrame:CGRectMake(0,0,BadgeSize*2, BadgeSize*2)];
	b.type = t;
	b.image = [GameVisual imageForBadgeType:t];
	return [b autorelease];
}

- (void)drawRect:(CGRect)rect{
	if (image) {
		[image drawInRect:rect];
	}
}

+ (Badge *)maximumResourceBadgeWithType:(ResourceType)t{
	switch (t) {
		case ResourceTypeRect:
			return [Badge badgeWithType:BadgeTypeMostRect];
			break;
		case ResourceTypeRound:
			return [Badge badgeWithType:BadgeTypeMostRound];
			break;
		case ResourceTypeSquare:
			return [Badge badgeWithType:BadgeTypeMostSquare];
			break;			
		default:
			break;
	}
	return nil;
}

+ (BadgeType)maximumBadgeTypeForResource:(ResourceType)t{
	switch (t) {
		case ResourceTypeRect:
			return BadgeTypeMostRect;
			break;
		case ResourceTypeRound:
			return BadgeTypeMostRound;
			break;
		case ResourceTypeSquare:
			return BadgeTypeMostSquare;
			break;			
		default:
			break;
	}
	return 1000;
}


- (NSString *)title{
	return [NSString stringWithFormat:@"+%d", [self score]];
}


- (NSComparisonResult)compare:(Badge *)b{
	return [[NSNumber numberWithInt:self.type] compare:[NSNumber numberWithInt:b.type]];
}


- (int)score{
	return [GameLogic scoreForBadgeType:type];
}

- (NSString *)description{
	return [GameLogic descriptionForBadgeType:type];
}

- (void)dealloc {
    [super dealloc];
}


@end

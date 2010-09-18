//
//  Badge.m
//  BoardGame
//
//  Created by Liz on 10-8-22.
//  Copyright (c) 2010年 __MyCompanyName__. All rights reserved.
//

#import "Badge.h"


@implementation Badge

@synthesize type, popoverController, player;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
        self.userInteractionEnabled = YES;
		
		recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
		[self addGestureRecognizer:recognizer];		
    }
    return self;
}


+ (Badge *)badgeWithType:(BadgeType)t{
	Badge * b = [[Badge alloc]initWithFrame:CGRectMake(0,0,BadgeSize*2, BadgeSize*2)];
	b.type = t;
	b.image = [GameVisual imageForBadgeType:t];
	return [b autorelease];
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


- (void)addPopup{
	if (popupController == nil) {
		popupController = [[[BGPopupController alloc]initWithSourceObject:self]retain];
	}
	[popupController presentPopup];
	
}

- (void)handleTap{
	if (popupController && popupController.popupPresent) {
		[self removePopup];
	}else{
		[self addPopup];
	}
	
}


- (void)removePopup{
	if (popupController) {
		[popupController dismissPopup];
	}
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
	self.popoverController = nil;
    [super dealloc];
}


@end

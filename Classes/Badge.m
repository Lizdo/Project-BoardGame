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



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	BadgeInfoViewController * content;
	if (!popoverController) {
		content = [[BadgeInfoViewController alloc] init];
		content.view.transform = [self superview].transform;
		
		self.popoverController = [[UIPopoverController alloc]
								  initWithContentViewController:content];
		[content release];
	}else {
		content = (BadgeInfoViewController *)popoverController.contentViewController;
	}

	content.type = self.type;

	
	if (player.ID == 0 || player.ID == 2) {
		popoverController.popoverContentSize = CGSizeMake(200, 75);
	}else {
		popoverController.popoverContentSize = CGSizeMake(75, 200);
	}
	
	UIPopoverArrowDirection direction;
	
	switch (player.ID) {
		case 0:
			direction = UIPopoverArrowDirectionLeft;
			break;
		case 1:
			direction = UIPopoverArrowDirectionUp;
			break;
		case 2:
			direction = UIPopoverArrowDirectionRight;
			break;
		case 3:
			direction = UIPopoverArrowDirectionDown;
			break;
	}

	//aPopover.delegate = self;
	[popoverController presentPopoverFromRect:self.bounds inView:self.superview permittedArrowDirections:direction animated:YES];
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

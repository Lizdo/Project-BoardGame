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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	BadgeInfoViewController * content = [[BadgeInfoViewController alloc] init];
	content.view.transform = [self superview].transform;

	self.popoverController = [[UIPopoverController alloc]
									 initWithContentViewController:content];
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
	[content release];
	[popoverController presentPopoverFromRect:self.bounds inView:self.superview permittedArrowDirections:direction animated:YES];
}


- (void)dealloc {
	self.popoverController = nil;
    [super dealloc];
}


@end

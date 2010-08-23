//
//  Badge.h
//  BoardGame
//
//  Created by Liz on 10-8-22.
//  Copyright (c) 2010年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BadgeInfoViewController.h"
#import "TypeDef.h"
#import "GameVisual.h"
#import "GameLogic.h"
#import "Player.h"

@interface Badge : UIImageView {
    BadgeType type;
	UIPopoverController * popoverController;
	Player * player;
}

@property (nonatomic, assign) BadgeType type;
@property (nonatomic, retain) UIPopoverController * popoverController;
@property (nonatomic, assign) Player * player;

+ (Badge *)badgeWithType:(BadgeType)t;
+ (Badge *)maximumResourceBadgeWithType:(ResourceType)t;
+ (BadgeType)maximumBadgeTypeForResource:(ResourceType)t;

- (int)score;
- (NSString *)description;

@end

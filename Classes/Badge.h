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
#import "BGViewWithPopup.h"
#import "BGPopupController.h"


@interface Badge : BGViewWithPopup {
    BadgeType type;
	Player * player;
	
	UIImage * image;
}

@property (nonatomic, assign) BadgeType type;
@property (nonatomic, assign) Player * player;
@property (nonatomic, assign) UIImage * image;


+ (Badge *)badgeWithType:(BadgeType)t;
+ (Badge *)maximumResourceBadgeWithType:(ResourceType)t;

- (int)score;
- (NSString *)description;

@end

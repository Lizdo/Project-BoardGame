//
//  BadgeInfoViewController.h
//  BoardGame
//
//  Created by Liz on 10-8-22.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeDef.h"
#import "Badge.h"

@interface BadgeInfoViewController : UIViewController {
	IBOutlet UILabel * badgeScoreLabel;
	IBOutlet UILabel * badgeInfoLabel;
	
	BadgeType type;
}

@property (nonatomic, assign) BadgeType type;

@end

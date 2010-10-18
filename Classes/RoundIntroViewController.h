//
//  RoundIntroViewController.h
//  BoardGame
//
//  Created by Liz on 10-10-18.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Round.h"
#import "TypeDef.h"

@interface RoundIntroViewController : UIViewController {
	IBOutlet UILabel * currentRoundLabel;
	IBOutlet UILabel * lastRoundsRemaingLabel;
	IBOutlet UILabel * roundsRemaingLabel;
	
	Round * round;
}

- (void)show;

@end

//
//  BoardInfoViewController.h
//  BoardGame
//
//  Created by Liz on 10-10-13.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeDef.h"
#import "GameLogic.h"
#import "Round.h"
#import "SoundManager.h"


@interface BoardInfoViewController : UIViewController {
	IBOutlet UILabel * currentRoundLabel;
	IBOutlet UILabel * roundRemainingLabel;
	IBOutlet UITextView * roundDetailTextView;
	IBOutlet UIButton * toggleMusicButton;
	
	Round * round;
	GameLogic * gameLogic;
	SoundManager * soundManager;
}

- (void)update;
- (NSString *)roundInfo;
- (IBAction)toggleMusic;

@end
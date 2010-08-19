//
//  ScoreViewController.h
//  BoardGame
//
//  Created by Liz on 10-5-9.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"
#import "NoteView.h"


@interface ScoreViewController : UIViewController {
	IBOutlet UILabel * scoreLabel;
	
	IBOutlet UILabel * roundScoreLabel;
	IBOutlet UILabel * rectScoreLabel;
	IBOutlet UILabel * squareScoreLabel;
	IBOutlet UILabel * robotScoreLabel;
	IBOutlet UILabel * snakeScoreLabel;
	IBOutlet UILabel * palaceScoreLabel;
	
	IBOutlet UILabel * resourceScoreLabel;	
	IBOutlet UILabel * buildScoreLabel;
	
	Player * player;
}

@property (nonatomic,assign) Player * player;

- (void)update;



@end

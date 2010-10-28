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
	
	IBOutlet UIWebView * scoreWebView;
	
	Player * player;
}

@property (nonatomic,assign) Player * player;

- (void)update;
- (NSString *)scoreDescription;


@end

//
//  Info.h
//  BoardGame
//
//  Created by Liz on 10-5-1.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameVisual.h"
#import "TypeDef.h"
#import "Player.h"
#import "ScoreViewController.h"
#import "RuleViewController.h"
#import "NoteView.h"
#import "ContainerView.h"

@class GameLogic;

@interface Info : ContainerView {
	UIButton * endTurnButton;
	UIButton * toggleAIButton;
    UIImageView * currentPlayerMark;
    
	GameLogic * gameLogic;
	Player * player;
	
	BOOL allowEndTurn;

	
	ScoreViewController * svc;
	RuleViewController * rvc;
	
}

@property BOOL allowEndTurn;
@property (nonatomic,assign) Player * player;

- (void)initGame;

- (void)endTurnButtonClicked;
- (void)toggleAIButtonClicked;
- (void)setToggleAIButtonImage;

- (void)update;

@end

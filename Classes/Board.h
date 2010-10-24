//
//  Board.h
//  BoardGame
//
//  Created by Liz on 10-5-1.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameVisual.h"
#import "TypeDef.h"

#import "Token.h"
#import "Tile.h"
#import "Info.h"

#import "ContainerView.h"
#import "BoardGameView.h"
#import "CurrentPlayerMark.h"

#import "BoardInfoViewController.h"
#import "RoundIntroViewController.h"
#import "RumbleIntroViewController.h"

@class RumbleBoard;
@class GameLogic;
@class BoardGameViewController;
@class BoardGameView;

@interface Board : UIView <BGPopupBoard>{
	NSMutableArray * tiles;
	NSMutableArray * infos;
	NSMutableArray * tokens;

	GameLogic * gameLogic;
	RumbleBoard * rumbleBoard;
	
	ContainerView * infoView;
	ContainerView * tileView;
	ContainerView * tokenView;
	ContainerView * popupView;
	
	BoardGameViewController * controller;
	BoardGameView * bgv;
	
	BoardInfoViewController * biv;
	
	RoundIntroViewController * riv;
	RumbleIntroViewController * ruiv;

	CurrentPlayerMark * currentPlayerMark;
		
}

+ (Board*)sharedInstance;

- (void)enableEndTurnButton;
- (void)disableEndTurnButton;
- (void)initGame;
- (void)addView:(UIView *)view;

- (void)initGame;
- (void)update;
- (void)removeAllBadges;
- (void)addBadges;

//- (void)disableAnimations;
//- (void)enableAnimations;

- (void)enterRound;
- (void)enterTurn;
- (void)addRoundIntro;
- (void)addRumbleIntro;

- (void)showTutorial;

- (void)resetTokenForPlayerID:(int)playerID;
- (void)addTokenForPlayerID:(int)playerID withType:(TokenType)type andAnim:(BOOL)withAnim;
- (void)removeTokenForPlayerID:(int)playerID withType:(TokenType)type;
- (void)setLockedTokenForPlayerID:(int)playerID;

- (void)tokenPickedup:(Token *)t;

- (void)enterRumble;
- (void)exitRumble;
- (void)updateRumble;

- (void)enterConclusion;


- (UIInterfaceOrientation)interfaceOrientation;

@end

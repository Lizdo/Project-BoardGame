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


@class RumbleBoard;
@class GameLogic;
@class BoardGameViewController;

@interface Board : UIView {
	NSMutableArray * tiles;
	NSMutableArray * infos;
	NSMutableArray * tokens;

	GameLogic * gameLogic;
	RumbleBoard * rumbleBoard;
	
	ContainerView * infoView;
	ContainerView * tileView;
	ContainerView * tokenView;
	BoardGameViewController * controller;
}


- (void)enableEndTurnButton;
- (void)disableEndTurnButton;
- (void)initGame;
- (void)addView:(UIView *)view;

- (void)initGame;
- (void)update;

- (void)disableAnimations;
- (void)enableAnimations;

- (void)enterRumble;
- (void)exitRumble;
- (void)updateRumble;

- (UIInterfaceOrientation)interfaceOrientation;

- (RumbleBoard *)rumbleBoard;

@end

//
//  BoardGameView.h
//  BoardGame
//
//  Created by Liz on 10-8-25.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Board.h"
#import "RumbleBoard.h"
#import "TypeDef.h"

@class BoardGameViewController;


@interface BoardGameView : UIView {
	Board * board;
	RumbleBoard * rumbleBoard;
	
	BoardGameViewController * controller;
}

- (void)initGame;

- (void)enterRumble;
- (void)exitRumble;

- (void)reset;

@end

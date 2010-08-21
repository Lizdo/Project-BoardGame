//
//  BoardGameViewController.h
//  BoardGame
//
//  Created by Liz on 10-5-1.
//  Copyright StupidTent co 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Board.h"
#import "Game.h"
#import "MainMenuViewController.h"
#import "TypeDef.h"

@interface BoardGameViewController : UIViewController {
	Board * board;
	Game * game;
	UIView * menu;
    
    MainMenuViewController * mmv;
}

@end


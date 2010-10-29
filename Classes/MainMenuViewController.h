//
//  MainMenuViewController.h
//  BoardGame
//
//  Created by Liz on 10-7-17.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

@interface MainMenuViewController : UIViewController {
	IBOutlet UIButton * onePlayerButton;
	IBOutlet UIButton * twoPlayersButton;
	IBOutlet UIButton * threePlayersButton;
	IBOutlet UIButton * fourPlayersButton;
	
	IBOutlet UIButton * tutorialButton;	
	IBOutlet UIButton * resumeGameButton;
	
	Game * game;
}

- (IBAction) playWithOnePlayer;
- (IBAction) playWithTwoPlayers;
- (IBAction) playWithThreePlayers;
- (IBAction) playWithFourPlayers;

- (IBAction) aiPlay;


- (IBAction) resumeGame;
- (IBAction) showTutorial;

- (void)startGameWithPlayerNumber:(int)playerNumber;

@end

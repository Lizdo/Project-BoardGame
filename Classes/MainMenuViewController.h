//
//  MainMenuViewController.h
//  BoardGame
//
//  Created by Liz on 10-7-17.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "ChallengeMenu.h"

@interface MainMenuViewController : UIViewController {
	
	IBOutlet UIButton * fourPlayerToggleButton;	
	
	Game * game;
}

- (IBAction) playWithOnePlayer;
- (IBAction) playWithTwoPlayers;
- (IBAction) playWithThreePlayers;
- (IBAction) playWithFourPlayers;

- (IBAction) playWithAI;
- (IBAction) playWithHuman;

- (IBAction) aiPlay;

- (IBAction) toggleFourPlayersButton;

- (IBAction) resumeGame;
- (IBAction) showTutorial;
- (IBAction) showChallengeMenu;

- (void)startGameWithPlayerNumber:(int)playerNumber;

@end

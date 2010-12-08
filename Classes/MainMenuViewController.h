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
@class TutorialViewController;

@interface MainMenuViewController : UIViewController {
	
	IBOutlet UIButton * fourPlayerToggleButton;	
	
	ChallengeMenu * cm;
	TutorialViewController * tvc;
	
	Game * game;
}

@property (nonatomic, retain) ChallengeMenu * cm;
@property (nonatomic, retain) TutorialViewController * tvc;

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

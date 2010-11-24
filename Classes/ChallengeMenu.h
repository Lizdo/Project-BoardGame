//
//  ChallengeMenu.h
//  BoardGame
//
//  Created by Liz on 10-11-22.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameMode.h"
#import "GameVisual.h"
#import "SoundManager.h"
@class Game;
@class ChallengeMenu;

@interface ChallengeItem : NSObject
{
	int ID;
	GameMode * mode;
	UIButton * button;
	ChallengeMenu * controller;
}

@property (nonatomic) int ID;
@property (nonatomic, retain) GameMode * mode;
@property (nonatomic, retain) UIButton * button;
@property (nonatomic, assign) ChallengeMenu * controller;

+ (ChallengeItem *)itemWithID:(int)theID andGameMode:(GameMode *)gameMode;
- (void)handleTap;

@end


@interface ChallengeMenu : UIViewController {
	NSMutableArray * challengeItems;
	Game * game;
}

//Return to MainMenu
- (IBAction)back;

//Start Game with GameMode
- (void)startGameWithGameMode:(GameMode *)mode;

@end

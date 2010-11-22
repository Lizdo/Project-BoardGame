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

@interface ChallengeItem : NSObject
{
	int ID;
	GameMode * mode;
	UIButton * button;
}

@property (nonatomic) int ID;
@property (nonatomic, retain) GameMode * mode;
@property (nonatomic, retain) UIButton * button;

+ (ChallengeItem *)itemWithID:(int)theID andGameMode:(GameMode *)gameMode;

@end


@interface ChallengeMenu : UIViewController {
	NSMutableArray * challengeItems;
}

@end

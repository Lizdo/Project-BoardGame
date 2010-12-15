//
//  Info.m
//  BoardGame
//
//  Created by Liz on 10-5-1.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "Info.h"
#import "GameLogic.h"
#import "SoundManager.h"


@interface Info (Private)

- (UIImageView *)initRumbleIconAt:(CGPoint)p withType:(RumbleTargetType)type;
- (UILabel *)initRumbleCountAt:(CGRect)r;
- (CGPoint)badgePositionForID:(int)i;

@end

@implementation Info

@synthesize allowEndTurn, player;

- (void)setAllowEndTurn:(BOOL)allow{
	if (allow){
		endTurnButton.hidden = NO;
	}else {
		endTurnButton.hidden = YES;
	}
	allowEndTurn = allow;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		gameLogic = [GameLogic sharedInstance];
		
		backgroundImage = [[UIImageView alloc] initWithFrame:self.bounds];
		[self addSubview:backgroundImage];

        endTurnButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[self addSubview:endTurnButton];
		//endTurnButton.center = CGPointMake(100,100);
		[endTurnButton setBackgroundImage:[UIImage imageNamed:@"EndTurn.png"] forState:UIControlStateNormal];
		[endTurnButton setBackgroundImage:[UIImage imageNamed:@"EndTurn_Highlight.png"] forState:UIControlStateHighlighted];

        
        endTurnButton.frame = CGRectMake(390, 70, 70, 70);
		[endTurnButton addTarget:self action:@selector(endTurnButtonClicked) forControlEvents:UIControlEventTouchUpInside];
		
		toggleAIButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[self addSubview:toggleAIButton];
		toggleAIButton.frame = CGRectMake(510, 150, 50, 50);
		[toggleAIButton addTarget:self action:@selector(toggleAIButtonClicked) forControlEvents:UIControlEventTouchUpInside];
		
//        currentPlayerMark = [[UIImageView alloc] init];
//        [self addSubview:currentPlayerMark];
//        [currentPlayerMark setImage:[UIImage imageNamed:@"CurrentProducer.png"]];
//        currentPlayerMark.frame = CGRectMake(300, 30, 50, 50);
//        currentPlayerMark.hidden = YES;
		
		
		rvc = [[RuleViewController alloc] initWithNibName:@"RuleView" bundle:nil];
		[self addSubview:rvc.view];
		rvc.view.center = CGPointMake(NoteViewWidth/2, NoteViewHeight/2 + NoteViewOffset);
		//((NoteView *)rvc.view).hasSlidedOut = NO;		
		
		svc = [[ScoreViewController alloc] initWithNibName:@"ScoreView" bundle:nil];
		[self addSubview:svc.view];
		svc.view.center = CGPointMake(NoteViewWidth/2 + 80, NoteViewHeight/2 + NoteViewOffset);
		//((NoteView *)svc.view).hasSlidedOut = NO;		
		
		
		pvc = [[ProjectProgressViewController alloc]initWithNibName:@"ProjectProgressView" bundle:nil];
		[self addSubview:pvc.view];
		pvc.view.center = CGPointMake(NoteViewWidth/2 + 200, NoteViewHeight/2 + NoteViewOffset);
		//((NoteView *)pvc.view).hasSlidedOut = NO;		
		
		self.clipsToBounds = YES;


		
	}
    return self;
}

- (void)initGame{
	[self setToggleAIButtonImage];
	self.allowEndTurn = NO;
	
	backgroundImage.image = [GameVisual infoBackgroundForPlayerID:player.ID];
}

- (UIImageView *)initRumbleIconAt:(CGPoint)p withType:(RumbleTargetType)type{
	UIImageView * icon = [[UIImageView alloc] initWithImage:[GameVisual imageForRumbleType:type]];
	[self addSubview:icon];
	icon.center = p;	
	icon.hidden = YES;
	return icon;
}

- (UILabel *)initRumbleCountAt:(CGRect)r{
	UILabel * count = [[UILabel alloc] initWithFrame:r];
	count.font = [UIFont fontWithName:PrimaryFontName size:30];
	count.opaque = NO;
	count.backgroundColor = nil;
	count.textColor = [UIColor colorWithHex:0x585858];
	[self addSubview:count];
	return count;
}

- (void)endTurnButtonClicked{
	if (player.aiProcessInProgress || player != gameLogic.currentPlayer) {
		return;
	}else {
		[[SoundManager sharedInstance] playSoundWithTag:SoundTagButton];
		[gameLogic endTurnButtonClicked];
	}

	
}

- (void)toggleAIButtonClicked{
	if (player.aiProcessInProgress) {
		return;
	}
	[[SoundManager sharedInstance] playSoundWithTag:SoundTagButton];	
	player.isHuman = !player.isHuman;
	if (!player.isHuman) {
		if (player == gameLogic.currentPlayer) {
			[player processAI];
		}
	}
	[self setToggleAIButtonImage];

}

- (void)setToggleAIButtonImage{
	
	if (player.isHuman) {
		[toggleAIButton setBackgroundImage:[UIImage imageNamed:@"Player.png"] forState:UIControlStateNormal];
	}else {
		[toggleAIButton setBackgroundImage:[UIImage imageNamed:@"AI.png"] forState:UIControlStateNormal];
	}	
}

- (void)update{
	if (svc.player == nil) {
		svc.player = self.player;
	}
	[svc update];
	
	if (pvc.player == nil) {
		pvc.player = self.player;
	}
	[pvc update];
	
	if (gameLogic.currentPlayer == self.player) {
		backgroundImage.hidden = NO;
	}else {
		backgroundImage.hidden = YES;
	}


}

- (void)removeAllBadges{
	for (UIView * view in self.subviews) {
		if ([view isKindOfClass:[Badge class]]) {
			[view removeFromSuperview];
		}
	}	
}

- (void)addBadges{
	[self removeAllBadges];
	for (int i = 0; i<[player badges].count; i++) {
		Badge * b = [[player badges] objectAtIndex:i];
		[self insertSubview:b aboveSubview:backgroundImage];
		b.center = [self badgePositionForID:i];
	}
}

- (CGPoint)badgePositionForID:(int)i{
	float interval = BadgeSize * 2 + BadgeInterval;
	int rows = 3; //InfoHeight/interval;
	int row = i%rows;
	int colomn = (i-row)/rows;
	
	return CGPointMake(BadgeSize + BadgeInterval + interval*colomn + 10, BadgeSize + BadgeInterval + interval*row);
}

- (void)dealloc {
	[svc release];
    [super dealloc];
}


@end

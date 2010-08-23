//
//  Board.m
//  BoardGame
//
//  Created by Liz on 10-5-1.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "Board.h"
#import "GameLogic.h"
#import "RumbleBoard.h"
#import "BoardGameViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface Board (Private)
- (void)recursiveDisableAnimation:(UIView *)view;
- (void)recursiveEnableAnimation:(UIView *)view;
@end

@implementation Board


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		gameLogic = [GameLogic sharedInstance];
		gameLogic.board = self;
		
		tileView = [[ContainerView alloc]initWithFrame:self.bounds];
		tileView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		[self addSubview:tileView];

		tokenView = [[ContainerView alloc]initWithFrame:self.bounds];
		tokenView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;		
		[self addSubview:tokenView];			
		
		infoView = [[ContainerView alloc]initWithFrame:self.bounds];
		infoView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;		
		[self addSubview:infoView];			
		
		rumbleBoard = [[RumbleBoard alloc]initWithFrame:self.bounds];
		rumbleBoard.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;		
	
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

		
		
	}
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initGame{
	//init info
	infos = [NSMutableArray arrayWithCapacity:0];
	[infos retain];
	for (int i=0; i<4; i++) {
		Info * info = [[Info alloc] initWithFrame:CGRectMake(0, 0, 568, 200)];
		info.player = [gameLogic playerWithID:i];
		CGAffineTransform t = info.transform;
		info.transform = CGAffineTransformRotate(t,90*i*PI/180);
		
		info.center = [GameVisual infoCenterForPlayerID:i];
		info.autoresizingMask = [GameVisual infoResizingMaskForPlayerID:i];

		info.player.token.center = info.center;
		info.player.initialTokenPosition = info.center;
		
		[infoView addSubview:info];
		[infos addObject:info];
		[info release];
		[info initGame];
		
	}
	
//	ScoreSheetView * scoreSheet = [[ScoreSheetView alloc] initWithNibName:@"ScoreSheetView" bundle:nil];
//	[self addSubview:scoreSheet];

}

- (void)enableEndTurnButton{
	for (int i=0;i<4;i++){
		if (i == gameLogic.currentPlayer.ID) {
			((Info *)[infos objectAtIndex:i]).allowEndTurn = YES;
		}else {
			((Info *)[infos objectAtIndex:i]).allowEndTurn = NO;		
		}
	}
}

- (void)disableEndTurnButton{
	for (int i=0;i<4;i++){
		((Info *)[infos objectAtIndex:i]).allowEndTurn = NO;		
	}
}

- (void)update{
	for (Info * info in infos) {
		[info update];
		[info setNeedsDisplay];
	}
	for (Tile * tile in [gameLogic tiles]){
		[tile setNeedsDisplay];
	}
	
	[rumbleBoard update];
}

- (void)removeAllBadges{
	for (Info * info in infos) {
		[info removeAllBadges];
	}
}

- (void)addBadges{
	for (Info * info in infos) {
		[info addBadges];
	}
}

- (void)enterRumble{
	rumbleBoard.frame = self.bounds;
	[rumbleBoard enterRumble];
	
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:YES];
	[UIView setAnimationDelegate:rumbleBoard];
	[UIView setAnimationDidStopSelector:@selector(enterRumbleAnimDidStop)];
	
    [self addSubview:rumbleBoard];
    [UIView commitAnimations];
}

- (void)exitRumble{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:YES];
	
    [rumbleBoard removeFromSuperview];
    [UIView commitAnimations];	
	[rumbleBoard exitRumble];	
}

- (void)updateRumble{
	[rumbleBoard update];
}


- (void)addView:(UIView *)view{
	if ([view isKindOfClass:[Token class]]) {
		[tokenView addSubview:view];
	}else if ([view isKindOfClass:[Tile class]]) {
		[tileView addSubview:view];
	}
	else {
		[super addSubview:view];
	}

}

- (void)disableAnimations{
	[self recursiveDisableAnimation:self];
}


- (void)enableAnimations{
	[self recursiveEnableAnimation:self];	
}

- (void)recursiveDisableAnimation:(UIView *)view{
	[view saveCurrentAnim];
	 for (UIView * subview in view.subviews) {
		[self recursiveDisableAnimation:subview];
	}
}
- (void)recursiveEnableAnimation:(UIView *)view{
	[view restoreCurrentAnim];
	for (UIView * subview in view.subviews) {
		[self recursiveEnableAnimation:subview];
	}
}


- (UIInterfaceOrientation)interfaceOrientation{
	return ((BoardGameViewController*)controller).interfaceOrientation;
}

- (void)dealloc {
	[infoView release];
	[tileView release];
	[tokenView release];
	
    [super dealloc];
}

- (RumbleBoard *)rumbleBoard{
	return rumbleBoard;
}

@end

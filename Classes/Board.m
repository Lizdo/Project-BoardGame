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
//- (void)recursiveDisableAnimation:(UIView *)view;
//- (void)recursiveEnableAnimation:(UIView *)view;

- (CGPoint)positionForToken:(Token *)t;
- (void)removeTokenWithAnim:(Token *)t;
- (void)placeToken:(Token *)t withAnim:(BOOL)withAnim;
- (int)idForToken:(Token *)token;

@end

@implementation Board

static Board *sharedInstance = nil;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		gameLogic = [GameLogic sharedInstance];
		gameLogic.board = self;
		
		sharedInstance = self;
		
		tileView = [[ContainerView alloc]initWithFrame:self.bounds];
		tileView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		[self addSubview:tileView];

		currentPlayerMark = [[CurrentPlayerMark alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
		[self addSubview:currentPlayerMark];
		
		tokenView = [[ContainerView alloc]initWithFrame:self.bounds];
		tokenView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;		
		[self addSubview:tokenView];			
		
		infoView = [[ContainerView alloc]initWithFrame:self.bounds];
		infoView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;		
		[self addSubview:infoView];	
		
		popupView = [[ContainerView alloc]initWithFrame:self.bounds];
		popupView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;		
		[self addSubview:popupView];				
	
		biv = [[[BoardInfoViewController alloc] initWithNibName:@"BoardInfo" bundle:nil]retain];
		biv.view.center = CGPointMake(200/2, 200 + 236/2);
		[tileView addSubview:biv.view];
		
		riv = [[[RoundIntroViewController alloc] initWithNibName:@"RoundIntroView" bundle:nil] retain];
		riv.view.center = [GameVisual boardCenter];
		
		ruiv = [[[RumbleIntroViewController alloc] initWithNibName:@"RumbleIntroView" bundle:nil]retain];
		ruiv.view.center = [GameVisual boardCenter];
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		self.clipsToBounds = YES;
		
		
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
	self.backgroundColor = [GameVisual boardBackgroundImage];
	//init info
	tokens = [[NSMutableArray arrayWithCapacity:0]retain];

	infos = [NSMutableArray arrayWithCapacity:0];
	[infos retain];
	for (int i=0; i<[Game TotalNumberOfPlayers]; i++) {
		Info * info = [[Info alloc] initWithFrame:CGRectMake(0, 0, 568, 200)];
		info.player = [gameLogic playerWithID:i];
//		CGAffineTransform t = info.transform;
//		info.transform = CGAffineTransformRotate(t,90*i*PI/180);
		info.transform = [GameVisual transformForPlayerID:i];		
		info.center = [GameVisual infoCenterForPlayerID:i];
		info.autoresizingMask = [GameVisual infoResizingMaskForPlayerID:i];

		info.player.token.center = info.center;
		info.player.initialTokenPosition = info.center;
		
		[infoView addSubview:info];
		[infos addObject:info];
		[info release];
		[info initGame];
	}
	
	//Move to player 0 because the player is not initialized yet
	[currentPlayerMark moveToPlayerWithID:0 withAnim:NO];
	rumbleBoard = [RumbleBoard sharedInstance];
}

- (void)enableEndTurnButton{
	for (int i=0;i<[Game TotalNumberOfPlayers];i++){
		if (i == gameLogic.currentPlayer.ID) {
			((Info *)[infos objectAtIndex:i]).allowEndTurn = YES;
		}else {
			((Info *)[infos objectAtIndex:i]).allowEndTurn = NO;		
		}
	}
}

- (void)disableEndTurnButton{
	for (int i=0;i<[Game TotalNumberOfPlayers];i++){
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
	[biv update];
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

- (void)enterRound{
	//[currentPlayerMark moveToPlayerWithID:gameLogic.currentPlayer.ID withAnim:NO];
}


- (void)addRoundIntro{
	[self addSubview:riv.view];
	riv.view.center = self.center;
	[riv show];
	[self update];
}

- (void)addRumbleIntro{
	[self removeAllPopups];	
	[self addSubview:ruiv.view];
	[ruiv show];
	[self update];
}


//TODO: Add a UI Button
- (void)resetTokenForPlayerID:(int)playerID{
	for (Token * t in tokens) {
		if (t.player.ID == playerID && t.hasMoved) {
			[self placeToken:t withAnim:YES];
		}
	}
}

- (void)addTokenForPlayerID:(int)playerID withType:(TokenType)type andAnim:(BOOL)withAnim{
	Token * t = [Token tokenWithType:type andPosition:OffBoardPosition];
	t.player = [gameLogic playerWithID:playerID];
	t.transform = ((Info *)[infos objectAtIndex:playerID]).transform;
	t.onBoardID = [self idForToken:t];
	[tokens addObject:t];
	[tokenView addSubview:t];
	if (withAnim) {
		[self placeToken:t withAnim:YES];
	}else {
		t.center = [self positionForToken:t];
	}
}

- (int)idForToken:(Token *)token{
	//new id = count, must assign player/type before this
	int count = 0;
	for (Token * t in tokens) {
		if (t.player == token.player && t.type == token.type) {
			count++;
		}
	}
	return count;
}

- (void)placeToken:(Token *)t withAnim:(BOOL)withAnim{
	if (withAnim) {
		[UIView beginAnimations:nil context:nil]; 
		[UIView setAnimationDuration:MoveAnimationTime]; 
		t.center = [self positionForToken:t];
		[UIView commitAnimations];
	}else {
		t.center = [self positionForToken:t];
	}
}

- (void)removeTokenForPlayerID:(int)playerID withType:(TokenType)type{
	//Find the 
	NSMutableArray * availableTokenArray = [NSMutableArray arrayWithCapacity:0];
	for (Token * t in tokens) {
		if (t.player.ID == playerID && t.type == type && !t.hasMoved) {
			[availableTokenArray addObject:t];
		}
	}
	
	if (availableTokenArray.count == 0) {
		//delete a random one
		for (Token * t in tokens) {
			if(t.player.ID == playerID && t.type == type){
				[self removeTokenWithAnim:t];
				break;
			}
		}
		//reassign the ID, as we have removed one random object
		int newOnBoardID = 0;
		for (Token * t in tokens) {
			if(t.player.ID == playerID && t.type == type){
				t.onBoardID = newOnBoardID;
				newOnBoardID++;
			}
		}
		
	}else{
		[availableTokenArray sortUsingSelector:@selector(compare:)];
		Token *t = [availableTokenArray lastObject];
		[self removeTokenWithAnim:t];
	}
}

- (void)removeTokenWithAnim:(Token *)t{
	[tokens removeObject:t];
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationDuration:MoveAnimationTime]; 
	[UIView setAnimationDidStopSelector:@selector(removeAnimDidStop)];
	[UIView setAnimationDelegate:t];
	t.center = OffBoardPosition;
	[UIView commitAnimations];	
}


- (void)setLockedTokenForPlayerID:(int)playerID{
	//reset all locked tokens
	for (Token * t in tokens){
		if (t.player.ID == playerID && t.locked) {
			t.locked = NO;
			[self placeToken:t withAnim:NO];
		}
	}
	//find the last tokens according to token locked amount, move to position
	Player * p = [gameLogic playerWithID:playerID];
	for (int type = 0; type < NumberOfTokenTypes; type++) {
		int totalAmount = [p.tokenAmounts amountForIndex:type];
		int lockedAmount = [p.lockedAmounts amountForIndex:type];
		for (Token * t in tokens) {
			if (t.player.ID == playerID && t.type == type 
				&& t.onBoardID >= totalAmount - lockedAmount) {
				//lock t
				t.locked = YES;
				t.center = [self positionForToken:t];
			}
		}
	}
}




- (CGPoint)positionForToken:(Token *)t{
	float verticalOffset = (TokenSize * 2) * t.type;
	float horizontalOffset = BoardTokenInterval * t.onBoardID;
	float lockedOffset = t.locked ? BoardTokenLockedOffset : 0;
	
	CGPoint position = [GameVisual positionForPlayerID:t.player.ID
		   withOffsetFromInfoCenter:CGSizeMake(BoardTokenOffset.width + horizontalOffset + lockedOffset,
											   BoardTokenOffset.height + verticalOffset)];
	
	return position;
}




- (void)tokenPickedup:(Token *)t{
	if ([tokens indexOfObject:t] != NSNotFound) {
		[tokenView insertSubview:t atIndex:[tokenView subviews].count - 1];
	}
}

- (void)showTutorial{
	if (gameLogic.animationInProgress) {
		return;
	}else {
		[controller showTutorial];
	}

}


- (void)enterTurn{
	[currentPlayerMark moveToPlayerWithID:gameLogic.currentPlayer.ID withAnim:YES];
}


- (void)enterRumble{
	[self removeAllPopups];
	[bgv enterRumble];
//	rumbleBoard.frame = self.bounds;
//	[rumbleBoard enterRumble];
//	
//	[UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.5];
//    [UIView setAnimationBeginsFromCurrentState:NO];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:YES];
//	[UIView setAnimationDelegate:rumbleBoard];
//	[UIView setAnimationDidStopSelector:@selector(enterRumbleAnimDidStop)];
//	
//    [self addSubview:rumbleBoard];
//    [UIView commitAnimations];
}

- (void)exitRumble{
	[ruiv.view removeFromSuperview];
	[bgv exitRumble];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.5];
//    [UIView setAnimationBeginsFromCurrentState:NO];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:YES];
//	
//    [rumbleBoard removeFromSuperview];
//    [UIView commitAnimations];	
//	[rumbleBoard exitRumble];	
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
//
//- (void)disableAnimations{
//	[self recursiveDisableAnimation:self];
//}
//
//
//- (void)enableAnimations{
//	[self recursiveEnableAnimation:self];	
//}
//
//- (void)recursiveDisableAnimation:(UIView *)view{
//	[view saveCurrentAnim];
//	 for (UIView * subview in view.subviews) {
//		[self recursiveDisableAnimation:subview];
//	}
//}
//- (void)recursiveEnableAnimation:(UIView *)view{
//	[view restoreCurrentAnim];
//	for (UIView * subview in view.subviews) {
//		[self recursiveEnableAnimation:subview];
//	}
//}


- (UIInterfaceOrientation)interfaceOrientation{
	return ((BoardGameViewController*)controller).interfaceOrientation;
}

- (void)enterConclusion{
	[controller enterConclusion];
}

#pragma mark -
#pragma mark Popup methods


- (void)addPopup:(UIView *)popup{
	[popupView addSubview:popup];
}

- (void)removePopup:(UIView *)popup{
	[popup removeFromSuperview];
}

- (void)removeAllPopups{
	for (UIView * view in popupView.subviews){
		[view removeFromSuperview];
	}
}


- (void)dealloc {
	[infoView release];
	[tileView release];
	[tokenView release];
	[biv release];
	[riv release];
	[ruiv release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark Singleton methods

+ (Board*)sharedInstance
{
		NSAssert(sharedInstance != nil, @"Board need to initialize with initWithFrame:");
//		@synchronized(self)
//    {
//        if (sharedInstance == nil)
//			DebugLog(@"Board need to initialize with initWithFrame:");
//			sharedInstance = [[Board alloc] init];
//    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}


@end

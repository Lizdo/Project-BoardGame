//
//  RumbleInfo.m
//  BoardGame
//
//  Created by Liz on 10-5-17.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "RumbleInfo.h"
#import "RumbleBoard.h"
#import "GameLogic.h"

@interface RumbleInfo (Private)
- (CGPoint)nextPosition;

- (UIImageView *)initRumbleIconAt:(CGPoint)p withType:(RumbleTargetType)type;
- (UILabel *)initRumbleCountAt:(CGRect)r;

- (void)activateCurrentRumbleTarget;
- (void)deactivateCurrentRumbleTarget;

- (CGPoint)positionForRumbleTargetType:(RumbleTargetType)type;

@end

@implementation RumbleInfo

@synthesize player, currentRumbleTarget, rumbleTargets;

- (void)setPlayer:(Player *)newPlayer{
	player = newPlayer;
	//self.backgroundColor = [GameVisual colorForPlayerID:player.ID];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		//self.backgroundColor = [UIColor blueColor];
		backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(- (768-RumbleInfoWidth)/2
																		, 0, 768-RumbleInfoHeight, RumbleInfoHeight)];
		[self addSubview:backgroundImage];		
		
		gameLogic = [GameLogic sharedInstance];
		self.rumbleTargets = [NSMutableArray arrayWithCapacity:0];
		rumbleAlone = NO;
    }
    return self;
}

- (void)initGame{
	for (int i=0; i<NumberOfRumbleTargetTypes; i++) {
		RumbleTarget * rt = [RumbleTarget rumbleTargetWithType:i];
		rt.player = self.player;
		rt.info = self;
		[gameLogic.rumbleTargets addObject:rt];
		[rumbleTargets addObject:rt];
		//[self addSubview:rt];
	}
	
	backgroundImage.image = [GameVisual rumbleInfoBackgroundForPlayerID:player.ID];

	
//	NSMutableArray * iconArray = [NSMutableArray arrayWithCapacity:0];
//	
//	for (int i = 0; i<NumberOfRumbleTargetTypes; i++) {
//		CGPoint p = CGPointMake(15, 25 + i*50);
//		[iconArray addObject:[self initRumbleIconAt:p withType:i]]; 
//	}
//	robotIcon = [iconArray objectAtIndex:0];
//	snakeIcon = [iconArray objectAtIndex:1];
//	palaceIcon = [iconArray objectAtIndex:2];	

	
//	NSMutableArray * countArray = [NSMutableArray arrayWithCapacity:0];
//	
//	for (int i = 0; i<3; i++) {
//		CGRect r = CGRectMake(25, 50*i, 100, 50);
//		[countArray addObject:[self initRumbleCountAt:r]]; 
//	}
//	robotCount = [countArray objectAtIndex:0];
//	snakeCount = [countArray objectAtIndex:1];
//	palaceCount = [countArray objectAtIndex:2];			

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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)enterRumbleWithPlayerID:(int)playerID{
	[self enterRumble];
	self.center = [GameVisual boardCenter];
	rumbleAlone = YES;
	backgroundImage.hidden = YES;
}


- (void)enterRumble{
	//Add Tokens
	self.center = [GameVisual rumbleInfoCenterForPlayerID:player.ID];
	self.autoresizingMask = [GameVisual infoResizingMaskForPlayerID:player.ID];
	
	//DebugLog(@"Center: %f, %f", self.center.x, self.center.y);
	currentPosition = CGPointMake(-RandomPositionInterval, 0);
	//add some random tokens
	for (int i=0; i<NumberOfTokenTypes; i++) {
		int amount = [player amountOfUsableResource:i];
		for (int j=0; j<amount; j++) {
			[self addRandomTokenWithType:i];
		}
	}
	
	[self validateRumbleTargetAmount];
	backgroundImage.hidden = NO;
	
}

- (void)enterRumbleAnimDidStop{
	//TODO: Calculate which one to pop, use a random one for the moment
	if (player.isHuman) {
		[self zoomOutWithAnim:NO];
	}else {
		[self activateRumbleTargetWithType:rand()%NumberOfRumbleTargetTypes];
	}

	//[self activateRumbleTargetWithType:0];
}


- (void)exitRumble{
	[self reset];
	if (rumbleAlone) {
		rumbleAlone = NO;
	}
	if (currentRumbleTarget) {
		[currentRumbleTarget removeFromSuperview];
	}
}



- (void)activateRumbleTargetWithType:(RumbleTargetType)type{
	currentRumbleTarget = [rumbleTargets objectAtIndex:type];
	//DebugLog(@"Current RumbleTarget Type: %d", currentRumbleTarget.type);

	currentRumbleTarget.center = CGPointMake(RumbleInfoWidth/2 + RumbleInfoOffset, RumbleInfoHeight/2 + RumbleInfoHeight);	
	currentRumbleTarget.alpha = 0.0;
	[self activateCurrentRumbleTarget];
}
	
- (void)activateCurrentRumbleTarget{
	[self addSubview:currentRumbleTarget];
	
	
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationDuration:SlideOutTime]; 
	currentRumbleTarget.transform = CGAffineTransformMakeScale(1,1);		
	currentRumbleTarget.center = CGPointMake(RumbleInfoWidth/2 + RumbleInfoOffset, RumbleInfoHeight/2);
	currentRumbleTarget.alpha = 1.0;	
	
	[currentRumbleTarget activate];
	for (RumbleTarget * rt in rumbleTargets) {
		if (rt != currentRumbleTarget) {
			[rt deactivate];
			rt.alpha = 0;
		}
	}
	swapInProgress = NO;
	
	[UIView commitAnimations];	

}


- (void)deactivateCurrentRumbleTarget{
	if (currentRumbleTarget) {
		[currentRumbleTarget remove];		
		[currentRumbleTarget removePopup];
	}
}


- (void)swapRumbleTarget:(BOOL)up{
	//TODO:Animation to remove the current RumbleTarget
	if (swapInProgress) {
		return;
	}
	
	[[SoundManager sharedInstance] playSoundWithTag:SoundTagPaperShort];
	
	if (currentRumbleTarget) {
		[currentRumbleTarget remove];		
		[currentRumbleTarget removePopup];
		[currentRumbleTarget removeFromSuperview];
		swapInProgress = YES;
	}
	int currentType = currentRumbleTarget.type;
	if (up) {
		currentType--;
	}else {
		currentType++;
	}

	if (currentType < 0) {
		currentType = NumberOfRumbleTargetTypes - 1;
	}else if (currentType > NumberOfRumbleTargetTypes - 1) {
		currentType = 0;
	}
	DebugLog(@"New RumbleTarget Type: %d", currentType);
	[self activateRumbleTargetWithType:currentType];
}

- (void)zoomOutWithAnim:(BOOL)withAnim{
	[self deactivateCurrentRumbleTarget];
	currentRumbleTarget = nil;
	
	[[SoundManager sharedInstance] playSoundWithTag:SoundTagPaperShort];	
	
	for (RumbleTarget * rt in rumbleTargets) {
		[rt enableSelection];
	}
	for (int i=0; i<NumberOfRumbleTargetTypes; i++) {
		RumbleTarget * rt = [rumbleTargets objectAtIndex:i];
		[self addSubview:rt];
		if (rt!=currentRumbleTarget) {
			rt.alpha = 0;
		}
		if (withAnim) {
			[UIView beginAnimations:nil context:nil]; 
			[UIView setAnimationDuration:SlideOutTime];
			rt.center = [self positionForRumbleTargetType:rt.type];
			rt.transform = CGAffineTransformMakeScale(RumbleTargetZoomOutRatio,RumbleTargetZoomOutRatio);		
			rt.alpha = 1.0;
			[UIView commitAnimations];	
		}else {
			rt.center = [self positionForRumbleTargetType:rt.type];
			rt.transform = CGAffineTransformMakeScale(RumbleTargetZoomOutRatio,RumbleTargetZoomOutRatio);		
			rt.alpha = 1.0;
		}
		
	}
	[[RumbleBoard sharedInstance] addSubview:self];

}

- (CGPoint)positionForRumbleTargetType:(RumbleTargetType)type{
	//Need to have an offset to avoid covering player1/3's position
	float avoidanceOffset = 0;
	if (player.ID == 0||player.ID == 2) {
		avoidanceOffset = -60;
	}
	
	CGPoint bottomCenter = CGPointMake(RumbleInfoWidth/2, RumbleInfoHeight);
	int numberOfColumns = ceil(NumberOfRumbleTargetTypes/RumbleTargetZoomOutRows);
	float totalWidth = numberOfColumns
	* (RumbleTargetWidth*RumbleTargetZoomOutRatio + RumbleTargetZoomOutInverval)
	+ RumbleTargetZoomOutInverval;
	float totalHeight = RumbleTargetZoomOutRows
	* (RumbleTargetHeight*RumbleTargetZoomOutRatio + RumbleTargetZoomOutInverval)
	+ RumbleTargetZoomOutInverval;
	
	CGPoint startingPosition = CGPointMake(bottomCenter.x - totalWidth/2, bottomCenter.y - totalHeight);
	int row = floor(type/numberOfColumns);
	int column = type%numberOfColumns;
	
	return CGPointMake(avoidanceOffset + startingPosition.x
					   + column * (RumbleTargetWidth*RumbleTargetZoomOutRatio + RumbleTargetZoomOutInverval)
					   + RumbleTargetZoomOutInverval + RumbleTargetWidth*RumbleTargetZoomOutRatio/2,
					   startingPosition.y 
					   + row * (RumbleTargetHeight*RumbleTargetZoomOutRatio + RumbleTargetZoomOutInverval)
					   + RumbleTargetZoomOutInverval + RumbleTargetHeight*RumbleTargetZoomOutRatio/2);
}

- (void)selectRumbleTarget:(RumbleTarget *)rt{
	[[SoundManager sharedInstance] playSoundWithTag:SoundTagPaperShort];	
	currentRumbleTarget = rt;
	[self activateCurrentRumbleTarget];
	[[RumbleBoard sharedInstance].rumbleView addSubview:self];

}


- (void)addRandomTokenWithType:(TokenType)type{
	Token * t = [Token tokenWithType:type 
						 andPosition:[self nextPosition]
				 ];
	t.player = self.player;
	t.transform = self.transform;
	[[RumbleBoard sharedInstance] addRumbleToken:t];
	[gameLogic.rumbleTokens addObject:t];
}

- (void)update{

}


- (CGPoint)nextPosition{
	CGPoint n;
	if (currentPosition.x + RandomPositionInterval * 2 <= RandomPositionBoundWidth) {
		currentPosition = CGPointMake(currentPosition.x + RandomPositionInterval, currentPosition.y);
	}else {
		currentPosition = CGPointMake(0, currentPosition.y+RandomPositionInterval);
	}
	n = CGPointMake(currentPosition.x + TokenSize, currentPosition.y + TokenSize);
	return 	[self convertPoint:n toView:self.superview];
}


- (void)validateRumbleTargetAmount{
	AmountContainer * currentAmount = [AmountContainer emptyAmountContainer];

	for (Token * t in gameLogic.rumbleTokens) {
		if (t.shared || t.player == self.player) {
			[currentAmount modifyAmountForIndex:t.type by:1];
		}
	}
	
	for (RumbleTarget * rt in rumbleTargets) {
		if ([currentAmount greaterOrEqualThan:[rt tokenAmount]]) {
			rt.isAvailable = YES;
		}else {
			rt.isAvailable = NO;
		}
	}	
}


- (void)reset{
	for (RumbleTarget * rt in rumbleTargets) {
		[rt reset];
	}
}

- (void)dealloc {
	[rumbleTargets release];
    [super dealloc];
}



@end

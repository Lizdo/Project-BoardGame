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

@end

@implementation RumbleInfo

@synthesize player, currentRumbleTarget;

- (void)setPlayer:(Player *)newPlayer{
	player = newPlayer;
	//self.backgroundColor = [GameVisual colorForPlayerID:player.ID];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		//self.backgroundColor = [UIColor blueColor];
		gameLogic = [GameLogic sharedInstance];
		rumbleTargets = [[NSMutableArray arrayWithCapacity:0]retain];
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
	UIImageView * icon = [[UIImageView alloc] initWithImage:[GameVisual imageForRumbleType:type andPlayerID:player.ID]];
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
	count.textColor = [GameVisual colorWithHex:0x585858];
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
	
}

- (void)enterRumbleAnimDidStop{
	//TODO: Calculate which one to pop, use a random one for the moment
	[self activateRumbleTargetWithType:rand()%3];
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

	currentRumbleTarget.center = CGPointMake(RumbleInfoWidth/2, RumbleInfoHeight/2 + RumbleInfoHeight);	
	currentRumbleTarget.alpha = 0.0;
	[self addSubview:currentRumbleTarget];
	
	
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationDuration:SlideOutTime]; 
	currentRumbleTarget.center = CGPointMake(RumbleInfoWidth/2, RumbleInfoHeight/2);
	currentRumbleTarget.alpha = 1.0;	
	[UIView commitAnimations];	
	
	[currentRumbleTarget activate];
	swapInProgress = NO;
}


- (void)swapRumbleTarget:(BOOL)up{
	//TODO:Animation to remove the current RumbleTarget
	if (swapInProgress) {
		return;
	}
	if (currentRumbleTarget) {
		[currentRumbleTarget remove];		
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
		currentType = 2;
	}else if (currentType > 2) {
		currentType = 0;
	}
	DebugLog(@"New RumbleTarget Type: %d", currentType);
	[self activateRumbleTargetWithType:currentType];
}


- (void)addRandomTokenWithType:(TokenType)type{
	Token * t = [Token tokenWithType:type 
						 andPosition:[self nextPosition]
				 ];
	t.player = self.player;
	t.transform = self.transform;
	[self.superview addSubview:t];
	[gameLogic.rumbleTokens addObject:t];
}

- (void)update{

}


- (CGPoint)nextPosition{
	CGPoint n;
	if (currentPosition.x + RandomPositionInterval <= RandomPositionBoundWidth) {
		currentPosition = CGPointMake(currentPosition.x + RandomPositionInterval, currentPosition.y);
	}else {
		currentPosition = CGPointMake(0, currentPosition.y+RandomPositionInterval);
	}
	n = CGPointMake(currentPosition.x + TokenSize, currentPosition.y + TokenSize);
	return 	[self convertPoint:n toView:self.superview];
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

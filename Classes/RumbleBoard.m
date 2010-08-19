//
//  RumbleBoard.m
//  BoardGame
//
//  Created by Liz on 10-5-12.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "RumbleBoard.h"
#import "GameLogic.h"

@interface RumbleBoard (Private)

- (void)initRandomPositions;
- (CGPoint)randomPosition;
- (BOOL)seedUsed:(int)seed;

@end


@implementation RumbleBoard


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		gameLogic = [GameLogic sharedInstance];
		self.backgroundColor = [GameVisual boardBackgroundColor];
		
		
		int countDownSize = 500;
		CGRect r = CGRectMake((self.bounds.size.width - countDownSize) /2, 
							  (self.bounds.size.height - countDownSize) /2, 
							  countDownSize,
							  countDownSize);
		countDown = [[UILabel alloc] initWithFrame:r];
		countDown.opaque = NO;
		countDown.backgroundColor = nil;
		countDown.font = [UIFont fontWithName:PrimaryFontName size:150];
		countDown.textColor = [GameVisual colorWithHex:0x585858];
		countDown.textAlignment = UITextAlignmentCenter;
		countDown.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		
		countDown.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin
		|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
		
    }
    return self;
}

- (void)initGame{	
	rumbleInfos = [[NSMutableArray arrayWithCapacity:0]retain];
	for (int i=0; i<4; i++) {
		RumbleInfo * rumbleInfo = [[RumbleInfo alloc] initWithFrame:CGRectMake(0, 0, 568, 200)];
		[gameLogic.rumbleInfos addObject:rumbleInfo];
		rumbleInfo.player = [gameLogic playerWithID:i];
		CGAffineTransform t = rumbleInfo.transform;
		rumbleInfo.transform = CGAffineTransformRotate(t,90*i*PI/180);
		
		rumbleInfo.center = [GameVisual infoCenterForPlayerID:i];
		rumbleInfo.autoresizingMask = [GameVisual infoResizingMaskForPlayerID:i];		
	
		
		[self insertSubview:rumbleInfo atIndex:0];
		[rumbleInfos addObject:rumbleInfo];
		[rumbleInfo release];
		[rumbleInfo initGame];
	}
	
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)enterRumble{
	rumble = gameLogic.rumble;
	countDown.center = self.center;
	[self insertSubview:countDown atIndex:0];
}


- (void)exitRumble{
	for (RumbleInfo * info in rumbleInfos){
		[info exitRumble];
	}	
}

- (void)allRumble{
	allRumble = YES;
	for (RumbleInfo * info in rumbleInfos){
		[self addSubview:info];
		[info enterRumble];
	}
	[self addSharedTokens];	
}

- (void)rumbleWithPlayerID:(int)playerID{
	allRumble = NO;
	rumbleID = playerID;
	for (RumbleInfo * info in rumbleInfos){
		if (info.player.ID != playerID) {
			[info removeFromSuperview];
		}else {
			[self addSubview:info];
			[info enterRumbleWithPlayerID:playerID];
		}

	}
	[self addSharedTokens];
}

- (void)enterRumbleAnimDidStop{
	for (RumbleInfo * info in rumbleInfos){
		if (allRumble) {
			[info enterRumbleAnimDidStop];
		}else if (rumbleID == info.player.ID) {
			[info enterRumbleAnimDidStop];
		}
	}
}


- (void)addSharedTokens{
	
	for (int i=0; i<RBRandomSeedsNeeded; i++) {
		randomSeedUsed[i] = 0;
	}
	randomSeedIndex = 0;
	
	//add some random tokens	
	randomTokenRect = CGRectMake(264, 318, 240, 378);
	//rect = [self convertRect:rect toView:self.superview];
	[self initRandomPositions];

	
	for (int i=0; i<10; i++) {
		Token * t = [Token tokenWithType:[gameLogic randomTokenType] 
							 andPosition:[self randomPosition]
					 ];
		t.shared = YES;
		//[gameLogic.rumbleBoard addSubview:t];
		[self addSubview:t];
		[gameLogic.rumbleTokens addObject:t];
	}
}

- (BOOL)seedUsed:(int)seed{
	for (int i =0; i<RBRandomSeedsNeeded; i++) {
		if(randomSeedUsed[i] == seed)
			return YES;
	}
	return NO;
}

- (void)initRandomPositions{	
	for (int i = 0; i<RBRandomSlices*RBRandomSlices; i++) {
		randomPositions[i*2] = randomTokenRect.origin.x + floor(i/RBRandomSlices) * randomTokenRect.size.width/RBRandomSlices
		+ rand()%RBRandomSlices - RBRandomSlices/2;
		randomPositions[i*2+1] = randomTokenRect.origin.y + i%RBRandomSlices * randomTokenRect.size.height/RBRandomSlices
		+ rand()%RBRandomSlices - RBRandomSlices/2;
	}
}

- (CGPoint)randomPosition{
	int randomNumber;
	do{
		randomNumber = rand()%(RBRandomSlices*RBRandomSlices);
	}while ([self seedUsed:randomNumber]);
	randomSeedUsed[randomSeedIndex] = randomNumber;
	randomSeedIndex++;
	return [gameLogic convertedPoint:CGPointMake(randomPositions[randomNumber*2], randomPositions[randomNumber*2+1])];
}



- (void)update{
	countDown.text = [NSString stringWithFormat:@"%1.0f",[rumble timeRemaining]];
	for (RumbleInfo * info in rumbleInfos){
		[info update];
	}
}

- (void)dealloc {
	[rumbleInfos release];
    [super dealloc];
}


@end

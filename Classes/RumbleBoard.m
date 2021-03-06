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

@synthesize sharedTokenAmount,rumbleView;

static RumbleBoard *sharedInstance = nil;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		
		sharedInstance = self;
		
		gameLogic = [GameLogic sharedInstance];
		self.backgroundColor = [GameVisual rumbleBoardBackgroundImage];
		
		
		int countDownSize = 500;
		CGRect r = CGRectMake((self.bounds.size.width - countDownSize) /2, 
							  (self.bounds.size.height - countDownSize) /2, 
							  countDownSize,
							  countDownSize);
		countDown = [[UILabel alloc] initWithFrame:r];
		countDown.opaque = NO;
		countDown.backgroundColor = nil;
		countDown.font = [UIFont fontWithName:SecondaryFontName size:150];
		countDown.textColor = SecondaryColor;
		countDown.textAlignment = UITextAlignmentCenter;
		countDown.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		countDown.shadowColor = LightColor;
		countDown.shadowOffset = CGSizeMake(1, 1);
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		
		countDown.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin
		|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
		
		self.clipsToBounds = YES;

		self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;	
		
		rumbleView = [[ContainerView alloc]initWithFrame:self.bounds];
		rumbleView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;		
		[self addSubview:rumbleView];
		
		tokenView = [[ContainerView alloc]initWithFrame:self.bounds];
		tokenView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;		
		[self addSubview:tokenView];		
		
		popupView = [[ContainerView alloc]initWithFrame:self.bounds];
		popupView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;		
		[self addSubview:popupView];
    }
    return self;
}

- (void)initGame{	
	rumbleInfos = [[NSMutableArray arrayWithCapacity:0]retain];
	for (int i=0; i<[Game TotalNumberOfPlayers]; i++) {
		RumbleInfo * rumbleInfo = [[RumbleInfo alloc] initWithFrame:CGRectMake(0, 0, RumbleInfoWidth, RumbleInfoHeight)];
		[gameLogic.rumbleInfos addObject:rumbleInfo];
		rumbleInfo.player = [gameLogic playerWithID:i];

		rumbleInfo.transform = [GameVisual transformForPlayerID:i];
		rumbleInfo.center = [GameVisual rumbleInfoCenterForPlayerID:i];
		rumbleInfo.autoresizingMask = [GameVisual infoResizingMaskForPlayerID:i];		
	
		
		[rumbleView insertSubview:rumbleInfo atIndex:0];
		[rumbleInfos addObject:rumbleInfo];
		[rumbleInfo release];
		[rumbleInfo initGame];
	}
	rumble = [Rumble sharedInstance];
	
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)enterRumble{
	countDown.text = @"";
}


- (void)exitRumble{
	for (RumbleInfo * info in rumbleInfos){
		[info exitRumble];
	}
}

- (void)allRumble{
	allRumble = YES;
	[self addSharedTokens];		
	for (RumbleInfo * info in rumbleInfos){
		[rumbleView addSubview:info];
		[info enterRumble];
	}
}

- (void)rumbleWithPlayerID:(int)playerID{
	allRumble = NO;
	rumbleID = playerID;
	self.sharedTokenAmount = [AmountContainer emptyAmountContainer];	
	for (RumbleInfo * info in rumbleInfos){
		if (info.player.ID != playerID) {
			[info removeFromSuperview];
		}else {
			[rumbleView addSubview:info];
			[info enterRumbleWithPlayerID:playerID];
		}

	}
	//Don't add shared token for builds
	//[self addSharedTokens];
}

- (void)enterRumbleAnimDidStop{
	[gameLogic enterRumbleAnimDidStop];
	for (RumbleInfo * info in rumbleInfos){
		if (allRumble) {
			[info enterRumbleAnimDidStop];
		}else if (rumbleID == info.player.ID) {
			[info enterRumbleAnimDidStop];
		}
	}
	
    if(allRumble){
        countDown.center = self.center;
		countDown.transform = [GameVisual transformForPlayerID:0];
    }
    else{
        countDown.center = CGPointMake(self.center.x, self.center.y + 200);
		countDown.transform = [GameVisual transformForPlayerID:rumbleID];		
    }
	[self insertSubview:countDown atIndex:0];
	[self update];
}


- (void)exitRumbleAnimDidStop{
	[gameLogic exitRumbleAnimDidStop];
}

- (void)addSharedTokens{	
	for (int i=0; i<RBRandomSeedsNeeded; i++) {
		randomSeedUsed[i] = 0;
	}
	randomSeedIndex = 0;
	
	self.sharedTokenAmount = [AmountContainer emptyAmountContainer];	
	
	//add some random tokens	
	randomTokenRect = CGRectMake(264, 318, 240, 378);
	//rect = [self convertRect:rect toView:self.superview];
	[self initRandomPositions];

	int randomTokensToGenerate = [gameLogic numberOfSharedTokens];
	
	for (int i=0; i<randomTokensToGenerate; i++) {
		Token * t = [Token tokenWithType:[gameLogic randomTokenType] 
							 andPosition:[self randomPosition]
					 ];
		t.shared = YES;
		//[gameLogic.rumbleBoard addSubview:t];
		[self addRumbleToken:t];
		[gameLogic.rumbleTokens addObject:t];
		[sharedTokenAmount modifyAmountForIndex:t.type by:1];
	}
}

- (void)addRumbleToken:(Token *)t{
	[tokenView addSubview:t];
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


- (void)validateRumbleTargetAmount{
	for (RumbleInfo * ri in rumbleInfos) {
		[ri validateRumbleTargetAmount];
	}
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

- (void)reset{
	sharedInstance = nil;
	[self dealloc];
}

- (void)dealloc {
	[rumbleInfos release];
    [super dealloc];
}

#pragma mark -
#pragma mark Singleton methods

+ (RumbleBoard*)sharedInstance
{
	NSAssert(sharedInstance != nil, @"RumbleBoard need to initialize with initWithFrame:");
//    @synchronized(self)
//    {
//        if (sharedInstance == nil)
//			sharedInstance = [[RumbleBoard alloc] init];
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

//
//  RumbleTarget.m
//  BoardGame
//
//  Created by Liz on 10-5-14.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "RumbleTarget.h"
#import "RumbleInfo.h"

#import "Player.h"
#import "Board.h"
#import "Project.h"
#import "SoundManager.h"


@interface RumbleTarget (Private) 
- (void)Token:(Token *)t droppedAtPosition:(CGPoint)p;
- (void)Token:(Token *)t pickedUpFromPosition:(CGPoint)p;
- (void)Token:(Token *)t hoveringAtPosition:(CGPoint)p;
- (void)handleSwipe:(UISwipeGestureRecognizer *)sender;
- (void)handlePinch:(UIPinchGestureRecognizer *)sender;
- (void)handleTap:(UITapGestureRecognizer *)sender;

@end

@implementation RumbleTarget

@synthesize player,type,tokenPlaceholders,info,isAvailable;

float distance(CGPoint p1, CGPoint p2){
	return pow((p1.x - p2.x),2) + pow((p1.y - p2.y),2); 
}

- (void)setIsAvailable:(BOOL)b{
	isAvailable = b;
	[self setNeedsDisplay];
}

- (void)setType:(RumbleTargetType)t{
	type = t;
	nameLabel.text = [self title];
	timeLabel.text = [NSString stringWithFormat:@"%dWeeks",[Project timeNeededForRumbleTargetType:type]];
	scoreLabel.text = [NSString stringWithFormat:@"%d",RumbleTargetScoreModifier[t]];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		allMatched = NO;
		self.backgroundColor = [UIColor clearColor];//[GameVisual boardBackgroundColor];
		
		recognizerUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
		[self addGestureRecognizer:recognizerUp];
		recognizerUp.direction = UISwipeGestureRecognizerDirectionUp;
		
		recognizerDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
		[self addGestureRecognizer:recognizerDown];
		recognizerDown.direction = UISwipeGestureRecognizerDirectionDown;
		
		recognizerPinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)]; 
		[self addGestureRecognizer:recognizerPinch];
		
		recognizerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]; 
		[self addGestureRecognizer:recognizerTap];

		scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, frame.size.width-20, 110)];
		scoreLabel.font = [UIFont fontWithName:PrimaryFontName size:100];
		scoreLabel.opaque = NO;
		scoreLabel.backgroundColor = nil;
		scoreLabel.textAlignment = UITextAlignmentRight;
		scoreLabel.textColor = [GameVisual colorWithHex:0xCCCCCC];
		scoreLabel.adjustsFontSizeToFitWidth = YES;
		[self addSubview:scoreLabel];			
		
		nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, frame.size.height-60, frame.size.width-20, 50)];
		nameLabel.font = [UIFont fontWithName:PrimaryFontName size:28];
		nameLabel.opaque = NO;
		nameLabel.backgroundColor = nil;
		nameLabel.textAlignment = UITextAlignmentCenter;
		nameLabel.textColor = [GameVisual colorWithHex:0x585858];
		nameLabel.adjustsFontSizeToFitWidth = YES;
		[self addSubview:nameLabel];	
		
		timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, frame.size.width-10, 30)];
		timeLabel.font = [UIFont fontWithName:PrimaryFontName size:20];
		timeLabel.opaque = NO;
		timeLabel.backgroundColor = nil;
		timeLabel.textAlignment = UITextAlignmentLeft;
		timeLabel.textColor = [GameVisual colorWithHex:0x585858];
		[self addSubview:timeLabel];
		
		
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
	CGRect r = self.bounds;
	UIImage * uiImage = [GameVisual imageForRumbleTarget:isAvailable];
	if (uiImage != nil) {
		CGImageRef image = uiImage.CGImage;
		CGContextRef c = UIGraphicsGetCurrentContext();
		CGContextDrawImageInverted(c,r,image);		
	}
}

- (void)activate{
	recognizerTap.enabled = NO;	
	recognizerUp.enabled = YES;	
	recognizerDown.enabled = YES;
	recognizerPinch.enabled = YES;
}


- (void)deactivate{
	recognizerUp.enabled = NO;	
	recognizerDown.enabled = NO;
	recognizerPinch.enabled = NO;
	recognizerTap.enabled = NO;
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)sender{
	if (!sender.enabled) {
		return;
	}
	recognizerUp.enabled = NO;	
	recognizerDown.enabled = NO;
	if (sender.direction == UISwipeGestureRecognizerDirectionUp) {
		[info swapRumbleTarget:YES];
	}else {
		[info swapRumbleTarget:NO];
	}

}

- (void)handlePinch:(UIPinchGestureRecognizer *)sender{
	recognizerUp.enabled = NO;	
	recognizerDown.enabled = NO;
	recognizerPinch.enabled = NO;
	[info zoomOutWithAnim:YES];
}

- (void)handleTap:(UITapGestureRecognizer *)sender{
	[info selectRumbleTarget:self];
}



- (void)enableSelection{
	recognizerTap.enabled = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


//Must follow the order defined in RumbleTargetType
static int rumbleInfo[NumberOfRumbleTargetTypes*10][4] = {
	
	//Flash
	{TokenTypeRect,  88, 110,   0},
	{TokenTypeRound,  72,  68,   0},
	{TokenTypeRect,  56, 110,   0},
	
	{-1,0,0,0},
	{-1,0,0,0},
	{-1,0,0,0},	
	{-1,0,0,0},
	{-1,0,0,0},
	{-1,0,0,0},
	{-1,0,0,0},
	
	
	//XBLA
	{TokenTypeRect,  72,  90,  90},
	{TokenTypeSquare,  58,  66,   0},
	{TokenTypeRound,  48, 122,   0},
	{TokenTypeRound,  96, 122,   0},
	
	{-1,0,0,0},
	{-1,0,0,0},
	{-1,0,0,0},	
	{-1,0,0,0},
	{-1,0,0,0},
	{-1,0,0,0},
	
	
	//Snake
	{TokenTypeRound, 108,  26,   0},
	{TokenTypeRect, 116,  64, -12},
	{TokenTypeRound,  52, 138,   0},
	{TokenTypeRect,  70,  38,  70},
	{TokenTypeRound,  34,  50,   0},
	{TokenTypeRound, 124, 102,   0},
	{TokenTypeRect,  88, 120,  60},
	
	{-1,0,0,0},
	{-1,0,0,0},
	{-1,0,0,0},	
	
	//Robot
	{TokenTypeSquare,  76,  76,   0},
	{TokenTypeRect,  58, 116,   0},
	{TokenTypeRound,  76,  32,   0},
	{TokenTypeRect,  92, 116,   0},
	{TokenTypeRect, 112,  82, -30},
	{TokenTypeRect,  40,  82,  30},	
	
	{-1,0,0,0},
	{-1,0,0,0},
	{-1,0,0,0},
	{-1,0,0,0},

	
	//Palace
	{TokenTypeRect,  32, 117,   0},
	{TokenTypeSquare,  75,  79,   0},
	{TokenTypeRect,  46,  72,   0},
	{TokenTypeSquare,  58, 121,   0},
	{TokenTypeRound,  75,  35,   0},
	{TokenTypeRect, 102,  75,   0},
	{TokenTypeRect, 120, 118,   0},
	{TokenTypeSquare,  92, 122,   0},
	
	{-1,0,0,0},
	{-1,0,0,0},

	
	//FPS
	{TokenTypeSquare,  70,  72,   0},
	{TokenTypeRound,  44, 128,   0},
	{TokenTypeRect,  96,  98, -90},
	{TokenTypeRound,  98, 130,   0},
	{TokenTypeSquare, 104,  72,   0},
	{TokenTypeRect,  44,  98,  90},
	{TokenTypeSquare,  38,  70,   0},
	{TokenTypeSquare,  51,  42,   0},
	
	{-1,0,0,0},
	{-1,0,0,0},
	
	
};



+ (RumbleTarget *)rumbleTargetWithType:(RumbleTargetType)aType{
	CGRect r = CGRectMake(0, 0, RumbleTargetWidth, RumbleTargetHeight);
	RumbleTarget * t = [[RumbleTarget alloc]initWithFrame:r];
	t.type = aType;
	int startingIndex = aType*10;
	t.tokenPlaceholders = [NSMutableArray arrayWithCapacity:0];
	for (int i=0; i<10; i++) {
		if (rumbleInfo[startingIndex + i][0] != -1) {
			int * info = rumbleInfo[startingIndex + i];
			[t addTokenPlaceholderWithInfo:info];
		}else{
			break;
		}
	}
	return [t autorelease];
}

// info:
//  [Type, x, y, rotation]
- (void)addTokenPlaceholderWithInfo:(int *)newInfo{
	TokenPlaceholder * token = [TokenPlaceholder tokenPlaceholderWithType:newInfo[0] 
											   andPosition:CGPointMake(newInfo[1] + 25, newInfo[2] + 40)]; 
	//Offset because InfoSize - RTSize = 50
	CGAffineTransform t = token.transform;
	token.transform = CGAffineTransformRotate(t, newInfo[3]* PI/180);
	token.player = player;
	[self addSubview:token];
	[self.tokenPlaceholders addObject:token];
}

- (void)triggerEvent:(TokenEvent)e withToken:(Token *)t atPosition:(CGPoint)p{
	switch (e) {
		case TokenEventDroppedDown:
			[self Token:t droppedAtPosition:p];
			break;
		case TokenEventPickedUp:
			[self Token:t pickedUpFromPosition:p];
			break;
		case TokenEventHover:
			[self Token:t hoveringAtPosition:p];
			break;			
		default:
			break;
	}
}



//Position check should be done in GameLogic
static const int DistanceTolerance = 30;

- (void)Token:(Token *)t droppedAtPosition:(CGPoint)p{
	//p = [self convertPoint:p fromView:self.superview];
	for (TokenPlaceholder * placeholder in tokenPlaceholders) {
		if (!placeholder.hasMatch 
			&& placeholder.type == t.type
			&& distance(p, placeholder.center) <= DistanceTolerance * DistanceTolerance) {
			placeholder.hasMatch = YES;
			placeholder.matchedToken = t;
			[self insertSubview:placeholder atIndex:0];
			t.center = [self convertPoint:placeholder.center toView:self.superview.superview];
			t.transform = CGAffineTransformConcat(self.superview.transform, placeholder.transform);
			//Change the draw order to avoid mistakes
			//[t.superview insertSubview:t aboveSubview:self];
			[self updateAllMatchedStatus];			
			return;
		}
	}
	[self updateAllMatchedStatus];
}


- (void)Token:(Token *)t pickedUpFromPosition:(CGPoint)p{
	for (TokenPlaceholder * placeholder in tokenPlaceholders) {
		if (placeholder.matchedToken == t) {
			placeholder.hasMatch = NO;
			placeholder.matchedToken = nil;
			[self updateAllMatchedStatus];			
			return;
		}
	}
	[self updateAllMatchedStatus];
}

- (void)Token:(Token *)t hoveringAtPosition:(CGPoint)p{
	// Change the color?
//	for (TokenPlaceholder * placeholder in tokenPlaceholders) {
//		if (placeholder.matchedToken == t) {
//			placeholder.hasMatch = NO;
//			placeholder.matchedToken = nil;
//			return;
//		}
//	}	
}

- (CGPoint)emptyPointForToken:(Token *)t{
	for (TokenPlaceholder * placeholder in tokenPlaceholders) {
		if (!placeholder.hasMatch && placeholder.type == t.type){
			CGPoint point = [self convertPoint:placeholder.center toView:(UIView *)[RumbleBoard sharedInstance]];
			DebugLog(@"Original Point: %f, %f\nConverted Point: %f, %f", 
					 placeholder.center.x, placeholder.center.y, point.x, point.y);
			return point;
		}
	}
	return CGPointZero;
}


- (void)updateAllMatchedStatus{
	for (TokenPlaceholder * placeholder in tokenPlaceholders) {
		if (!placeholder.hasMatch) {
			allMatched = NO;
			//self.backgroundColor = nil;
			//DebugLog(@"Not All Matched");
			return;
		}
	}
	
	//allMatched = YES;
	//self.backgroundColor = [GameVisual rumbleTargetBackgroundColor];
	DebugLog(@"All Matched");
	
	
	[[SoundManager sharedInstance] playSoundWithTag:SoundTagCoin];
	
	//[Badge]: First Builder
	[player addBadgeWithType:BadgeTypeFirstBuilder];
	
	//Add project here
	Project * p = [[[Project alloc] initWithRumbleTarget:self]autorelease];
	[player addProject:p];
	
	[self reset];
	
	[[RumbleBoard sharedInstance]validateRumbleTargetAmount];

	
}



- (void)reset{
	//TODO:animation to fly out, then switch in new rumbletarget
	for (TokenPlaceholder * placeholder in tokenPlaceholders) {
		[placeholder reset];
	}
	[self updateAllMatchedStatus];
}

- (void)remove{
	//TODO: reset self, move all matched tokens to a random position in user's area
	for (TokenPlaceholder * placeholder in tokenPlaceholders) {
		[placeholder remove];
	}
	[self updateAllMatchedStatus];
}

- (NSString *)title{
	switch (type) {
		case RumbleTargetTypeSignal:
			return @"Let's Count 123";
			break;
		case RumbleTargetTypeCart:
			return @"We Race";
			break;
		case RumbleTargetTypeTank:
			return @"Meat Grinder";
			break;				
		case RumbleTargetTypeRobot:
			return @"Little World";
			break;
		case RumbleTargetTypeSnake:
			return @"H.P. 2";
			break;
		case RumbleTargetTypePalace:
			return @"Theme Prison";
			break;			
		default:
			return @"";
			break;
	}
}



- (NSString *)description{
	switch (type) {
		case RumbleTargetTypeSignal:
			return @"Web-based educational minigame. Small yet beautiful.";
			break;
		case RumbleTargetTypeCart:
			return @"Bring racing to the popular social networks.";
			break;
		case RumbleTargetTypeTank:
			return @"Blood & Gore bring you to the WW2.";
			break;				
		case RumbleTargetTypeRobot:
			return @"Fantasy world city simulation.";
			break;
		case RumbleTargetTypeSnake:
			return @"Sequel to the successful HP1 series.";
			break;
		case RumbleTargetTypePalace:
			return @"You are the boss. 1st ever prison simulation game.";
			break;			
		default:
			return @"";
			break;
	}	
}


+ (NSString *)resourceDescriptionForRumbleTargetType:(RumbleTargetType)aType{
	AmountContainer * ac = [AmountContainer emptyAmountContainer];
	for (int i = aType*10; i < (aType+1)*10; i++){
		if (rumbleInfo[i][0] >= 0 && rumbleInfo[i][0] < NumberOfTokenTypes) {
			[ac modifyAmountForIndex:rumbleInfo[i][0] by:1];
		}
	}
	
	NSString * s = @"";
	
	for (int i = 0; i < NumberOfTokenTypes; i++) {
		s = [s stringByAppendingFormat:@"%@ x %d ", 
			 [GameLogic descriptionForResourceType:i],
			 [ac amountForIndex:i]];
	}
	return s;
}


- (AmountContainer *)tokenAmount{
	AmountContainer * ac = [AmountContainer emptyAmountContainer];
	for (Token * t in tokenPlaceholders) {
		[ac modifyAmountForIndex:t.type by:1];
	}
	return ac;
}

- (void)dealloc{
	[recognizerUp release];
	[recognizerDown release];
	[self.tokenPlaceholders removeAllObjects];
	self.tokenPlaceholders = nil;
	[super dealloc];
}

@end

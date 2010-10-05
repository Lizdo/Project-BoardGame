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


@interface RumbleTarget (Private) 
- (void)Token:(Token *)t droppedAtPosition:(CGPoint)p;
- (void)Token:(Token *)t pickedUpFromPosition:(CGPoint)p;
- (void)Token:(Token *)t hoveringAtPosition:(CGPoint)p;
- (void)handleSwipe:(UISwipeGestureRecognizer *)sender;

@end

@implementation RumbleTarget

@synthesize player,type,tokenPlaceholders,info;

float distance(CGPoint p1, CGPoint p2){
	return pow((p1.x - p2.x),2) + pow((p1.y - p2.y),2); 
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
		
		nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-60, frame.size.width, 50)];
		nameLabel.font = [UIFont fontWithName:PrimaryFontName size:30];
		nameLabel.opaque = NO;
		nameLabel.backgroundColor = nil;
		nameLabel.textAlignment = UITextAlignmentCenter;
		nameLabel.textColor = [GameVisual colorWithHex:0x585858];
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
	UIImage * uiImage = [GameVisual imageForRumbleTarget];
	if (uiImage != nil) {
		CGImageRef image = uiImage.CGImage;
		CGContextRef c = UIGraphicsGetCurrentContext();
		CGContextDrawImageInverted(c,r,image);		
	}
}

- (void)activate{
	nameLabel.text = [self title];
	timeLabel.text = [NSString stringWithFormat:@"%dWeeks",[Project timeNeededForRumbleTargetType:type]];
	recognizerUp.enabled = YES;	
	recognizerDown.enabled = YES;
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


//Must follow the order defined in RumbleTargetType
static int rumbleInfo[30][4] = {
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
	
	//Add project here
	Project * p = [[Project alloc] initWithRumbleTarget:self];
	[player addProject:p];
	
	[self reset];
	
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
		case RumbleTargetTypeRobot:
			return @"Roboty";
			break;
		case RumbleTargetTypeSnake:
			return @"Sporty";
			break;
		case RumbleTargetTypePalace:
			return @"RPGee";
			break;			
		default:
			return @"";
			break;
	}
}



- (NSString *)description{
	switch (type) {
		case RumbleTargetTypeRobot:
			return @"Awesome shooter designer for the casual market. Quick and easy.";
			break;
		case RumbleTargetTypeSnake:
			return @"Remake of the original 90 series.";
			break;
		case RumbleTargetTypePalace:
			return @"Long term project that will change the way we know today about gaming, forever.";
			break;			
		default:
			return @"";
			break;
	}	
}

- (void)dealloc{
	[recognizerUp release];
	[recognizerDown release];
	[self.tokenPlaceholders removeAllObjects];
	self.tokenPlaceholders = nil;
	[super dealloc];
}

@end

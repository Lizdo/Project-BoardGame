//
//  Info.m
//  BoardGame
//
//  Created by Liz on 10-5-1.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "Info.h"
#import "GameLogic.h"


@interface Info (Private)

- (UIImageView *)initRumbleIconAt:(CGPoint)p withType:(RumbleTargetType)type;
- (UILabel *)initRumbleCountAt:(CGRect)r;

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

        endTurnButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
		[self addSubview:endTurnButton];
		//endTurnButton.center = CGPointMake(100,100);
		[endTurnButton setImage:[UIImage imageNamed:@"EndTurn.png"] forState:UIControlStateNormal];
        
        endTurnButton.frame = CGRectMake(390, 70, 100, 100);		
		[endTurnButton addTarget:self action:@selector(endTurnButtonClicked) forControlEvents:UIControlEventTouchUpInside];
		
		toggleAIButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
		[self addSubview:toggleAIButton];
		toggleAIButton.frame = CGRectMake(470, 150, 100, 50);
		[toggleAIButton addTarget:self action:@selector(toggleAIButtonClicked) forControlEvents:UIControlEventTouchUpInside];
		
        currentPlayerMark = [[UIImageView alloc] init];
        [self addSubview:currentPlayerMark];
        [currentPlayerMark setImage:[UIImage imageNamed:@"CurrentProducer.png"]];
        currentPlayerMark.frame = CGRectMake(300, 30, 50, 50);
        currentPlayerMark.hidden = YES;
		
		rvc = [[RuleViewController alloc] initWithNibName:@"RuleView" bundle:nil];
		[self addSubview:rvc.view];
		rvc.view.center = CGPointMake(rvc.view.center.x, rvc.view.center.y);
		((NoteView *)rvc.view).hasSlidedOut = NO;		
		
		svc = [[ScoreViewController alloc] initWithNibName:@"ScoreView" bundle:nil];
		[self addSubview:svc.view];
		svc.view.center = CGPointMake(svc.view.center.x + 80, svc.view.center.y);
		((NoteView *)svc.view).hasSlidedOut = NO;		
		
		self.clipsToBounds = YES;


	}
    return self;
}

- (void)initGame{
	[self setToggleAIButtonImage];
	self.allowEndTurn = NO;
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
	CGContextRef c = UIGraphicsGetCurrentContext();
	int startingOffsetX = 300;
	int startingOffsetY = 55;
	int lineSpace = 40;
	int tokenSize = 40;
	int margin = 10;
	
	CGContextSaveGState(c);
	CGContextScaleCTM(c, 1, -1);
	
	
	//Symbol
	CGRect r = CGRectMake(startingOffsetX, -startingOffsetY, tokenSize, -tokenSize);
	CGImageRef image = [GameVisual imageForResourceType:ResourceTypeRound].CGImage;
	CGContextDrawImage(c,r,image);

	//Symbol
	r = CGRectMake(startingOffsetX, -(startingOffsetY+lineSpace), tokenSize, -tokenSize);
	image = [GameVisual imageForResourceType:ResourceTypeRect].CGImage;
	CGContextDrawImage(c,r,image);
	
	//Symbol
	r = CGRectMake(startingOffsetX, -(startingOffsetY+lineSpace*2), tokenSize, -tokenSize);
	image = [GameVisual imageForResourceType:ResourceTypeSquare].CGImage;
	CGContextDrawImage(c,r,image);	
	
	CGContextRestoreGState(c);
	
	CGContextSetFillColorWithColor(c, [UIColor grayColor].CGColor);

	//x
	char buffer[50] = "x";
	CGContextSelectFont(c, PrimaryFont, 30.0, kCGEncodingMacRoman);
	CGContextSetTextMatrix(c, CGAffineTransformMakeScale(1.0, -1.0));
	CGContextSetTextDrawingMode(c, kCGTextFill);

	for (int i =0; i<3; i++) {
		CGContextShowTextAtPoint(c, startingOffsetX + tokenSize + margin, startingOffsetY + i * lineSpace + 28, buffer, strlen(buffer));

	}
	
	//amount
	CGContextSelectFont(c, PrimaryFont, 40.0, kCGEncodingMacRoman);
	
	player.roundAmountUpdated ? CGContextSetFillColorWithColor(c, [UIColor whiteColor].CGColor) : CGContextSetFillColorWithColor(c, [UIColor grayColor].CGColor);
	
	sprintf(buffer, "%d", player.roundAmount);
	CGContextShowTextAtPoint(c, startingOffsetX + tokenSize + 15 + margin*2, startingOffsetY + 34, buffer, strlen(buffer));	

	player.rectAmountUpdated ? CGContextSetFillColorWithColor(c, [UIColor whiteColor].CGColor) : CGContextSetFillColorWithColor(c, [UIColor grayColor].CGColor);	
	
	sprintf(buffer, "%d", player.rectAmount);
	CGContextShowTextAtPoint(c, startingOffsetX + tokenSize + 15 + margin*2, startingOffsetY + lineSpace + 34, buffer, strlen(buffer));	
	
	player.squareAmountUpdated ? CGContextSetFillColorWithColor(c, [UIColor whiteColor].CGColor) : CGContextSetFillColorWithColor(c, [UIColor grayColor].CGColor);	
	
	sprintf(buffer, "%d", player.squareAmount);
	CGContextShowTextAtPoint(c, startingOffsetX + tokenSize + 15 + margin*2, startingOffsetY + lineSpace * 2 + 34, buffer, strlen(buffer));		
}
 */

- (void)endTurnButtonClicked{
	if (player.aiProcessInProgress || player != gameLogic.currentPlayer) {
		return;
	}else {
		[gameLogic endTurnButtonClicked];
	}

	
}

- (void)toggleAIButtonClicked{
	if (player.aiProcessInProgress) {
		return;
	}
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
		[toggleAIButton setImage:[UIImage imageNamed:@"Player.png"] forState:UIControlStateNormal];
	}else {
		[toggleAIButton setImage:[UIImage imageNamed:@"AI.png"] forState:UIControlStateNormal];
	}	
}

- (void)update{
	if (svc.player == nil) {
		svc.player = self.player;
	}
	[svc update];
    
    if (gameLogic.currentPlayer == player){
        currentPlayerMark.hidden = NO;
    }else{
        currentPlayerMark.hidden = YES;
    }

}


- (void)dealloc {
	[svc release];
    [super dealloc];
}


@end

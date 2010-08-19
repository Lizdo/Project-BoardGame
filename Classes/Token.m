//
//  Token.m
//  BoardGame
//
//  Created by Liz on 10-5-1.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "Token.h"
#import "GameLogic.h"
#import "GameVisual.h"
#import "Player.h"

@implementation Token

@synthesize pickedUp, shared, isMatched,type, boundary, player, lastPosition;

- (void)setType:(TokenType)newType{
	//set the background pic to the new type
//	switch (newType) {
//		case TokenTypePlayer:
//			//
//			break;
//		default:
//			self.image = [UIImage imageNamed:@"Round.png"];
//			break;
//	}
	type = newType;
}

- (void)setPlayer:(Player *)newPlayer{
	player = newPlayer;
	self.image = [GameVisual imageForTokenType:type andPlayerID:player.ID placeholder:NO];
}

- (void)setShared:(BOOL)newBool{
	shared = newBool;
	if (shared) {
		self.image = [GameVisual imageForSharedTokenWithType:type];		
	}
}


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		boundary = CGRectZero;
		gameLogic = [GameLogic sharedInstance];
		shared = NO;
		self.userInteractionEnabled = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin
		|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;

		
    }
    return self;
}

+ (id)tokenWithType:(TokenType)aType andPosition:(CGPoint)p{
	CGRect r = CGRectMake(p.x - TokenSize, p.y - TokenSize, TokenSize*2, TokenSize*2);
	Token * t = [[Token alloc] initWithFrame:r];
	t.lastPosition = p;
	t.type = aType;
	return [t autorelease];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)moveTo:(CGPoint)position byAI:(BOOL)byAI inState:(RoundState)state{
	[gameLogic triggerEvent:TokenEventPickedUp withToken:self atPosition:self.center];	
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationDuration:MoveAnimationTime + rand()%100*0.002]; 
	[UIView setAnimationDelegate:self];
	roundState = state;
	if (byAI) {
		[UIView setAnimationDidStopSelector:@selector(AImoveComplete)];
	}
	self.center = position;
	[UIView commitAnimations];
}
	 
- (void)AImoveComplete{
	[gameLogic triggerEvent:TokenEventDroppedDown withToken:self atPosition:self.center];
	if (roundState == RoundStateRumble || gameLogic.turn.state == TurnStateBuild) {
		return;
	}
	if (!gameLogic.currentPlayer.isHuman) {
		//exit turn
		[gameLogic.currentPlayer AImoveComplete];
	}
}

- (void)tokenOnTile:(BOOL)onTile{
	if (self.type != TokenTypePlayer) {
		return;
	}
	self.image = [GameVisual playerTokenImageForPlayerID:player.ID onTile:onTile];

}

- (void)moveToLastPosition{
	[self moveTo:lastPosition byAI:NO inState:RoundStateRumble];
}

#pragma mark -
#pragma mark Control

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	DebugLog(@"input!");
	if (player.isHuman || DEBUG_MODE) {
		pickedUp = YES;
		[gameLogic triggerEvent:TokenEventPickedUp withToken:self atPosition:self.center];			
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	if (pickedUp){
		UITouch *touch = [touches anyObject];
		//TODO: refactor to support multiple bounds
		CGPoint location = [touch locationInView:[self superview]];
		if (CGRectIsEmpty(boundary) || CGRectContainsPoint(boundary, location)){
			self.center = location;
			[gameLogic triggerEvent:TokenEventHover withToken:self atPosition:self.center];			
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[gameLogic triggerEvent:TokenEventDroppedDown withToken:self atPosition:self.center];	
	pickedUp = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	[gameLogic triggerEvent:TokenEventDroppedDown withToken:self atPosition:self.center];	
	pickedUp = NO;
}

- (void)dealloc {
    [super dealloc];
}



@end

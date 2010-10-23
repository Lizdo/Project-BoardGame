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
#import "Board.h"

@implementation Token

@synthesize pickedUp, shared, isMatched,type, boundary, player, lastPosition, locked, hasMoved, onBoardID;

- (void)setType:(TokenType)newType{
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
		locked = NO;
		hasMoved = NO;
		self.userInteractionEnabled = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin
		|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;

    }
    return self;
}

+ (id)tokenWithType:(TokenType)aType andPosition:(CGPoint)p{
	float size;
	if (aType != TokenTypePlayer) {
		size = TokenSize;
	}else {
		size = PlayerTokenSize;
	}
	CGRect r = CGRectMake(p.x - size, p.y - size, size*2, size*2);
	Token * t = [[Token alloc] initWithFrame:r];
	t.lastPosition = p;
	t.type = aType;
	return [t autorelease];
}


- (void)moveTo:(CGPoint)position withMoveFlag:(MoveFlag)flag{
	[gameLogic triggerEvent:TokenEventPickedUp withToken:self atPosition:self.center];	
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationDuration:MoveAnimationTime + rand()%100*0.002]; 
	[UIView setAnimationDelegate:self];
	roundState = [Round sharedInstance].state;
	moveFlag = flag;
	if (moveFlag == MoveFlagAINormal || moveFlag == MoveFlagAIRumble) {
		[UIView setAnimationDidStopSelector:@selector(AImoveComplete)];
	}
	self.center = position;
	[UIView commitAnimations];
}
	 
- (void)AImoveComplete{
	[gameLogic triggerEvent:TokenEventDroppedDown withToken:self atPosition:self.center];
	if (!gameLogic.currentPlayer.isHuman && moveFlag == MoveFlagAINormal) {
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
	[self moveTo:lastPosition withMoveFlag:MoveFlagPlayerRumble];
}

#pragma mark -
#pragma mark Control

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	if (locked) {
		return;
	}
	
	[[Board sharedInstance] tokenPickedup:self];
	
	self.hasMoved = YES;
	DebugLog(@"input!");
	if (player.isHuman || DEBUG_MODE) {
		pickedUp = YES;
		[gameLogic triggerEvent:TokenEventPickedUp withToken:self atPosition:self.center];			
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	if (locked) {
		return;
	}	
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
	if (locked) {
		return;
	}	
	[gameLogic triggerEvent:TokenEventDroppedDown withToken:self atPosition:self.center];	
	pickedUp = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	if (locked) {
		return;
	}	
	[gameLogic triggerEvent:TokenEventDroppedDown withToken:self atPosition:self.center];	
	pickedUp = NO;
}

- (NSComparisonResult)compare:(Token *)t{
	return [[NSNumber numberWithInt:self.onBoardID] compare:[NSNumber numberWithInt:t.onBoardID]];
}

- (void)dealloc {
    [super dealloc];
}



@end

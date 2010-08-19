//
//  TokenPlaceholder.m
//  BoardGame
//
//  Created by Liz on 10-5-14.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "TokenPlaceholder.h"
#import "GameVisual.h"
#import "Player.h"

@implementation TokenPlaceholder

@synthesize hasMatch, matchedToken;

- (void)setHasMatch:(BOOL)match{
	if (match) {
		self.backgroundColor = [UIColor colorWithRed:0.800 green:1.000 blue:0.400 alpha:1.000];
	}else {
		self.backgroundColor = nil;
	}
	hasMatch = match;
}

- (void)setPlayer:(Player *)newPlayer{
	player = newPlayer;
	self.image = [GameVisual imageForTokenType:type andPlayerID:player.ID placeholder:YES];
}

- (void)setMatchedToken:(Token *)token{
	if (matchedToken) {
		matchedToken.isMatched = NO;
	}
	matchedToken = token;
	matchedToken.isMatched = YES;
	
}



- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.userInteractionEnabled = NO;
		self.hasMatch = NO;
    }
    return self;
}

+ (id)tokenPlaceholderWithType:(TokenType)aType andPosition:(CGPoint)p{
	CGRect r = CGRectMake(p.x - TokenSize, p.y - TokenSize, TokenSize*2, TokenSize*2);
	TokenPlaceholder * t = [[TokenPlaceholder alloc] initWithFrame:r];
	t.type = aType;
	return [t autorelease];
}

- (void)reset{
	self.hasMatch = NO;
	if (matchedToken) {
		[matchedToken removeFromSuperview];
	}
	self.matchedToken = nil;
}

- (void)remove{
	self.hasMatch = NO;
	if (matchedToken) {
		//[matchedToken removeFromSuperview];
		[matchedToken moveToLastPosition];
	}
	self.matchedToken = nil;
}

@end

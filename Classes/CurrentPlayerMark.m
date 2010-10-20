//
//  CurrentPlayerMark.m
//  BoardGame
//
//  Created by Liz on 10-9-3.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "CurrentPlayerMark.h"
#import "GameVisual.h"

@implementation CurrentPlayerMark


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
        [self setImage:[UIImage imageNamed:@"CurrentProducer.png"]];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (void)moveToPlayerWithID:(int)playerID withAnim:(BOOL)withAnim{
	if (withAnim) {
		[UIView beginAnimations:@"MoveCurrentPlayerMark" context:nil];
		[UIView setAnimationDuration:MoveAnimationTime];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(movementComplete)];
		self.center = [GameVisual positionForPlayerID:playerID withOffsetFromInfoCenter:CurrentPlayerMarkOffset];
		self.transform = [GameVisual transformForPlayerID:playerID];
		[UIView commitAnimations];
	}else {
		self.center = [GameVisual positionForPlayerID:playerID withOffsetFromInfoCenter:CurrentPlayerMarkOffset];
		self.transform = [GameVisual transformForPlayerID:playerID];				
	}
}

- (void)movementComplete{
	
}

- (void)dealloc {
    [super dealloc];
}


@end

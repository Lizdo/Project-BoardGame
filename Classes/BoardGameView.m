//
//  BoardGameView.m
//  BoardGame
//
//  Created by Liz on 10-8-25.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "BoardGameView.h"


@implementation BoardGameView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		board = [[Board alloc] initWithFrame:self.bounds];
		rumbleBoard = [[RumbleBoard alloc]initWithFrame:self.bounds];
    }
    return self;
}

- (void)initGame{
	[board setValue:controller forKey:@"controller"];
	[board setValue:self forKey:@"bgv"];
	[rumbleBoard setValue:controller forKey:@"controller"];
	[rumbleBoard setValue:self forKey:@"bgv"];
	[self addSubview:board];

}

- (void)enterRumble{
	rumbleBoard.frame = self.bounds;
	[rumbleBoard enterRumble];
	
//	[UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.5];
//    [UIView setAnimationBeginsFromCurrentState:NO];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:YES];
//	[UIView setAnimationDelegate:rumbleBoard];
//	[UIView setAnimationDidStopSelector:@selector(enterRumbleAnimDidStop)];
//	
//    [self addSubview:rumbleBoard];
//    [UIView commitAnimations];
	
    [self addSubview:rumbleBoard];
	[rumbleBoard enterRumbleAnimDidStop];
}

- (void)exitRumble{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.5];
//    [UIView setAnimationBeginsFromCurrentState:NO];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:YES];
//	
//    [rumbleBoard removeFromSuperview];
//    [UIView commitAnimations];	
	[rumbleBoard removeFromSuperview];
	[rumbleBoard exitRumble];	
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
	[board release];
	[rumbleBoard release];
    [super dealloc];
}


@end

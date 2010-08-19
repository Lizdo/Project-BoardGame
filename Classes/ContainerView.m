//
//  ContainerView.m
//  BoardGame
//
//  Created by Liz on 10-7-8.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "ContainerView.h"


@implementation ContainerView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
	
    if (hitView == self)
		//non of my subView's bounds are hit, and I'm transparent
        return nil;
    else
        return hitView;
	
}

- (void)dealloc {
    [super dealloc];
}


@end

//
//  NoteView.m
//
//  Created by Liz on 10-6-30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NoteView.h"


@interface NoteView (Private)

- (void)slideOut;
- (void)slideIn;

@end

@implementation NoteView

@synthesize hasSlidedOut;

- (void)setHasSlidedOut:(BOOL)newBool{
	if (hasSlidedOut == newBool) {
		return;
	}
	hasSlidedOut = newBool;
	hasSlidedOut ? [self slideOut]:[self slideIn];
}

- (void)slideOut{
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationDuration:SlideOutTime]; 
	[UIView setAnimationDelegate:self];
	self.center = CGPointMake(self.center.x,self.bounds.size.height/2);
	[UIView commitAnimations];
}

- (void)slideIn{
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationDuration:SlideOutTime]; 
	[UIView setAnimationDelegate:self];
	self.center = CGPointMake(self.center.x, self.bounds.size.height+60);
	[UIView commitAnimations];	
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
	if (point.x < 208 && point.y < 80) {
		return NO;
	}
	if (!CGRectContainsPoint(self.bounds, point)) {
		return NO;
	}
	return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	self.hasSlidedOut = !hasSlidedOut;
}

@end

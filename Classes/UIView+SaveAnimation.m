//
//  UIView+SaveAnimation.m
//  BoardGame
//
//  Created by Liz on 10-8-7.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>


@interface UIView (SaveAnimation)

- (void)saveCurrentAnim;
- (void)restoreCurrentAnim;

@end

@implementation UIView (SaveAnimation)

CAAnimation * savedAnimation;
NSString * key;

- (void)saveCurrentAnim{
	if ([self.layer animationKeys].count > 0) {
		key = [[[self.layer animationKeys] objectAtIndex:0] copy];
		savedAnimation = [self.layer animationForKey:key];
		[self.layer removeAllAnimations];
	}else {
		savedAnimation = nil;
	}
	
}
- (void)restoreCurrentAnim{
	if (savedAnimation) {
		[self.layer addAnimation:savedAnimation forKey:key];
		[key release];
	}
}

@end

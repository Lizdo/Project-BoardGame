//
//  BGImageView.m
//  BoardGame
//
//  Created by Liz on 10-9-20.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "BGViewWithPopup.h"


@implementation BGViewWithPopup


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
		[self addGestureRecognizer:recognizer];		
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


- (void)addPopup{
	if (popupController == nil) {
		popupController = [[BGPopupController alloc]initWithSourceObject:self];
	}
	[popupController presentPopup];
	
}

- (void)handleTap{
	if (popupController && popupController.popupPresent) {
		[self removePopup];
	}else{
		[self addPopup];
	}
	
}


- (void)removePopup{
	if (popupController) {
		[popupController dismissPopup];
	}
}

- (NSString *)title{
	return @"Title Empty";
}

- (NSString *)description{
	return @"Title Empty";
}

- (Player *)player{
	return nil;
}

- (void)dealloc {
	[recognizer release];
	[popupController release];
    [super dealloc];
}




@end

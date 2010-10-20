//
//  BGImageView.h
//  BoardGame
//
//    UIView Subclass to allow simple Popups via Title/Description String
//
//  Created by Liz on 10-9-20.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGPopupController.h"

@interface BGViewWithPopup : UIView <BGPopup>{
	BGPopupController * popupController;
	UITapGestureRecognizer * recognizer;
}

@property (retain, nonatomic) BGPopupController * popupController;

- (void)handleTap;

@end

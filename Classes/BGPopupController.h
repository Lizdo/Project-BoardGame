//
//  BGPopupController.h
//  BoardGame
//
//  Created by Liz on 10-9-16.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Player;

@protocol BGPopup

- (void)addPopup;
- (void)removePopup;
- (NSString *)title;
- (NSString *)description;
- (Player *)player;

@end


@protocol BGPopupBoard

- (void)addPopup:(UIView *)popup;
- (void)removePopup:(UIView *)popup;
- (void)removeAllPopups;

@end

@interface BGPopupController : UIViewController {
	UIView <BGPopup> *  sourceObject;
	
	IBOutlet UILabel * titleLabel;
	IBOutlet UITextView * descriptionTextView;
	
	BOOL popupPresent;
	
	UIView <BGPopupBoard> * theBoard;
}

@property (assign) BOOL popupPresent;

- (id)initWithSourceObject:(id)object;

- (void)presentPopup;
- (void)dismissPopup;

@end



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


@interface BGPopupController : UIViewController {
	UIView <BGPopup> *  sourceObject;
	
	IBOutlet UILabel * titleLabel;
	IBOutlet UITextView * descriptionTextView;
	
	BOOL popupPresent;
}

@property (assign) BOOL popupPresent;

- (id)initWithSourceObject:(id)object;

- (void)presentPopup;
- (void)dismissPopup;

@end



//
//  BGPopupController.h
//  BoardGame
//
//  Created by Liz on 10-9-16.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BGPopupController : UIViewController {
	id sourceObject;
	
	IBOutlet UILabel * titleLabel;
	IBOutlet UITextView * descriptionTextView;	
}

- (id)initWithSourceObject:(id)object;

- (void)presentPopupAt:(CGPoint)p;
- (void)dismissPopup;

@end

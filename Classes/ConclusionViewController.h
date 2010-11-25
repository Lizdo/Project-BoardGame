//
//  ConclusionViewController.h
//  BoardGame
//
//  Created by Liz on 10-8-30.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BoardGameViewController;


@interface ConclusionViewController : UIViewController {
	
	IBOutlet UIWebView * scoreWebView;
	
	BoardGameViewController * bgvc;
}

- (IBAction)showMainMenu;

@end

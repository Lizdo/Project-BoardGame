//
//  TutorialViewController.h
//  BoardGame
//
//  Created by Liz on 10-10-22.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TutorialPageWidth 469
#define TutorialPageHeight 616

#define TutorialPageNumber 4

@interface TutorialViewController : UIViewController {
	IBOutlet UIScrollView * scrollView;
	IBOutlet UIPageControl * pageControl;
	IBOutlet UIButton * closeButton;
	
	BOOL pageControlUsed;
}

- (IBAction)changePage:(id)sender;
- (IBAction)closeTutorial:(id)sender;

@end

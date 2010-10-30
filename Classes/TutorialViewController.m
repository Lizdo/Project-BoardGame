    //
//  TutorialViewController.m
//  BoardGame
//
//  Created by Liz on 10-10-22.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "TutorialViewController.h"
#import "GameVisual.h"
#import "Game.h"

@interface TutorialViewController (Private)

- (void)scrollViewDidScroll:(UIScrollView *)sender;


@end



@implementation TutorialViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    scrollView.contentSize=CGSizeMake(TutorialPageWidth * TutorialPageNumber, TutorialPageHeight);
	//Load the pages onto the scrollview
	for (int i = 0; i<TutorialPageNumber; i++) {
		UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(TutorialPageWidth*i, 0, TutorialPageWidth, TutorialPageHeight)];
		[imageView autorelease];
		NSString * pageName = [NSString stringWithFormat:@"TutorialPage%d.png", i];
		imageView.image = [UIImage imageNamed:pageName];
		[scrollView addSubview:imageView];

	}
	self.view.alpha = 0;
	
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationDuration:RoundIntroFadeTime]; 
	[UIView setAnimationDelegate:self.view];
	self.view.alpha = 1;
	[UIView commitAnimations];
	
	if ([Game sharedInstance].running) {
		[[Game sharedInstance] pause];
	}	
	//scrollView.backgroundColor = [GameVisual colorWithHex:0xEEEEEE];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
    
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
	
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender {
    int page = pageControl.currentPage;
    
    // update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}


- (IBAction)closeTutorial:(id)sender{
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationDuration:RoundIntroFadeTime]; 
	[UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
	[UIView setAnimationDelegate:self.view];
	self.view.alpha = 0;
	[UIView commitAnimations];	
	
	if ([Game sharedInstance].running) {
		[[Game sharedInstance] resume];
	}	//[self.view removeFromSuperview];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

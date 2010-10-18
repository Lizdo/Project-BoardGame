    //
//  RumbleIntroViewController.m
//  BoardGame
//
//  Created by Liz on 10-10-18.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "RumbleIntroViewController.h"
#import "Round.h"

@interface RumbleIntroViewController (Private)

- (void)fadeInComplete;

@end

@implementation RumbleIntroViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void)show{
	self.view.alpha = 0.0;
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationDuration:RoundIntroFadeTime];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(fadeInComplete)];	
	self.view.alpha = 1.0;
	[UIView commitAnimations];
}

- (void)fadeInComplete{
	[[Round sharedInstance] enterRumbleWaitComplete];
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

    //
//  RoundIntroViewController.m
//  BoardGame
//
//  Created by Liz on 10-10-18.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "RoundIntroViewController.h"
#import "Game.h"

@interface RoundIntroViewController (Private)

- (void)fadeInComplete;
- (void)countChangeComplete;
- (void)fadeOutComplete;

@end

@implementation RoundIntroViewController


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

#define RoundsRemaingLabelPosition CGPointMake(105,149)
#define LastRoundsRemaingLabelPosition CGPointMake(105,128)
#define LastRoundsRemaingLabelEndPosition CGPointMake(105,107)

- (void)show{
	round = [Round sharedInstance];

	currentRoundLabel.text = [NSString stringWithFormat:@"Week %d Starts...", round.count + 1];
	roundsRemaingLabel.text = [NSString stringWithFormat:@"%d", [Game NumberOfRounds] - (round.count + 1)];
	lastRoundsRemaingLabel.text = [NSString stringWithFormat:@"%d", [Game NumberOfRounds] - (round.count + 1) + 1];
	
	lastRoundsRemaingLabel.center = LastRoundsRemaingLabelPosition;
	roundsRemaingLabel.center = RoundsRemaingLabelPosition;
	
	self.view.alpha = 0.0;
	roundsRemaingLabel.alpha = 0.0;
	lastRoundsRemaingLabel.alpha = 1.0;
	
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationDuration:RoundIntroFadeTime];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(fadeInComplete)];	
	self.view.alpha = 1.0;
	[UIView commitAnimations];
}

- (void)fadeInComplete{
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationDuration:RoundIntroOnScreenTime];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(countChangeComplete)];	
	lastRoundsRemaingLabel.center = LastRoundsRemaingLabelEndPosition;
	roundsRemaingLabel.center = LastRoundsRemaingLabelPosition;
	lastRoundsRemaingLabel.alpha = 0.0;
	roundsRemaingLabel.alpha = 1.0;
	[UIView commitAnimations];	
}


- (void)countChangeComplete{
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationDuration:RoundIntroFadeTime];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(fadeOutComplete)];	
	self.view.alpha = 0.0;
	[UIView commitAnimations];	
}

- (void)fadeOutComplete{
	[round enterRoundWaitComplete];
	[self.view removeFromSuperview];
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

    //
//  ConclusionViewController.m
//  BoardGame
//
//  Created by Liz on 10-8-30.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "ConclusionViewController.h"
#import "GameLogic.h"


@implementation ConclusionViewController

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
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSMutableArray * players = [[[GameLogic sharedInstance] players] mutableCopy];
	[players sortUsingSelector:@selector(compare:)];
	
	fourthPlaceName.text = [[players objectAtIndex:0] name];
	thirdPlaceName.text = [[players objectAtIndex:1] name];	
	secondPlaceName.text = [[players objectAtIndex:2] name];
	firstPlaceName.text = [[players objectAtIndex:3] name];	

	fourthPlaceScore.text = [NSString stringWithFormat:@"%d",[[players objectAtIndex:0] score]];
	thirdPlaceScore.text = [NSString stringWithFormat:@"%d",[[players objectAtIndex:1] score]];
	secondPlaceScore.text = [NSString stringWithFormat:@"%d",[[players objectAtIndex:2] score]];
	firstPlaceScore.text = [NSString stringWithFormat:@"%d",[[players objectAtIndex:3] score]];	
	
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

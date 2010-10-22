//
//  BoardGameViewController.m
//  BoardGame
//
//  Created by Liz on 10-5-1.
//  Copyright StupidTent co 2010. All rights reserved.
//

#import "BoardGameViewController.h"

@implementation BoardGameViewController


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {

	game = [Game sharedInstance];
	
	CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
	bgv = [[BoardGameView alloc] initWithFrame:applicationFrame];
	self.view = bgv;
	[bgv setValue:self forKey:@"controller"];

	[bgv initGame];
	
	
	if (!SkipMenu) {
		//Add manu
		mmv = [[MainMenuViewController alloc]initWithNibName:@"MainMenu" bundle:nil];
		[bgv addSubview:mmv.view];
		mmv.view.frame = bgv.bounds;
		[mmv setValue:game forKey:@"game"];
		
		//Add tutorial
		[self showTutorial];
	}
}

- (void)showTutorial{
	tvc = [[TutorialViewController alloc] initWithNibName:@"TutorialView" bundle:nil];
	[bgv addSubview:tvc.view];
	tvc.view.center = bgv.center;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	if (SkipMenu) {
		[game start];
	}
}

- (void)enterConclusion{
	cvc = [[ConclusionViewController alloc] initWithNibName:@"ConclusionView" bundle:nil];
	[cvc setValue:self forKey:@"bgvc"];
	[self.view addSubview:cvc.view];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
	//TODO: Support landscape
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	[board disableAnimations];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
	[board enableAnimations];
}



- (void)dealloc {
	[cvc release];
    [mmv release];
	[menu release];
	[game release];
    [super dealloc];
}

@end

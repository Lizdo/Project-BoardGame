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
	CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
	board = [[[Board alloc] initWithFrame:applicationFrame] autorelease];
	board.backgroundColor = [GameVisual boardBackgroundColor];
	self.view = board;
	[board setValue:self forKey:@"controller"];
	game = [[Game alloc] init];
	
	if (!SkipMenu) {
		mmv = [[MainMenuViewController alloc]initWithNibName:@"MainMenu" bundle:nil];
		[board addSubview:mmv.view];
		mmv.view.frame = board.bounds;
		[mmv setValue:game forKey:@"game"];
	}
}




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	if (SkipMenu) {
		[game start];
	}
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
    [mmv release];
	[menu release];
	[game release];
    [super dealloc];
}

@end

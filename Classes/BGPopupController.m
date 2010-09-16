    //
//  BGPopupController.m
//  BoardGame
//
//  Created by Liz on 10-9-16.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "BGPopupController.h"
#import "Board.h"


@implementation BGPopupController

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

- (id)initWithSourceObject:(id)object{
	self = [[BGPopupController alloc] initWithNibName:@"BGPopupController" bundle:nil];
	sourceObject = object;
	return self;
}

- (void)presentPopupAt:(CGPoint)p{
	Board * board = [Board sharedInstance];
	self.view.center = CGPointMake(p.x + PopupWidth/2, p.y);
	titleLabel.text = [sourceObject valueForKey:@"title"];
	descriptionTextView.text = [sourceObject valueForKey:@"description"];
	[board addPopup:self.view];
}

- (void)dismissPopup{
	[[Board sharedInstance] removePopup:self.view];
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

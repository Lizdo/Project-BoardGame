    //
//  BGPopupController.m
//  BoardGame
//
//  Created by Liz on 10-9-16.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "BGPopupController.h"
#import "Board.h"
#import "Player.h"


@interface BGPopupController(Private)

- (void)setAnchorPoint;

@end


@implementation BGPopupController

@synthesize popupPresent;

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
	popupPresent = NO;
	return self;
}

- (void)presentPopup{
	if ([[GameLogic sharedInstance] isInRumble]) {
		theBoard = [RumbleBoard sharedInstance];
	}else {
		theBoard = [Board sharedInstance];
	}

	[self setAnchorPoint];
	titleLabel.text = [sourceObject title];
	descriptionTextView.text = [sourceObject description];
	
	[theBoard addPopup:self.view];

	popupPresent = YES;
}

- (void)setAnchorPoint{
	//need to use cached board as it can be Board or RumbleBoard
	CGPoint p = [theBoard convertPoint:sourceObject.center fromView:sourceObject.superview];
	CGRect r = [theBoard convertRect:sourceObject.bounds fromView:sourceObject.superview];
	self.view.transform = [GameVisual transformForPlayerID:[sourceObject player].ID];
	switch ([sourceObject player].ID) {
		case 0:
			self.view.center = CGPointMake(p.x + r.size.width/2 + PopupWidth/2, p.y);
			break;
		case 1:
			self.view.center = CGPointMake(p.x, p.y + r.size.height/2 + PopupWidth/2);
			break;
		case 2:
			self.view.center = CGPointMake(p.x - r.size.width/2 - PopupWidth/2, p.y);
			break;
		case 3:
			self.view.center = CGPointMake(p.x, p.y - r.size.height/2 - PopupWidth/2);
			break;			
		default:
			break;
	}
}

- (void)dismissPopup{
	[[Board sharedInstance] removePopup:self.view];
	popupPresent = NO;
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

    //
//  ConclusionViewController.m
//  BoardGame
//
//  Created by Liz on 10-8-30.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "ConclusionViewController.h"
#import "GameLogic.h"
#import "Game.h"
#import "BoardGameViewController.h"


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
	
	[[Game sharedInstance] pause];
	
	[scoreWebView setBackgroundColor:[UIColor clearColor]];
	[scoreWebView setOpaque:NO];
	
	NSMutableArray * players = [[[[GameLogic sharedInstance] players] mutableCopy] autorelease];
	[players sortUsingSelector:@selector(compare:)];
	
	NSString * s = @"<HEAD>"
	"<STYLE type='text/css'>"
 	"h1 {"
 	"	font-family: HelveticaNeue;"
 	"	font-size: 30px;"
	"color: #666666;"
	"   margin-top: 12px;"
	"   margin-bottom: 12px;"		
 	"}"	
	
 	"h2 {"
 	"	font-family: HelveticaNeue;"
 	"	font-size: 20px;"
	"color: #B3B3B3;"
	"   margin-left: 12px;"
	"   margin-top: 4px;"
	"   margin-bottom: 4px;"	
	"font-weight: normal;"	
 	"}"
 	
 	"p {"
	"   margin-left: 24px;"
 	"	font-family: HelveticaNeue;"
 	"	font-size: 12px; "
	"   color: #999;"
	"   margin-top: 4px;"
	"   margin-bottom: 4px;"		
 	"}"
	
 	".score {"
	"display: block;"
	"float: right;"	
  	"text-align: right;"
	"color: #4A9586;"
	"}"
	
	"p .score{"
	"color: #8DC7BB;"		
	"}"
	
	"</STYLE>"
	"</HEAD>"
	"<BODY  style='background-color: rgba(255, 255, 255, 0.3); border: 1px;'>";
	
	for (int i = 0; i<[players count]; i++) {
		Player * p = [players objectAtIndex:[players count] - i - 1];
		s = [s stringByAppendingFormat:@"<H1>No. %d: %@ <span class = 'score'>%d</span></H1>", i+1, p.name, p.score]; 
		s = [s stringByAppendingString:[p scoreDescription]];
	}
			 
	s = [s stringByAppendingFormat:@"</BODY>"];

	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
	[scoreWebView loadHTMLString:s baseURL:baseURL];
	
	
	for (UIView* subView in [scoreWebView subviews])
    {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            for (UIView* shadowView in [subView subviews])
            {
                if ([shadowView isKindOfClass:[UIImageView class]]) {
                    [shadowView setHidden:YES];
                }
            }
        }
    }
	
	//
//	fourthPlaceName.text = [[players objectAtIndex:0] name];
//	thirdPlaceName.text = [[players objectAtIndex:1] name];	
//	secondPlaceName.text = [[players objectAtIndex:2] name];
//	firstPlaceName.text = [[players objectAtIndex:3] name];	
//
//	fourthPlaceScore.text = [NSString stringWithFormat:@"%d",[[players objectAtIndex:0] score]];
//	thirdPlaceScore.text = [NSString stringWithFormat:@"%d",[[players objectAtIndex:1] score]];
//	secondPlaceScore.text = [NSString stringWithFormat:@"%d",[[players objectAtIndex:2] score]];
//	firstPlaceScore.text = [NSString stringWithFormat:@"%d",[[players objectAtIndex:3] score]];	
	
}

- (IBAction)showMainMenu{
	[bgvc restart];
	[self.view removeFromSuperview];
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

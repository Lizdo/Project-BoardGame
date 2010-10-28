    //
//  ScoreViewController.m
//  BoardGame
//
//  Created by Liz on 10-5-9.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "ScoreViewController.h"
#import "GameVisual.h"
#import "Badge.h"
#import "Project.h"

@implementation ScoreViewController

@synthesize player;




- (void)update{
	scoreLabel.text = [NSString stringWithFormat:@"%d",player.score];

	[scoreWebView setBackgroundColor:[UIColor clearColor]];
	[scoreWebView setOpaque:NO];	
	
	NSString * htmlString = [self scoreDescription];
	
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
	[scoreWebView loadHTMLString:htmlString baseURL:baseURL];
	
}

- (NSString *)scoreDescription{
	//header
	NSString * s = 	@"<HEAD>"
	"<STYLE type='text/css'>"
 	"h2 {"
 	"	font-family: Palatino-Roman;"
 	"	font-size: 20px;"
	"   margin-top: 4px;"
	"   margin-bottom: 4px;"	
	"color: #666;"
 	"}"
 	
 	"p {"
	"   margin-left: 18px;"
 	"	font-family: Thonburi;"
 	"	font-size: 18px; "
	"   margin-top: 4px;"
	"   margin-bottom: 4px;"	
	"color: #999;"
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
	"<BODY>";
	s = [s stringByAppendingString:[player scoreDescription]];
	
	s = [s stringByAppendingFormat:@"</BODY>"];
	return s;
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

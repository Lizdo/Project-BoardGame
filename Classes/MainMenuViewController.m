    //
//  MainMenuViewController.m
//  BoardGame
//
//  Created by Liz on 10-7-17.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "MainMenuViewController.h"
#import "TutorialViewController.h"
#import "SoundManager.h"

@implementation MainMenuViewController

@synthesize tvc,cm;

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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


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

- (void)startGameWithPlayerNumber:(int)playerNumber{
	[[SoundManager sharedInstance] playSoundWithTag:SoundTagTape];
	
	[self.view removeFromSuperview];

	int totalPlayerNumber = fourPlayerToggleButton.selected ? 4 : 2;
	
	playerNumber = MIN(playerNumber, totalPlayerNumber);
	
	[game startWithOptions:[NSDictionary dictionaryWithObjectsAndKeys:
							[NSNumber numberWithInt:playerNumber], @"NumberOfPlayers",
							[NSNumber numberWithInt:totalPlayerNumber], @"TotalNumberOfPlayers",nil]];
}

- (IBAction) playWithOnePlayer{
	[self startGameWithPlayerNumber:1];
}

- (IBAction) playWithTwoPlayers{
	[self startGameWithPlayerNumber:2];
}

- (IBAction) playWithThreePlayers{
	[self startGameWithPlayerNumber:3];
}

- (IBAction) playWithFourPlayers{
	[self startGameWithPlayerNumber:4];
}


- (IBAction) toggleFourPlayersButton{
	[fourPlayerToggleButton setSelected:!fourPlayerToggleButton.selected];
}

- (IBAction) playWithAI{
	[self startGameWithPlayerNumber:1];
}

- (IBAction) playWithHuman{
	//Player number will be capped by total player number
	[self startGameWithPlayerNumber:4];
}

- (IBAction) aiPlay{
	[self startGameWithPlayerNumber:0];	
}

- (IBAction) showChallengeMenu{
	[[SoundManager sharedInstance] playSoundWithTag:SoundTagTape];
	
	self.cm = [[[ChallengeMenu alloc] initWithNibName:@"ChallengeMenu" bundle:nil]autorelease];
	[cm setValue:game forKey:@"game"];
	[self.view addSubview:cm.view];
	cm.view.center = self.view.center;
}



- (IBAction) resumeGame{
	[[SoundManager sharedInstance] playSoundWithTag:SoundTagTape];
	[self.view removeFromSuperview];		
	[game load];
}


- (IBAction) showTutorial{
	[[SoundManager sharedInstance] playSoundWithTag:SoundTagTape];

	self.tvc = [[TutorialViewController alloc] initWithNibName:@"TutorialView" bundle:nil];
	[self.view addSubview:tvc.view];
	tvc.view.center = self.view.center;
	[tvc autorelease];
}


- (void)dealloc {
    [super dealloc];
}


@end

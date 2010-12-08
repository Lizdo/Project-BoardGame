    //
//  BoardInfoViewController.m
//  BoardGame
//
//  Created by Liz on 10-10-13.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "BoardInfoViewController.h"
#import "Board.h"
#import "GameLogic.h"


@implementation BoardInfoViewController


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization

		
		gameLogic = [GameLogic sharedInstance];
		soundManager = [SoundManager sharedInstance];
						
		currentRoundLabel.text = @"";
		roundRemainingLabel.text = @"";
		roundDetailTextView.text = @"";
		
    }
    return self;
}


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

- (void)update{
	round = [Round sharedInstance];

	currentRoundLabel.text = [NSString stringWithFormat:@"Week %d", round.count + 1];
	roundRemainingLabel.text = [NSString stringWithFormat:@"%d weeks remaining", [Game NumberOfRounds] - round.count - 1];	
	
	roundDetailTextView.text = [self roundInfo];
	
	roundDetailTextView.font = [UIFont fontWithName:SecondaryFontName size:14];
}

- (NSString *)roundInfo{
	NSMutableString * info = [NSMutableString stringWithFormat:@"Work hour this week: %2.0f\nAvailable helpers: %d",
					   [gameLogic buildTime], [gameLogic numberOfSharedTokens]];
	if (round.moreSharedTokens) {
		[info appendFormat:@"\nOutsourcing week!"];
	}
	if (round.skipProjectUpdate) {
		[info appendFormat:@"\nAnual Party!"];
	}
	if (round.moreBuildTime) {
		[info appendFormat:@"\nOvertime week!"];
	}
	
	NSString * gameModeDescription = [[Game sharedInstance].gameMode description];
	[info appendFormat:@"\n%@", gameModeDescription];
	
	return info;
}


- (void)toggleMusic{
	soundManager.playSound = !soundManager.playSound;
	if (soundManager.playSound) {
		[toggleMusicButton setBackgroundImage:[UIImage imageNamed:@"Sound.png"] forState:UIControlStateNormal];
	}else {
		[toggleMusicButton setBackgroundImage:[UIImage imageNamed:@"NoSound.png"] forState:UIControlStateNormal];
	}

}

- (IBAction)showTutorial{
	if (![GameLogic sharedInstance].animationInProgress) {
		[[Board sharedInstance] showTutorial];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return NO;
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

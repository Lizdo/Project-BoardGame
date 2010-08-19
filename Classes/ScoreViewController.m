    //
//  ScoreViewController.m
//  BoardGame
//
//  Created by Liz on 10-5-9.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "ScoreViewController.h"


@implementation ScoreViewController

@synthesize player;




- (void)update{
	scoreLabel.text = [NSString stringWithFormat:@"%d",player.score];
	
	resourceScoreLabel.text = [NSString stringWithFormat:@"%d",player.resourceScore];
	buildScoreLabel.text = [NSString stringWithFormat:@"%d",player.buildScore];
	
	roundScoreLabel.text = [NSString stringWithFormat:@"%d",player.roundAmount];
	rectScoreLabel.text = [NSString stringWithFormat:@"%d",player.rectAmount];
	squareScoreLabel.text = [NSString stringWithFormat:@"%d",player.squareAmount];
	robotScoreLabel.text = [NSString stringWithFormat:@"%d",player.robotAmount];
	snakeScoreLabel.text = [NSString stringWithFormat:@"%d",player.snakeAmount];
	palaceScoreLabel.text = [NSString stringWithFormat:@"%d",player.palaceAmount];

	
}


- (void)viewDidLoad {
	((NoteView *)self.view).hasSlidedOut = YES;
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

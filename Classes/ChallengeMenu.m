    //
//  ChallengeMenu.m
//  BoardGame
//
//  Created by Liz on 10-11-22.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "ChallengeMenu.h"
#import "Game.h"

@implementation ChallengeItem

@synthesize ID,mode,button,controller;

+ (ChallengeItem *)itemWithID:(int)theID andGameMode:(GameMode *)gameMode{
	ChallengeItem * b = [[ChallengeItem alloc]init];
	b.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	b.ID = theID;
	b.mode = gameMode;
	[b.button addTarget:b action:@selector(handleTap) forControlEvents:UIControlEventTouchUpInside];
	return b;	
}

- (void)handleTap{
	[self.controller startGameWithGameMode:self.mode];
}

@end

@interface ChallengeMenu(Private)

- (void)addChallengeItemWithGameMode:(GameMode *)mode;

@end


@implementation ChallengeMenu

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		challengeItems = [[NSMutableArray arrayWithCapacity:0]retain];
		//Add Challenge Buttons
		// Let's assume they're on one page
		[self addChallengeItemWithGameMode:[[GameModeCollectResource alloc] 
											   initWithResourceType:ResourceTypeRect targetAmount:3 andRoundLimit:3]];
		[self addChallengeItemWithGameMode:[[GameModeCollectResource alloc] 
											  initWithResourceType:ResourceTypeRound targetAmount:3 andRoundLimit:3]];
		[self addChallengeItemWithGameMode:[[GameModeBuildProject alloc] 
											  initWithRumbleTargetType:RumbleTargetTypeCart andRoundLimit:3]];
		[self addChallengeItemWithGameMode:[[GameModeBuildProject alloc] 
											   initWithRumbleTargetType:RumbleTargetTypeSnake andRoundLimit:5]];
		[self addChallengeItemWithGameMode:[[GameModeGetBadge alloc]
											  initWithBadgeType:BadgeTypeMostSquare andRoundLimit:15]];
		[self addChallengeItemWithGameMode:[[GameModeGetBadge alloc]
											   initWithBadgeType:BadgeTypeSevenProjects andRoundLimit:15]];		 
	}
    return self;
}

#define ChallengeItemInitY 100
#define ChallengeItemIntervalY 100

- (void)addChallengeItemWithGameMode:(GameMode *)mode{
	int i = [challengeItems count];
	ChallengeItem * item = [ChallengeItem itemWithID:i andGameMode:mode];
	item.button.frame = CGRectMake(0, 0, 500, 50);	
	item.button.center = CGPointMake(self.view.bounds.size.width/2, ChallengeItemInitY + ChallengeItemIntervalY*i);
	[item.button setTitle:[mode description] forState:UIControlStateNormal];
	item.controller = self;
	[challengeItems addObject:item];
	[self.view addSubview:item.button];
}

- (IBAction)back{
	[self.view removeFromSuperview];
}


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
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
	for (ChallengeItem * b in challengeItems) {
		[b.button removeFromSuperview];
	}
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)startGameWithGameMode:(GameMode *)mode{
	//Start Game With Option
	[[SoundManager sharedInstance] playSoundWithTag:SoundTagTape];
	
	[game startWithOptions:[NSDictionary dictionaryWithObjectsAndKeys:
							[NSNumber numberWithInt:1], @"NumberOfPlayers",
							[NSNumber numberWithInt:2],@"TotalNumberOfPlayers",
							mode,@"GameMode",
							nil]];
	
	//Remove Challenge Menu & Main Menu
	[self.view.superview removeFromSuperview];
	[self.view removeFromSuperview];		
}

- (void)dealloc {
	[challengeItems removeAllObjects];
	[challengeItems release];
    [super dealloc];
}


@end

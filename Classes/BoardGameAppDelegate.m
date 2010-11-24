//
//  BoardGameAppDelegate.m
//  BoardGame
//
//  Created by Liz on 10-5-1.
//  Copyright StupidTent co 2010. All rights reserved.
//

#import "BoardGameAppDelegate.h"
#import "BoardGameViewController.h"

@implementation BoardGameAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];

	// Game Center
//	if (isGameCenterAvailable()){
//		[self authenticateLocalPlayer];
//	}
//	
	return YES;
}

- (void)authenticateLocalPlayer
{
    [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
		if (error == nil)
		{
			// Insert code here to handle a successful authentication.
		}
		else
		{
			// Your application can process the error parameter to report the error to the player.
		}
	}];
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end

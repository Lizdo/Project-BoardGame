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

	return YES;
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end

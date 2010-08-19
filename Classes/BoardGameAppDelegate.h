//
//  BoardGameAppDelegate.h
//  BoardGame
//
//  Created by Liz on 10-5-1.
//  Copyright StupidTent co 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BoardGameViewController;

@interface BoardGameAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    BoardGameViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet BoardGameViewController *viewController;

@end


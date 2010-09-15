//
//  ProjectProgressViewController.h
//  BoardGame
//
//  Created by Liz on 10-9-15.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteView.h"
@class Player;

@interface ProjectProgressViewController : UIViewController {
	
	IBOutlet UITableView * tableView;
	Player * player;
}

@property (nonatomic,assign) Player * player;

- (void)update;

@end

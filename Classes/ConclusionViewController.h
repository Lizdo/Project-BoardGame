//
//  ConclusionViewController.h
//  BoardGame
//
//  Created by Liz on 10-8-30.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BoardGameViewController;


@interface ConclusionViewController : UIViewController {
	IBOutlet UILabel * firstPlaceName;
	IBOutlet UILabel * firstPlaceScore;
	IBOutlet UILabel * secondPlaceName;
	IBOutlet UILabel * secondPlaceScore;
	IBOutlet UILabel * thirdPlaceName;
	IBOutlet UILabel * thirdPlaceScore;
	IBOutlet UILabel * fourthPlaceName;
	IBOutlet UILabel * fourthPlaceScore;
	
	BoardGameViewController * bgvc;
}

@end

//
//  CurrentPlayerMark.h
//  BoardGame
//
//  Created by Liz on 10-9-3.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeDef.h"


@interface CurrentPlayerMark : UIImageView {

}

- (void)moveToPlayerWithID:(int)playerID withAnim:(BOOL)withAnim;
- (void)movementComplete;

@end

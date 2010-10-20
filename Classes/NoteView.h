//
//  NoteView.h
//
//  Created by Liz on 10-6-30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TypeDef.h"
#import "SoundManager.h"

@interface NoteView : UIView/* Specify a superclass (eg: NSObject or NSView) */ {
	BOOL hasSlidedOut;

}

@property (nonatomic,assign) BOOL hasSlidedOut;

@end

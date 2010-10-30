//
//  TokenPlaceholder.h
//  BoardGame
//
//  Created by Liz on 10-5-14.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Token.h"


@interface TokenPlaceholder : Token {	
	BOOL hasMatch;
	
	Token * matchedToken;
}

@property (nonatomic, assign) BOOL hasMatch;
@property (nonatomic, retain) Token * matchedToken;

+ (id)tokenPlaceholderWithType:(TokenType)aType andPosition:(CGPoint)p;
- (void)reset;
- (void)remove;


@end

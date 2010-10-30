//
//  Tile.h
//  BoardGame
//
//  Created by Liz on 10-5-1.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameVisual.h"
#import "GameLogic.h"
#import "TypeDef.h"
#import "Player.h"
#import "BGPopupController.h"


@interface Tile : BGViewWithPopup <NSCoding>{
	TileType type;
	TileState state;

	int ID;
	BOOL isSpecial;
	BOOL isDisabled;

	ResourceType sourceType;	
	int sourceAmount;
	ResourceType targetType;
	int targetAmount;
	int accumulateRate;
	
	GameLogic * gameLogic;
	
	BOOL amountModifyHightlight;
	
	int tileBackgroundStyle;
		
}

@property (nonatomic, assign) int ID;
@property (nonatomic, assign) TileType type;
@property (nonatomic, assign) TileState state;
@property (nonatomic, assign) BOOL isSpecial;
@property (nonatomic, assign) BOOL isDisabled;

@property (nonatomic, assign) ResourceType sourceType;
@property (nonatomic, assign) int sourceAmount;
@property (nonatomic, assign) ResourceType targetType;
@property (nonatomic, assign) int targetAmount;
@property (nonatomic, assign) int accumulateRate;

- (id)initWithType:(TileType)aType andPosition:(CGPoint)p;
+ (id)tileWithType:(TileType)aType andPosition:(CGPoint)p;

+ (id)tileWithInfo:(int *)tileInfo;
- (void)update;

- (BOOL)availableForPlayer:(Player *)p;
- (void)processForPlayer:(Player *)p;

- (void)triggerEvent:(TokenEvent)e withToken:(Token *)t;

- (void)flipIn;


@end
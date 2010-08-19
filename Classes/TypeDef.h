/*
 *  TypeDef.h
 *  BoardGame
 *
 *  Created by Liz on 10-5-4.
 *  Copyright 2010 StupidTent co. All rights reserved.
 *
 */


#import "UIView+SaveAnimation.m"
 
// Global Switches
#define NoOwner -1
#define SkipMenu 0

#define PrimaryFontName @"Thonburi"
#define PrimaryFont "Thonburi"

#define TileBackgroundStyleCount 3
#define TilePositionRandomness 5

// Times
#define MoveAnimationTime 0.5
#define WaitTime 0.5
#define RumbleWaitTime 30
#define HighlightTime 0.4

#define RumbleTime 20.0
#define SlideOutTime 0.5


// Size & Position
#define TokenSize 22.5	//Radius

//	Info
#define InfoWidth 568
#define InfoHeight 200

//	RumbleInfo
#define RumbleInfoWidth 568
#define RumbleInfoHeight 200

#define RandomPositionInterval 40
#define RandomPositionBoundWidth 200

//	Tiles
//		Tile Starting Position/Spacing/Tilted Position

//	Board
//		Tile Area, Rumble Random Token Area

#define PI 3.1415


typedef enum{
	RoundStateInit,
	RoundStateNormal,
	RoundStateRumble,	
	RoundStateConclusion,
}RoundState;

typedef enum{
	ResourceTypeRound,
	ResourceTypeRect,
	ResourceTypeSquare,
}ResourceType;

typedef enum{
	TileTypeGetResource, //Resource
	TileTypeExchangeResource, //Source Resource, Target Resource
	TileTypeAccumulateResource, //Resource Type, accumulated resource
	TileTypeBuild, //No parameter
	TileTypeLucky, //No parameter
}TileType;

typedef enum{
	TileStateSelected,
	TileStateAvailable,
	TileStateDisabled,
	TileStateRejected,	
	TileStateHidden,
}TileState;

typedef enum{
	TokenTypePlayer = 0,
	TokenTypeRound = 1,
	TokenTypeRect = 2,
	TokenTypeSquare = 3,
	TokenTypeUnknown= 4,
}TokenType;

typedef enum{
	TokenEventPickedUp,
	TokenEventHover,
	TokenEventDroppedDown
}TokenEvent;

typedef enum{
	RumbleTargetTypeRobot = 0,
	RumbleTargetTypeSnake = 1,
	RumbleTargetTypePalace = 2,	
}RumbleTargetType;













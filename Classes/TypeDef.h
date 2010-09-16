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

#define DebugMode 0

// Times
#if DebugMode

#define MoveAnimationTime 0.1
#define WaitTime 0.2
#define RumbleWaitTime 2
#define HighlightTime 0.4

#define RumbleTime 5.0
#define SlideOutTime 0.5
#define ZoomOutTime 0.1

#else

#define MoveAnimationTime 0.5
#define WaitTime 0.5
#define RumbleWaitTime 2
#define HighlightTime 0.4

#define RumbleTime 30.0
#define SlideOutTime 0.5
#define ZoomOutTime 0.5

#endif


// Size & Position
#define TokenSize 22.5	//Radius
#define BadgeSize 30
#define BadgeInterval 10


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
#define TileStartingX 200
#define TileStartingY 200
#define TileWidth 123
#define TileHeight 105
#define TileInterval 2
#define TileBackgroundStyleCount 3
#define TilePositionRandomness 0  //5

//	Board
//		Tile Area, Rumble Random Token Area

#define PI 3.1415

#define ZoomOutScale 0.8
#define ZoomOutInterval 20
#define PanDistance 1000

#define CurrentPlayerMarkOffset CGSizeMake(-100, 0)

//  Popup
#define PopupWidth 200
#define PopupHeight 75


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

#define NumberOfTokenTypes 3

extern const int TokenScoreModifier[NumberOfTokenTypes];

typedef enum{
	TokenTypeRound = 0,
	TokenTypeRect = 1,
	TokenTypeSquare = 2,
	TokenTypePlayer = 3,	
}TokenType;


typedef enum{
	TokenEventPickedUp,
	TokenEventHover,
	TokenEventDroppedDown
}TokenEvent;

#define NumberOfRumbleTargetTypes 3

extern const int RumbleTargetScoreModifier[NumberOfTokenTypes];


typedef enum{
	RumbleTargetTypeRobot = 0,
	RumbleTargetTypeSnake = 1,
	RumbleTargetTypePalace = 2,	
}RumbleTargetType;

typedef enum{
	BadgeTypeMostRound,
	BadgeTypeMostRect,
	BadgeTypeMostSquare,
	BadgeTypeMostRobot,
	BadgeTypeMostSnake,
	BadgeTypeMostPalace,
	BadgeTypeEnoughRound,
	BadgeTypeEnoughRect,
	BadgeTypeEnoughSquare,	
}BadgeType;











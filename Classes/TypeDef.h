/*
 *  TypeDef.h
 *  BoardGame
 *
 *  Created by Liz on 10-5-4.
 *  Copyright 2010 StupidTent co. All rights reserved.
 *
 */


#import "UIView+SaveAnimation.m"
#import "NSArray+RandomObject.m"

#pragma mark - 
#pragma mark Debug Switches
//Flags for debugging purpose

#define NoOwner -1
#define SkipTutorial 0
#define TileTouchSelection 1
#define DebugMode 0

#pragma mark -
#pragma mark Static Const

//Fonts
#define PrimaryFontName @"Palatino-Roman"
#define PrimaryFont "Palatino-Roman"

#define SecondaryFontName @"Thonburi"
#define SecondaryFont "Thonburi"

// Times
#if DebugMode

#define MoveAnimationTime 0.1
#define WaitTime 0.2
#define RumbleWaitTime 1
#define RumbleWaitSwapTime 0.3
#define HighlightTime 0.4

#define DefaultRumbleTime 5.0
#define SlideOutTime 0.5
#define ZoomOutTime 0.1

// Round Intro Time
#define RoundIntroFadeTime 0.2
#define RoundIntroOnScreenTime 1.0

#else

#define MoveAnimationTime 0.5
#define WaitTime 0.5
#define RumbleWaitTime 1
#define RumbleWaitSwapTime 0.3
#define HighlightTime 0.4

#define DefaultRumbleTime 30.0
#define SlideOutTime 0.5
#define ZoomOutTime 0.5

// Round Intro Time
#define RoundIntroFadeTime 1.2
#define RoundIntroOnScreenTime 2.0

#endif

#define TurnWaitTime WaitTime * 4
#define TokenSpawnInterval 0.2

// Size & Position
#define TokenSize 25	//Radius
#define TokenZoomOutScale 1.3
#define PlayerTokenSize 50
#define BadgeSize 30
#define BadgeInterval 5
#define NoteViewWidth 314
#define NoteViewHeight 200
#define NoteViewOffset 160

//	Info
#define InfoWidth 568
#define InfoHeight 200

//	RumbleInfo
#define RumbleInfoWidth 700
#define RumbleInfoHeight 250
#define RumbleInfoOffset 20

#define RandomPositionInterval 50
#define RandomPositionBoundWidth (RumbleInfoWidth - RumbleTargetWidth) / 2 + RumbleInfoOffset

//	RumbleTarget
#define RumbleTargetWidth 200
#define RumbleTargetHeight 250
#define RumbleTargetZoomOutRatio 0.6
#define RumbleTargetZoomOutInverval 10
#define RumbleTargetZoomOutRows 2

//	Tiles
//		Tile Starting Position/Spacing/Tilted Position
#define TileStartingX 200
#define TileStartingY 200
#define TileWidth 123
#define TileHeight 100//105
#define TileInterval 1
#define TileBackgroundStyleCount 3
#define TilePositionRandomness 0  //5

#define BoardTokenOffset  CGSizeMake(-150, -60)
#define BoardTokenInterval 10
#define BoardTokenLockedOffset TokenSize * 2

#define OffBoardPosition CGPointMake(1200, 1200)

//	Board
//		Tile Area, Rumble Random Token Area

#define PI 3.1415

#define ZoomOutScale 0.8
#define ZoomOutInterval 20
#define PanDistance 1000

#define CurrentPlayerMarkOffset CGSizeMake(250, -70)

//  Popup
#define PopupWidth 200
#define PopupHeight 75


#define NoteViewBackgroundColor 0xF2F2F2


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
	TileTypeOvertime,
	TileTypeOutsourcing,
	TileTypeAnnualParty,	
}TileType;

typedef enum{
	TileStateSelected,
	TileStateAvailable,
	TileStateDisabled,
	TileStateRejected,	
	TileStateHidden,
}TileState;

#define NumberOfTokenTypes 3
#define NumberOfRumbleTargetTypes 6

extern const int TokenScoreModifier[NumberOfTokenTypes];
extern const int EnoughResource[NumberOfTokenTypes];

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

extern const int RumbleTargetScoreModifier[NumberOfRumbleTargetTypes];


typedef enum{
	RumbleTargetTypeSignal,
	RumbleTargetTypeCart,	
	RumbleTargetTypeSnake,	
	RumbleTargetTypeRobot,
	RumbleTargetTypePalace,
	RumbleTargetTypeTank,
}RumbleTargetType;

#define NumberOfBadgeTypes 13


// -- Badge Design --
//  Most Resource
//  Enough Resource
//  1st Builder
//  1/3/5/7 Builds
//  Fast Builder (Build more than 1 per turn)

typedef enum{
	BadgeTypeMostRound = 0,
	BadgeTypeMostRect = 1,
	BadgeTypeMostSquare = 2,

	BadgeTypeEnoughRound = 20,
	BadgeTypeEnoughRect = 21,
	BadgeTypeEnoughSquare = 22,
	
	BadgeTypeFirstBuilder = 50,
	BadgeTypeFastBuilder = 51,
	BadgeTypeAllProjects = 52,	
	
	BadgeTypeOneProject = 60,
	BadgeTypeThreeProjects = 61,	
	BadgeTypeFiveProjects = 62,
	BadgeTypeSevenProjects = 63,
	
}BadgeType;

extern const int BadgeTypes[NumberOfBadgeTypes];
extern const int ExclusiveBadgeTypes[NumberOfBadgeTypes];
extern const int PermanentBadgeTypes[NumberOfBadgeTypes];

typedef enum{
	MoveFlagPlayerNormal,
	MoveFlagPlayerRumble,
	MoveFlagAINormal,
	MoveFlagAIRumble,
	MoveFlagEnterTurn,
}MoveFlag;

void CGContextDrawImageInverted(CGContextRef c, CGRect r, CGImageRef image);









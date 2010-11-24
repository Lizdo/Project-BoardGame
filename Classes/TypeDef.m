//
//  TypeDef.m
//  BoardGame
//
//  Created by Liz on 10-9-8.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "TypeDef.h"

const int TokenScoreModifier[NumberOfTokenTypes]={1,3,5};

const int RumbleTargetScoreModifier[NumberOfRumbleTargetTypes]={5,5,9,9,17,17};

const int BadgeTypes[NumberOfBadgeTypes] = {
	BadgeTypeMostRound,
	BadgeTypeMostRect,
	BadgeTypeMostSquare,
	
	BadgeTypeEnoughRound,
	BadgeTypeEnoughRect,
	BadgeTypeEnoughSquare,

	BadgeTypeFirstBuilder,
	BadgeTypeFastBuilder,
	BadgeTypeAllProjects,
	
	BadgeTypeOneProject,
	BadgeTypeThreeProjects,	
	BadgeTypeFiveProjects,
	BadgeTypeSevenProjects,
};

const int ExclusiveBadgeTypes[NumberOfBadgeTypes] = {
	-1,
	-1,
	-1,
	
	-1,
	-1,
	-1,	
	
	BadgeTypeFirstBuilder,
	-1,
	-1,
	
	-1,
	-1,
	-1,	
	-1,
	
};

const int PermanentBadgeTypes[NumberOfBadgeTypes] = {
	-1,
	-1,
	-1,
	
	-1,
	-1,
	-1,
	
	BadgeTypeFirstBuilder,
	BadgeTypeFastBuilder,
	-1,
	
	-1,
	-1,
	-1,	
	-1,
};

const int EnoughResource[NumberOfTokenTypes]={10,10,10};

void CGContextDrawImageInverted(CGContextRef c, CGRect r, CGImageRef image){
	CGContextSaveGState(c);
	CGContextScaleCTM(c, 1, -1);
	r.size.height *= -1;
	r.origin.y *= -1;
	CGContextDrawImage(c, r, image);
	r.size.height *= -1;
	r.origin.y *= -1;
	CGContextRestoreGState(c);
	
}

BOOL isGameCenterAvailable()
{
    // Check for presence of GKLocalPlayer API.
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
	
    // The device must be running running iOS 4.1 or later.
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
	
    return (gcClass && osVersionSupported);
}




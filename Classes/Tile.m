//
//  Tile.m
//  BoardGame
//
//  Created by Liz on 10-5-1.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "Tile.h"
#import "GameLogic.h"
#import "Board.h"

@interface Tile (Private)
//- (void)initPlayers;
- (void)highlightComplete;
@end

@implementation Tile

@synthesize ID,type,state,sourceType,sourceAmount,targetType,targetAmount,accumulateRate,isSpecial,isDisabled;



- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		gameLogic = [GameLogic sharedInstance];
		amountModifyHightlight = NO;
		tileBackgroundStyle = rand()%TileBackgroundStyleCount;
		self.backgroundColor = [UIColor clearColor];
		self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin
		|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
		
    }
    return self;
}


- (void)setTargetAmount:(int)newAmount{
	targetAmount = newAmount;
	//timed highlight
	if (newAmount != 0) {
		amountModifyHightlight = YES;
		[self performSelector:@selector(highlightComplete) withObject:self afterDelay:HighlightTime];
		[self setNeedsDisplay];
	}

}

- (void)highlightComplete{
	amountModifyHightlight = NO;
	[self setNeedsDisplay];
}


- (void)setState:(TileState)newState{
	state = newState;
	//self.backgroundColor = [GameVisual tileColorForState:state andStyle:tileBackgroundStyle];
	[self setNeedsDisplay];
}


+ (id)tileWithType:(TileType)aType andPosition:(CGPoint)p{
	Tile * t = [[Tile alloc ]initWithType:aType andPosition:p];
	return [t autorelease];
}

//Info:
//  [Type, x, y, sourceType, sourceAmount, targetType, targetAmount, accumulateRate]
+ (id)tileWithInfo:(int *)tileInfo{
	Tile * t = [Tile tileWithType:tileInfo[0] andPosition:CGPointMake(tileInfo[1], tileInfo[2])];
	t.sourceType = tileInfo[3];
	t.sourceAmount = tileInfo[4];
	t.targetType = tileInfo[5];
	t.targetAmount = tileInfo[6];
	t.accumulateRate = tileInfo[7];
	return t;
}

- (id)initWithType:(TileType)aType andPosition:(CGPoint)p{
	int sizeX = 61;
	int sizeY = 52;
	CGRect r = CGRectMake(p.x - sizeX, p.y - sizeY, sizeX*2, sizeY*2);

	if (self = [self initWithFrame:r]) {
		self.type = aType;
		self.state = TileStateAvailable;
		self.center = [gameLogic convertedPoint:p];
	}
	return self;

}
- (void)update{
	if (type == TileTypeAccumulateResource) {
		self.targetAmount += accumulateRate;
	}
}

//120 * 100
- (void)drawRect:(CGRect)rect {
	//[super drawRect:rect];
	CGContextRef c = UIGraphicsGetCurrentContext();

	if (state == TileStateHidden) {
		//draw a rect and a symbol instead
	}else {
		//draw background
		CGRect r = self.bounds;
		UIImage * uiImage = [GameVisual tileImageForState:state andStyle:tileBackgroundStyle];
		if (uiImage != nil) {
			CGImageRef image = uiImage.CGImage;
			CGContextDrawImageInverted(c,r,image);		
		}
		
		int margin = 15;
		int mediumSize = 40;
		int smallSize = 30;
		int arrowSize = 20;
		
		int width = self.bounds.size.width;
		int height = self.bounds.size.height;	
		
		switch (type){
			case TileTypeAccumulateResource:
			{
				//Symbol
				CGRect r = CGRectMake(margin, (height - mediumSize)/2, mediumSize, mediumSize);
				CGImageRef image = [GameVisual imageForResourceType:targetType].CGImage;
				CGContextDrawImageInverted(c,r,image);
				
				CGContextSetFillColorWithColor(c, [UIColor grayColor].CGColor);
				//Accumulate
				char buffer[50] = "Pool";
				CGContextSetTextMatrix(c, CGAffineTransformMakeScale(1.0, -1.0));
				CGContextSetTextDrawingMode(c, kCGTextFill);			
				//sprintf(buffer, "%d", accumulateRate);
				CGContextSelectFont(c, SecondaryFont, 25.0, kCGEncodingMacRoman);
				CGContextShowTextAtPoint(c, width-margin-50, height/2+5, buffer, strlen(buffer));
				
				if (amountModifyHightlight) {
					CGContextSetFillColorWithColor(c, [UIColor whiteColor].CGColor);
				}
				
				char buffer2[] = "x";
				CGContextSelectFont(c, SecondaryFont, 20.0, kCGEncodingMacRoman);
				CGContextShowTextAtPoint(c, width/2+10, height/4*3 + 5, buffer2, strlen(buffer2));	

				CGContextSelectFont(c, SecondaryFont, 30.0, kCGEncodingMacRoman);
				sprintf(buffer, "%d", targetAmount);
				CGContextShowTextAtPoint(c, width-margin-20, height/4*3 + 10, buffer, strlen(buffer));	
				break;
			}
			case TileTypeBuild:
			{
				CGContextSetFillColorWithColor(c, [UIColor grayColor].CGColor);
				char buffer[50] = "Build";
				CGContextSelectFont(c, SecondaryFont, 30.0, kCGEncodingMacRoman);
				CGContextSetTextMatrix(c, CGAffineTransformMakeScale(1.0, -1.0));
				CGContextSetTextDrawingMode(c, kCGTextFill);
				CGContextShowTextAtPoint(c, margin, height/2+7, buffer, strlen(buffer));
				break;			
			}
			case TileTypeExchangeResource:{
				//Symbol 1
				CGRect r = CGRectMake(margin, margin, smallSize, smallSize);
				CGImageRef image = [GameVisual imageForResourceType:sourceType].CGImage;
				CGContextDrawImageInverted(c,r,image);
				
				//Symbol 2
				r = CGRectMake(margin, height - margin - smallSize, smallSize, smallSize);
				image = [GameVisual imageForResourceType:targetType].CGImage;
				CGContextDrawImageInverted(c,r,image);			
				
				//To Symbol
				r = CGRectMake((width-arrowSize)/2, (height - arrowSize)/2, arrowSize, arrowSize);
				image = [UIImage imageNamed:@"Arrow.png"].CGImage;
				//rotate the arrow
				CGContextDrawImageInverted(c,r,image);	
				
				CGContextSetFillColorWithColor(c, [UIColor grayColor].CGColor);
				CGContextSetTextMatrix(c, CGAffineTransformMakeScale(1.0, -1.0));
				CGContextSetTextDrawingMode(c, kCGTextFill);
				
				//x1.x2
				char buffer[50] = "x";
				CGContextSelectFont(c, SecondaryFont, 30.0, kCGEncodingMacRoman);
				
				CGContextShowTextAtPoint(c, width/2-10, height/4 + 10, buffer, strlen(buffer));
				CGContextShowTextAtPoint(c, width/2-10, height/4*3 + 5, buffer, strlen(buffer));	
				
				CGContextSelectFont(c, SecondaryFont, 40.0, kCGEncodingMacRoman);
				
				//amount
				sprintf(buffer, "%d", sourceAmount);
				CGContextShowTextAtPoint(c, width-margin-30, height/4 + 15, buffer, strlen(buffer));
				sprintf(buffer, "%d", targetAmount);
				CGContextShowTextAtPoint(c, width-margin-30, height/4*3 + 10, buffer, strlen(buffer));			
				break;
				
			}
			case TileTypeGetResource:
			{
				//Symbol
				CGRect r = CGRectMake(margin, (height - mediumSize)/2, mediumSize, mediumSize);
				CGImageRef image = [GameVisual imageForResourceType:targetType].CGImage;
				CGContextDrawImageInverted(c,r,image);
				
				CGContextSetFillColorWithColor(c, [UIColor grayColor].CGColor);
				//Accumulate
				char buffer[50] = "x";
				CGContextSelectFont(c, SecondaryFont, 30.0, kCGEncodingMacRoman);
				CGContextSetTextMatrix(c, CGAffineTransformMakeScale(1.0, -1.0));
				CGContextSetTextDrawingMode(c, kCGTextFill);
				CGContextShowTextAtPoint(c, width/2-5, height/2+7, buffer, strlen(buffer));
				
				sprintf(buffer, "%d", targetAmount);
				CGContextSelectFont(c, SecondaryFont, 40.0, kCGEncodingMacRoman);
				CGContextShowTextAtPoint(c, width-margin-30, height/2+10, buffer, strlen(buffer));		
				break;
				
			}
			case TileTypeLucky:
			{
				CGContextSetFillColorWithColor(c, [UIColor grayColor].CGColor);
				char buffer[50] = "Lucky";
				CGContextSelectFont(c, SecondaryFont, 20.0, kCGEncodingMacRoman);
				CGContextSetTextMatrix(c, CGAffineTransformMakeScale(1.0, -1.0));
				CGContextSetTextDrawingMode(c, kCGTextFill);
				CGContextShowTextAtPoint(c, margin, height/2+7, buffer, strlen(buffer));
				break;
			}
			case TileTypeAnnualParty:
			{
				CGContextSetFillColorWithColor(c, [UIColor grayColor].CGColor);
				char buffer[50] = "Annual Party";
				CGContextSelectFont(c, SecondaryFont, 18.0, kCGEncodingMacRoman);
				CGContextSetTextMatrix(c, CGAffineTransformMakeScale(1.0, -1.0));
				CGContextSetTextDrawingMode(c, kCGTextFill);
				CGContextShowTextAtPoint(c, margin, height/2+7, buffer, strlen(buffer));
				break;
			}
			case TileTypeOutsourcing:
			{
				CGContextSetFillColorWithColor(c, [UIColor grayColor].CGColor);
				char buffer[50] = "Outsourcing";
				CGContextSelectFont(c, SecondaryFont, 20.0, kCGEncodingMacRoman);
				CGContextSetTextMatrix(c, CGAffineTransformMakeScale(1.0, -1.0));
				CGContextSetTextDrawingMode(c, kCGTextFill);
				CGContextShowTextAtPoint(c, margin, height/2+7, buffer, strlen(buffer));
				break;
			}
			case TileTypeOvertime:
			{
				CGContextSetFillColorWithColor(c, [UIColor grayColor].CGColor);
				char buffer[50] = "Overtime";
				CGContextSelectFont(c, SecondaryFont, 20.0, kCGEncodingMacRoman);
				CGContextSetTextMatrix(c, CGAffineTransformMakeScale(1.0, -1.0));
				CGContextSetTextDrawingMode(c, kCGTextFill);
				CGContextShowTextAtPoint(c, margin, height/2+7, buffer, strlen(buffer));
				break;
			}						
			default:
				break;
		}			
	}



}


- (BOOL)availableForPlayer:(Player *)p{
	if (type == TileTypeExchangeResource){
		if ([p amountOfResource:sourceType] < sourceAmount)
			//not enough resource to exchange
			return NO;
	}
	return YES;
}

- (void)processForPlayer:(Player *)p{
	switch (type) {
		case TileTypeBuild:
			break;
		case TileTypeLucky:
			break;
		case TileTypeGetResource:
			[p modifyResource:targetType by:targetAmount];
			break;
		case TileTypeExchangeResource:
			[p modifyResource:targetType by:targetAmount];
			[p modifyResource:sourceType by:sourceAmount * -1];
			break;
		case TileTypeAccumulateResource:
			[p modifyResource:targetType by:targetAmount];
			self.targetAmount = 0;
			break;
		default:
			break;
	}
}

- (void)triggerEvent:(TokenEvent)e withToken:(Token *)t{
	//TODO: Put tile state management here
}



- (void)flipIn{
	[[SoundManager sharedInstance] playSoundWithTag:SoundTagPaperFly];
	CGPoint originalCenter = self.center;
	[self.superview bringSubviewToFront:self];
	self.center = CGPointMake(1000, 1000);
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:SlideOutTime];
	self.center = originalCenter;
	[UIView commitAnimations];
	
}

- (void)handleTap{
	if (self.state == TileStateHidden) {
		return;
	}
	[super handleTap];
}


- (Player *)player{
	return [gameLogic playerWithID:0];
}


//typedef enum{
//	TileTypeGetResource, //Resource
//	TileTypeExchangeResource, //Source Resource, Target Resource
//	TileTypeAccumulateResource, //Resource Type, accumulated resource
//	TileTypeBuild, //No parameter
//	TileTypeLucky, //No parameter
//	TileTypeOvertime,
//	TileTypeOutsourcing,
//	TileTypeAnnualParty,	
//}TileType;

- (NSString *)title{
	switch (type) {
		case TileTypeGetResource:
			return @"Grab Some People!";
			break;
		case TileTypeExchangeResource:
			return @"Let's Talk in Private";
			break;
		case TileTypeAccumulateResource:
			return @"HR Resource Pool";
			break;			
		case TileTypeBuild:
			return @"It's Overtime";
			break;
		case TileTypeLucky:
			return @"Try Your Luck?";
			break;
		case TileTypeOvertime:
			return @"Crunch Time";
			break;
		case TileTypeOutsourcing:
			return @"We've Got Some Extra Hands";
			break;
		case TileTypeAnnualParty:
			return @"It's Party Time!";
			break;			
		default:
			break;
	}
	return @"";
}


- (NSString *)description{
	switch (type) {
		case TileTypeGetResource:
			return [NSString stringWithFormat:@"Get %d %@.",
					targetAmount,
					[GameLogic descriptionForResourceType:targetType]];
			break;
		case TileTypeExchangeResource:
			return [NSString stringWithFormat:@"Exchange %d %@ for %d %@.",
					sourceAmount,
					[GameLogic descriptionForResourceType:sourceType],
					targetAmount,
					[GameLogic descriptionForResourceType:targetType]];
			break;
		case TileTypeAccumulateResource:
			return [NSString stringWithFormat:@"Get %d %@, increasing over time.",
					targetAmount,
					[GameLogic descriptionForResourceType:targetType]];;
			break;			
		case TileTypeBuild:
			return @"Extra project oppotunity, just for you.";
			break;
		case TileTypeLucky:
			return @"Check if you're blessed.";
			break;
		case TileTypeOvertime:
			return @"Extra time for project build this turn.";
			break;
		case TileTypeOutsourcing:
			return @"More temp guys joining this turn.";
			break;
		case TileTypeAnnualParty:
			return @"Skip all production, once a year.";
			break;			
		default:
			break;
	}
	return @"";}


- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark Serialization

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
	
    [coder encodeInt:type forKey:@"type"];
    [coder encodeInt:state forKey:@"state"];
	
    [coder encodeInt:ID forKey:@"ID"];
	[coder encodeBool:isSpecial forKey:@"isSpecial"];
	[coder encodeBool:isDisabled forKey:@"isDisabled"];
	
    [coder encodeInt:sourceType forKey:@"sourceType"];
    [coder encodeInt:sourceAmount forKey:@"sourceAmount"];	
    [coder encodeInt:targetType forKey:@"targetType"];
    [coder encodeInt:targetAmount forKey:@"targetAmount"];
    [coder encodeInt:accumulateRate forKey:@"accumulateRate"];	
	
    [coder encodeBool:amountModifyHightlight forKey:@"amountModifyHightlight"];
    [coder encodeInt:tileBackgroundStyle forKey:@"tileBackgroundStyle"];	
	
}


- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
	
    type = [coder decodeIntForKey:@"type"];
    state = [coder decodeIntForKey:@"state"];
	
    isSpecial = [coder decodeBoolForKey:@"isSpecial"];
    isDisabled = [coder decodeBoolForKey:@"isDisabled"];
	
    ID = [coder decodeIntForKey:@"ID"];
	
    sourceType = [coder decodeIntForKey:@"sourceType"];
    sourceAmount = [coder decodeIntForKey:@"sourceAmount"];
    targetType = [coder decodeIntForKey:@"targetType"];
    targetAmount = [coder decodeIntForKey:@"targetAmount"];
    accumulateRate = [coder decodeIntForKey:@"accumulateRate"];
	
    amountModifyHightlight = [coder decodeBoolForKey:@"amountModifyHightlight"];	
    tileBackgroundStyle = [coder decodeIntForKey:@"tileBackgroundStyle"];	
	
	//additional inits
	gameLogic = [GameLogic sharedInstance];
	
	[[Board sharedInstance] addView:self];
	//[gameLogic.tiles addObject:self];
	
    return self;
}

@end

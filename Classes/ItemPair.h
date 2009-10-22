//
//  ItemPair.h
//  Rama Blocks
//
//  Created by Ryan McGarvey on 7/29/09.
//  Copyright 2009 Simplical. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "GameItem.h"
#import "GlobalDefines.h"
#import "DrawingView.h"


@interface ItemPair : NSObject {
@public;
    GameItem * ItemA;
	GameItem * ItemB;
	GameItem * ItemC;
	
	DrawingView *drawingView;
    
    UIImageView * ShaddowA;
    UIImageView * ShaddowB;
    
	int Orientation;
	
	CGPoint distanceToItemA;
	CGPoint distanceToItemB;
	CGPoint distanceToItemC;
	
	
	
}



@property (readwrite, retain) GameItem * ItemA;
@property (readwrite, retain) GameItem * ItemB;
@property (readwrite, retain) GameItem * ItemC;
@property (readwrite, assign) DrawingView *drawingView;
@property (readwrite, assign) UIImageView * ShaddowA;
@property (readwrite, assign) UIImageView * ShaddowB;
@property int Orientation;

-(void)Reset;
- (void)rotate:(GameItem *)touched;
-(void)setShadow:(CGPoint)ShaddowALoc:(CGPoint)ShaddowBLoc;
- (BOOL)checkBounds;

-(BOOL)IsInGrid;

-(CGPoint)moveObjectDistance:(CGPoint)touch from:(CGPoint)center;
-(void)airMove:(CGPoint)location;

@end

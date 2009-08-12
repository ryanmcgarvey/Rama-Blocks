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

@interface ItemPair : NSObject {
@public;
    GameItem * ItemA;
	GameItem * ItemB;
    
    UIImageView * ShaddowA;
    UIImageView * ShaddowB;
    
    UIImageView * GrabberA;
    UIImageView * GrabberB;
	int Orientation;
}

@property (readwrite, retain) GameItem * ItemA;
@property (readwrite, retain) GameItem * ItemB;
@property (readwrite, assign) UIImageView * GrabberA;
@property (readwrite, assign) UIImageView *GrabberB;
@property (readwrite, assign) UIImageView * ShaddowA;
@property (readwrite, assign) UIImageView * ShaddowB;
@property int Orientation;

-(void)Reset;
- (void)rotate:(GameItem *)touched;
- (void)move:(CGPoint)location:(UIImageView *)touched;
-(void)setShadow:(CGPoint)ShaddowALoc:(CGPoint)ShaddowBLoc;
- (BOOL)checkBounds;

-(BOOL)IsInGrid;

@end

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
	int Orientation;
}

@property (readwrite, retain) GameItem * ItemA;
@property (readwrite, retain) GameItem * ItemB;
@property int Orientation;

- (void)rotate:(CGPoint)location :(GameItem *)touched;
- (void)move:(CGPoint)location:(GameItem *)touched;
- (BOOL)checkBounds;

@end

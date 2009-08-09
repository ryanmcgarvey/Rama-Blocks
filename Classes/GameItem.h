//
//  GameItem.h
//  Rama Blocks
//
//  Created by Ryan McGarvey on 7/29/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum enum_ItemType {
    ShapeItem,
    LockShapeItem,
    SpawnItem
} TypeItem;

@interface GameItem : UIView {
@public;
    	UIImageView *ItemView;
    	int tapped;
    	BOOL IsPaired;
    int Row;
	int Column;
}

@property (readwrite, assign) UIImageView * ItemView;
@property int tapped;
@property BOOL IsPaired;
@property int Row;
@property int Column;

-(void)SnapShape:(int)newRow : (int)newColumn;
@end

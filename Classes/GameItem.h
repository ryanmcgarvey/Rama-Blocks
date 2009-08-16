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
    SpawnItem,
	DrawingItem
} TypeItem;

@interface GameItem : UIView {
@public;
		UIImageView *ItemView;
		int tapped;
		BOOL IsPaired;
		BOOL IsAnchored;
    int Row;
	int Column;
}

@property (readwrite, assign) UIImageView * ItemView;
@property int tapped;
@property BOOL IsPaired;
@property BOOL IsAnchored;
@property int Row;
@property int Column;

-(void)SnapShape:(int)newRow : (int)newColumn;
@end

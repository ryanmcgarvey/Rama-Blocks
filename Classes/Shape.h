//
//  Shape.h
//  Rama Blocks
//
//  Created by Ryan McGarvey on 7/29/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Shapes.h"
#import "GameItem.h"
#import "GlobalDefines.h"

@interface Shape : GameItem {
@public;
	ShapeType  shapeType;
	ColorType  colorType;

}

@property ShapeType shapeType;
@property ColorType colorType;



- (id)initWithInfo:(ColorType)cType : (ShapeType) sType : (CGPoint)location;
- (BOOL)ChangeColorAndShape: (ColorType)cType : (ShapeType) sType;
- (BOOL)TransForm;
-(BOOL)Equals:(Shape *)shape;
-(BOOL)IsNeighbor:(Shape *)shape;

@end

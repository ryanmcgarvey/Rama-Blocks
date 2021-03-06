//
//  UIImage+Shapes.h
//  RumbaBlocks
//
//  Created by Johnny Moralez on 7/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum enum_ShapeType {
	Triangle,
	Square,
	Pentagon,
	Hexagon,
	Circle, 
	Vortex,
} ShapeType;


typedef enum enum_ColorType {
	Red,
	Orange,
	Yellow,
	Green,
	Blue,
} ColorType;

@interface UIImage (Shapes)

+ (UIImage *)imageWithColorAndShape:(ColorType)colorType : (ShapeType)shapeType;

@end

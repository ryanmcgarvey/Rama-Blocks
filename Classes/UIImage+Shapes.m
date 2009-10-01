//
//  UIImage+Shapes.m
//  RumbaBlocks
//
//  Created by Johnny Moralez on 7/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UIImage+Shapes.h"


@implementation UIImage (Shapes)

+ (UIImage *)imageWithColorAndShape: (ColorType)colorType : (ShapeType)shapeType{
	
	switch (colorType) {
		case Red:
			switch (shapeType) {
				case Triangle:
					return [UIImage imageNamed:@"redtriangle.png"];
				case Square:
					return [UIImage imageNamed:@"redsquare.png"];
				case Pentagon:
					return [UIImage imageNamed:@"redpentagon.png"];
				case Hexagon:
					return [UIImage imageNamed:@"redhexagon.png"];
				case Circle:
					return [UIImage imageNamed:@"redcircle.png"];
				case Vortex:
					return [UIImage imageNamed:@"redvortex.png"];
				case Block:
					return [UIImage imageNamed:@"block.png"];
				default:
					return nil;
			}
		case Purple:
			switch (shapeType) {
				case Triangle:
					return [UIImage imageNamed:@"purpletriangle.png"];
				case Square:
					return [UIImage imageNamed:@"purplesquare.png"];
				case Pentagon:
					return [UIImage imageNamed:@"purplepentagon.png"];
				case Hexagon:
					return [UIImage imageNamed:@"purplehexagon.png"];
				case Circle:
					return [UIImage imageNamed:@"purplecircle.png"];
				case Vortex:
					return [UIImage imageNamed:@"purplevortex.png"];
				case Block:
					return [UIImage imageNamed:@"block.png"];
				default:
					return nil;
			}
		case Yellow:
			switch (shapeType) {
				case Triangle:
					return [UIImage imageNamed:@"yellowtriangle.png"];
				case Square:
					return [UIImage imageNamed:@"yellowsquare.png"];
				case Pentagon:
					return [UIImage imageNamed:@"yellowpentagon.png"];
				case Hexagon:
					return [UIImage imageNamed:@"yellowhexagon.png"];
				case Circle:
					return [UIImage imageNamed:@"yellowcircle.png"];
				case Vortex:
					return [UIImage imageNamed:@"yellowvortex.png"];
				case Block:
					return [UIImage imageNamed:@"block.png"];
				default:
					return nil;
			}
		case Green:
			switch (shapeType) {
				case Triangle:
					return [UIImage imageNamed:@"greentriangle.png"];
				case Square:
					return [UIImage imageNamed:@"greensquare.png"];
				case Pentagon:
					return [UIImage imageNamed:@"greenpentagon.png"];
				case Hexagon:
					return [UIImage imageNamed:@"greenhexagon.png"];
				case Circle:
					return [UIImage imageNamed:@"greencircle.png"];
				case Vortex:
					return [UIImage imageNamed:@"greenvortex.png"];
				case Block:
					return [UIImage imageNamed:@"block.png"];
				default:
					return nil;
			}
		case Blue:
			switch (shapeType) {
				case Triangle:
					return [UIImage imageNamed:@"bluetriangle.png"];
				case Square:
					return [UIImage imageNamed:@"bluesquare.png"];
				case Pentagon:
					return [UIImage imageNamed:@"bluepentagon.png"];
				case Hexagon:
					return [UIImage imageNamed:@"bluehexagon.png"];
				case Circle:
					return [UIImage imageNamed:@"bluecircle.png"];
				case Vortex:
					return [UIImage imageNamed:@"bluevortex.png"];
				case Block:
					return [UIImage imageNamed:@"block.png"];
				default:
					return nil;
			}
		default:
			return nil;
	}
}

+ (UIImage *)LargeImageWithColorAndShape: (ColorType)colorType : (ShapeType)shapeType{
	
	switch (colorType) {
		case Red:
			switch (shapeType) {
				case Triangle:
					return [UIImage imageNamed:@"redtriangle.png"];
				case Square:
					return [UIImage imageNamed:@"redsquare.png"];
				case Pentagon:
					return [UIImage imageNamed:@"redpentagon.png"];
				case Hexagon:
					return [UIImage imageNamed:@"redhexagon.png"];
				case Circle:
					return [UIImage imageNamed:@"redcircle.png"];
				case Vortex:
					return [UIImage imageNamed:@"redvortex.png"];
				case Block:
					return [UIImage imageNamed:@"block.png"];
				default:
					return nil;
			}
		case Purple:
			switch (shapeType) {
				case Triangle:
					return [UIImage imageNamed:@"purpletriangle.png"];
				case Square:
					return [UIImage imageNamed:@"purplesquare.png"];
				case Pentagon:
					return [UIImage imageNamed:@"purplepentagon.png"];
				case Hexagon:
					return [UIImage imageNamed:@"purplehexagon.png"];
				case Circle:
					return [UIImage imageNamed:@"purplecircle.png"];
				case Vortex:
					return [UIImage imageNamed:@"purplevortex.png"];
				case Block:
					return [UIImage imageNamed:@"block.png"];
				default:
					return nil;
			}
		case Yellow:
			switch (shapeType) {
				case Triangle:
					return [UIImage imageNamed:@"yellowtriangle.png"];
				case Square:
					return [UIImage imageNamed:@"yellowsquare.png"];
				case Pentagon:
					return [UIImage imageNamed:@"yellowpentagon.png"];
				case Hexagon:
					return [UIImage imageNamed:@"yellowhexagon.png"];
				case Circle:
					return [UIImage imageNamed:@"yellowcircle.png"];
				case Vortex:
					return [UIImage imageNamed:@"yellowvortex.png"];
				case Block:
					return [UIImage imageNamed:@"block.png"];
				default:
					return nil;
			}
		case Green:
			switch (shapeType) {
				case Triangle:
					return [UIImage imageNamed:@"greentriangle.png"];
				case Square:
					return [UIImage imageNamed:@"greensquare.png"];
				case Pentagon:
					return [UIImage imageNamed:@"greenpentagon.png"];
				case Hexagon:
					return [UIImage imageNamed:@"greenhexagon.png"];
				case Circle:
					return [UIImage imageNamed:@"greencircle.png"];
				case Vortex:
					return [UIImage imageNamed:@"greenvortex.png"];
				case Block:
					return [UIImage imageNamed:@"block.png"];
				default:
					return nil;
			}
		case Blue:
			switch (shapeType) {
				case Triangle:
					return [UIImage imageNamed:@"bluetriangle.png"];
				case Square:
					return [UIImage imageNamed:@"bluesquare.png"];
				case Pentagon:
					return [UIImage imageNamed:@"bluepentagon.png"];
				case Hexagon:
					return [UIImage imageNamed:@"bluehexagon.png"];
				case Circle:
					return [UIImage imageNamed:@"bluecircle.png"];
				case Vortex:
					return [UIImage imageNamed:@"bluevortex.png"];
				case Block:
					return [UIImage imageNamed:@"block.png"];
				default:
					return nil;
			}
		default:
			return nil;
	}
}


@end

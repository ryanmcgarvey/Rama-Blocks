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
				//case Vortex:
				//	return [UIImage imageNamed:@"RedVortex.jpeg"];					
				default:
					return nil;
			}
		case Orange:
			switch (shapeType) {
				case Triangle:
					return [UIImage imageNamed:@"orangetriangle.png"];
				case Square:
					return [UIImage imageNamed:@"orangesquare.png"];
				case Pentagon:
					return [UIImage imageNamed:@"orangepentagon.png"];
				case Hexagon:
					return [UIImage imageNamed:@"orangehexagon.png"];
				case Circle:
					return [UIImage imageNamed:@"orangecircle.png"];
				//case Vortex:
				//	return [UIImage imageNamed:@"OrangeVortex.jpeg"];
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
				//case Vortex:
				//	return [UIImage imageNamed:@"YellowVortex.jpeg"];
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
				//case Vortex:
				//	return [UIImage imageNamed:@"GreenVortex.jpeg"];
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
				//case Vortex:
				//	return [UIImage imageNamed:@"BlueVortex.jpeg"];
				default:
					return nil;
			}
		default:
			return nil;
	}
}

@end

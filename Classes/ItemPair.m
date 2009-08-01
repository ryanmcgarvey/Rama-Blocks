//
//  ItemPair.m
//  Rama Blocks
//
//  Created by Ryan McGarvey on 7/29/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import "ItemPair.h"


@implementation ItemPair

- (void)rotate:(CGPoint)location :(GameItem *)touched{
    Orientation = ++Orientation % 4;
	[self moveShape:location :touched];
}



- (void)moveShape:(CGPoint)location:(GameItem *)touched{
    GameItem* moving;
	touched.center = location;
	if(touched==ItemA){
		moving = ItemB;
		switch (Orientation) {
			case 0:
				moving.center = CGPointMake(touched.center.x + SHAPE_WIDTH, touched.center.y);
				break;
			case 1:
				moving.center = CGPointMake(touched.center.x, touched.center.y - SHAPE_WIDTH);
				break;
			case 2:
				moving.center = CGPointMake(touched.center.x - SHAPE_WIDTH, touched.center.y);
				break;
			case 3:
				moving.center = CGPointMake(touched.center.x, touched.center.y + SHAPE_WIDTH);
				break;
			default:
				break;
		}
	}
	else{
		moving = ItemA;
		switch (Orientation) {
			case 0:
				moving.center = CGPointMake(touched.center.x - SHAPE_WIDTH, touched.center.y);
				break;
			case 1:
				moving.center = CGPointMake(touched.center.x, touched.center.y + SHAPE_WIDTH);
				break;
			case 2:
				moving.center = CGPointMake(touched.center.x + SHAPE_WIDTH, touched.center.y);
				break;
			case 3:
				moving.center = CGPointMake(touched.center.x, touched.center.y - SHAPE_WIDTH);
				break;
			default:
				break;
		}
	}
    
	[self checkBounds];
}



- (BOOL)checkBounds{
    if( (ItemA.center.x > (GRID_RIGHT_EDGE - (SHAPE_WIDTH/2))) || // Shape A is close to the right edge
	   (ItemB.center.x > (GRID_RIGHT_EDGE - (SHAPE_WIDTH/2))) )  // Shape B is close to the right edge
	{
		switch (Orientation) {
			case 0: // A left of B; B right of A
				ItemA.center = CGPointMake(GRID_RIGHT_EDGE - (SHAPE_WIDTH*1.5), ItemA.center.y);
				ItemB.center = CGPointMake(GRID_RIGHT_EDGE - (SHAPE_WIDTH/2), ItemB.center.y);
				break;
			case 2: // A right of B; B left of A
				ItemA.center = CGPointMake(GRID_RIGHT_EDGE - (SHAPE_WIDTH/2), ItemA.center.y);
				ItemB.center = CGPointMake(GRID_RIGHT_EDGE - (SHAPE_WIDTH*1.5), ItemB.center.y);
				break;
			case 1: // A below B; B above A
			case 3: // A above B; B below A
				ItemA.center = CGPointMake(GRID_RIGHT_EDGE - (SHAPE_WIDTH/2), ItemA.center.y);
				ItemB.center = CGPointMake(ItemA.center.x, ItemB.center.y);
				break;
			default:
				NSLog(@"ERROR: Unknown orientation: %d", Orientation);
				break;
		}
	}
	if( (ItemA.center.x < (GRID_LEFT_EDGE  + (SHAPE_WIDTH/2))) || // Shape A is close to the left edge
       (ItemB.center.x < (GRID_LEFT_EDGE  + (SHAPE_WIDTH/2)))  ) // Shape B is close to the left edge
	{
		switch (Orientation) {
			case 0: // A left of B; B right of A
				ItemA.center = CGPointMake(GRID_LEFT_EDGE + (SHAPE_WIDTH/2), ItemA.center.y);
				ItemB.center = CGPointMake(GRID_LEFT_EDGE + (SHAPE_WIDTH*1.5), ItemB.center.y);
				break;
			case 2: // A right of B; B left of A
				ItemA.center = CGPointMake(GRID_LEFT_EDGE + (SHAPE_WIDTH*1.5), ItemA.center.y);
				ItemB.center = CGPointMake(GRID_LEFT_EDGE + (SHAPE_WIDTH/2), ItemB.center.y);
				break;
			case 1: // A below B; B above A
			case 3: // A above B; B below A
				ItemA.center = CGPointMake(GRID_LEFT_EDGE + (SHAPE_WIDTH/2), ItemA.center.y);
				ItemB.center = CGPointMake(ItemA.center.x, ItemB.center.y);
				break;
			default:
				NSLog(@"ERROR: Unknown orientation: %d", Orientation);
				break;
		}
	}
    return TRUE;
}



@end

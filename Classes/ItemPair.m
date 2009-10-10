//
//  ItemPair.m
//  Rama Blocks
//
//  Created by Ryan McGarvey on 7/29/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import "ItemPair.h"
#import "Rama_BlocksAppDelegate.h"

@implementation ItemPair
@synthesize ItemA, ItemB, ItemC, Orientation;
@synthesize ShaddowA, ShaddowB, drawingView;


-(id)init{


    
    ShaddowA = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, SHAPE_WIDTH, SHAPE_WIDTH)];
    ShaddowB = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, SHAPE_WIDTH, SHAPE_WIDTH)];
	
    
    return self;
}
-(BOOL)IsInGrid{
    return(ItemA.center.y > GRID_Y && ItemB.center.y > GRID_Y);
}


- (void)rotate:(GameItem *)touched{
    Orientation = ++Orientation % 4;
	GameItem * rotating;

	
	rotating = ItemB;
		
	switch (Orientation) 
	{
		case 0:
			rotating.center = CGPointMake(touched.center.x + (SHAPE_WIDTH/2), touched.center.y + (SHAPE_WIDTH/2));
			touched.center = CGPointMake(touched.center.x - (SHAPE_WIDTH/2), touched.center.y + (SHAPE_WIDTH/2));
			break;
		case 1:
			rotating.center = CGPointMake(touched.center.x + (SHAPE_WIDTH/2), touched.center.y - (SHAPE_WIDTH/2));
			touched.center = CGPointMake(touched.center.x + (SHAPE_WIDTH/2), touched.center.y + (SHAPE_WIDTH/2));
			break;
		case 2:
			rotating.center = CGPointMake(touched.center.x - (SHAPE_WIDTH/2), touched.center.y - (SHAPE_WIDTH/2));
			touched.center = CGPointMake(touched.center.x + (SHAPE_WIDTH/2), touched.center.y - (SHAPE_WIDTH/2));
			break;
		case 3:
			rotating.center = CGPointMake(touched.center.x - (SHAPE_WIDTH/2), touched.center.y + (SHAPE_WIDTH/2));
			touched.center = CGPointMake(touched.center.x - (SHAPE_WIDTH/2), touched.center.y - (SHAPE_WIDTH/2));
			break;
		
		default:
			break;
	}


}
                
-(void)Reset{
    Orientation = 0;
}

-(CGPoint)moveObjectDistance:(CGPoint)touch from:(CGPoint)center{
	
	float x = center.x - touch.x;
	float y = center.y - touch.y;
	
	CGPoint distance = CGPointMake(x, y);
	
	return distance;
}

-(void)airMove:(CGPoint)location{
	GameItem * itemA = ItemA;
	GameItem * itemB = ItemB;
	GameItem * itemC = ItemC;
    tempCount++;
	Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if(appDelegate.isMoving == YES){
		distanceToItemA = [self moveObjectDistance: location from: itemA.center];
		distanceToItemB = [self moveObjectDistance: location from: itemB.center];
		appDelegate.isMoving = NO;
		
	}
	itemC.center = CGPointMake((itemA.center.x + itemB.center.x)/2, (itemA.center.y + itemB.center.y)/2);
	itemA.center = CGPointMake(location.x + distanceToItemA.x, location.y + distanceToItemA.y);
	itemB.center = CGPointMake(location.x + distanceToItemB.x, location.y + distanceToItemB.y);
	
	
	[self checkBounds];
    
    NSLog(@"count: %d"), tempCount;

	}
	
-(void)setShadow:(CGPoint)ShaddowALoc:(CGPoint)ShaddowBLoc{
    Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
	if(appDelegate.allowGravity == TRUE){
		ShaddowA.center =  ShaddowALoc;
		ShaddowB.center = ShaddowBLoc;
		ShaddowA.alpha = 0.4f;
		ShaddowB.alpha = 0.4f;
	}
	if(appDelegate.allowGravity == FALSE){
		ShaddowA.center =  ShaddowALoc;
		ShaddowB.center = ShaddowBLoc;
		ShaddowA.alpha = 0.0f;
		ShaddowB.alpha = 0.0f;
	}
        
}

- (BOOL)checkBounds{
    
	if( (ItemA.center.x > (GRID_RIGHT_EDGE - (SHAPE_WIDTH/2))) || // Shape A is close to the right edge
	   (ItemB.center.x > (GRID_RIGHT_EDGE - (SHAPE_WIDTH/2))) || (ItemC.center.x > (GRID_RIGHT_EDGE - 15)) )  // Shape B is close to the right edge
	{
		switch (Orientation) {
			case 0: // A left of B; B right of A
				ItemA.center = CGPointMake(GRID_RIGHT_EDGE - (SHAPE_WIDTH*1.5), ItemA.center.y);
				ItemB.center = CGPointMake(GRID_RIGHT_EDGE - (SHAPE_WIDTH/2), ItemB.center.y);
				ItemC.center = CGPointMake(GRID_RIGHT_EDGE - 30, ItemC.center.y);
				break;
			case 2: // A right of B; B left of A
				ItemA.center = CGPointMake(GRID_RIGHT_EDGE - (SHAPE_WIDTH/2), ItemA.center.y);
				ItemB.center = CGPointMake(GRID_RIGHT_EDGE - (SHAPE_WIDTH*1.5), ItemB.center.y);
				ItemC.center = CGPointMake(GRID_RIGHT_EDGE - 30, ItemC.center.y);
				break;
			case 1: // A below B; B above A
			case 3: // A above B; B below A
				ItemA.center = CGPointMake(GRID_RIGHT_EDGE - (SHAPE_WIDTH/2), ItemA.center.y);
				ItemB.center = CGPointMake(ItemA.center.x, ItemB.center.y);
				ItemC.center = CGPointMake(GRID_RIGHT_EDGE - 30, ItemC.center.y);
				break;
			default:
				NSLog(@"ERROR: Unknown orientation: %d", Orientation);
				break;
		}
	}
	if( (ItemA.center.x < (GRID_LEFT_EDGE  + (SHAPE_WIDTH/2))) || // Shape A is close to the left edge
       (ItemB.center.x < (GRID_LEFT_EDGE  + (SHAPE_WIDTH/2))) || (ItemC.center.x < (GRID_LEFT_EDGE + 15)) ) // Shape B is close to the left edge
	{
		switch (Orientation) {
			case 0: // A left of B; B right of A
				ItemA.center = CGPointMake(GRID_LEFT_EDGE + (SHAPE_WIDTH/2), ItemA.center.y);
				ItemB.center = CGPointMake(GRID_LEFT_EDGE + (SHAPE_WIDTH*1.5), ItemB.center.y);
				ItemC.center = CGPointMake(GRID_LEFT_EDGE + 30, ItemC.center.y);
				break;
			case 2: // A right of B; B left of A
				ItemA.center = CGPointMake(GRID_LEFT_EDGE + (SHAPE_WIDTH*1.5), ItemA.center.y);
				ItemB.center = CGPointMake(GRID_LEFT_EDGE + (SHAPE_WIDTH/2), ItemB.center.y);
				ItemC.center = CGPointMake(GRID_LEFT_EDGE + 30, ItemC.center.y);
				break;
			case 1: // A below B; B above A
			case 3: // A above B; B below A
				ItemA.center = CGPointMake(GRID_LEFT_EDGE + (SHAPE_WIDTH/2), ItemA.center.y);
				ItemB.center = CGPointMake(ItemA.center.x, ItemB.center.y);
				ItemC.center = CGPointMake(GRID_LEFT_EDGE + 30, ItemC.center.y);
				break;
			default:
				NSLog(@"ERROR: Unknown orientation: %d", Orientation);
				break;
		}
	}
    return TRUE;
	 
}

- (void)setItemA:(GameItem *) itemA {
    ItemA = itemA;
    ItemA.IsPaired = TRUE;
    ShaddowA.image = [UIImage imageWithCGImage:[ItemA.ItemView.image CGImage]];
    ShaddowA.alpha = 0.0f;
}

- (void)setItemB:(GameItem *) itemB {
    ItemB = itemB;
    ItemB.IsPaired = TRUE;
    ShaddowB.image = [UIImage imageWithCGImage:[ItemB.ItemView.image CGImage]];
    ShaddowB.alpha = 0.0f;
}
@end

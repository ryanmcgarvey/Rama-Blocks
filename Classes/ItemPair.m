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
@synthesize ItemA, ItemB, ItemC, Orientation, GrabberA, GrabberB;
@synthesize ShaddowA, ShaddowB, drawingView;


-(id)init{

    GrabberA = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, SHAPE_WIDTH, SHAPE_WIDTH)];
    GrabberB = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, SHAPE_WIDTH, SHAPE_WIDTH)];
    GrabberA.image = [UIImage imageNamed:@"HighLight.png"];
    GrabberB.image = [UIImage imageNamed:@"HighLight.png"];
    GrabberA.userInteractionEnabled = TRUE;
    GrabberB.userInteractionEnabled = TRUE;
    
    ShaddowA = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, SHAPE_WIDTH, SHAPE_WIDTH)];
    ShaddowB = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, SHAPE_WIDTH, SHAPE_WIDTH)];
	
    
    return self;
}
-(BOOL)IsInGrid{
    return(ItemA.center.y > GRID_Y && ItemB.center.y > GRID_Y);
}


- (void)rotate:(GameItem *)touched{
    Orientation = ++Orientation % 4;
    CGPoint anchor;
    UIImageView * grabberTouched;
    if(touched == ItemA)
    {
        grabberTouched = GrabberA;
        switch (Orientation) 
        {
            case 2:
                anchor = CGPointMake(touched.center.x + SHAPE_WIDTH, touched.center.y);
                break;
            case 3:
                anchor = CGPointMake(touched.center.x, touched.center.y - SHAPE_WIDTH);
                break;
            case 0:
                anchor = CGPointMake(touched.center.x - SHAPE_WIDTH, touched.center.y);
                break;
            case 1:
               anchor = CGPointMake(touched.center.x, touched.center.y + SHAPE_WIDTH);
                break;
            default:
                break;
        }
    }
    else
    {
        grabberTouched = GrabberB;
        switch (Orientation) 
        {
            case 0:
                anchor = CGPointMake(touched.center.x + SHAPE_WIDTH, touched.center.y);
                break;
            case 1:
                anchor = CGPointMake(touched.center.x, touched.center.y - SHAPE_WIDTH);
                break;
            case 2:
                anchor = CGPointMake(touched.center.x - SHAPE_WIDTH, touched.center.y);
                break;
            case 3:
                anchor = CGPointMake(touched.center.x, touched.center.y + SHAPE_WIDTH);
                break;
            default:
                break;
        }
    }
    [self move:anchor :grabberTouched];
}
                
-(void)Reset{
    Orientation = 0;
    [self move:CGPointMake(SPAWN_LOCATION_X,SPAWN_LOCATION_Y) :GrabberA];
}

-(CGPoint)moveObjectDistance:(CGPoint)touch from:(CGPoint)center{
	
	float x = center.x - touch.x;
	float y = center.y - touch.y;
	
	CGPoint distance = CGPointMake(x, y);
	
	return distance;
}

-(void)airMove:(CGPoint)location{
	UIImageView * grabberA = GrabberA;
	UIImageView * grabberB = GrabberB;
	GameItem * itemA = ItemA;
	GameItem * itemB = ItemB;
	GameItem * itemC = ItemC;
	Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if(appDelegate.isMoving == YES){
		distanceToItemA = [self moveObjectDistance: location from: itemA.center];
		distanceToItemB = [self moveObjectDistance: location from: itemB.center];
		distanceToItemC = [self moveObjectDistance: location from: itemC.center];
		distanceToGrabberA = [self moveObjectDistance:location from:grabberA.center];
		distanceToGrabberB = [self moveObjectDistance: location from: grabberB.center];
		appDelegate.isMoving = NO;
		
	}
	itemA.center = CGPointMake(location.x + distanceToItemA.x, location.y + distanceToItemA.y);
	itemB.center = CGPointMake(location.x + distanceToItemB.x, location.y + distanceToItemB.y);
	itemC.center = CGPointMake(location.x + distanceToItemC.x, location.y + distanceToItemC.y);
	grabberA.center = CGPointMake(location.x + distanceToGrabberA.x, location.y + distanceToGrabberA.y);
	grabberB.center = CGPointMake(location.x + distanceToGrabberB.x, location.y + distanceToGrabberB.y);
	
	[self checkBounds];

	}
	
	
- (void)move:(CGPoint)location:(UIImageView *)grabberTouched{
    GameItem* moving;
    UIImageView * grabberMoving;
    GameItem * touched;
        
    if(grabberTouched==GrabberA){
        grabberTouched.center = location;
        touched = ItemA;
        moving = ItemB;
        grabberMoving = GrabberB;
        switch (Orientation) 
        {
            case 0:
                touched.center = CGPointMake(grabberTouched.center.x + SHAPE_WIDTH, grabberTouched.center.y);
                moving.center = CGPointMake(touched.center.x + SHAPE_WIDTH, touched.center.y);
                grabberMoving.center = CGPointMake(moving.center.x + SHAPE_WIDTH, moving.center.y);
                break;
            case 1:
                touched.center = CGPointMake(grabberTouched.center.x, grabberTouched.center.y - SHAPE_WIDTH);
                moving.center = CGPointMake(touched.center.x, touched.center.y - SHAPE_WIDTH);
                grabberMoving.center = CGPointMake(moving.center.x, moving.center.y - SHAPE_WIDTH);
                break;
            case 2:
                touched.center = CGPointMake(grabberTouched.center.x - SHAPE_WIDTH, grabberTouched.center.y);
                moving.center = CGPointMake(touched.center.x - SHAPE_WIDTH, touched.center.y);
                grabberMoving.center = CGPointMake(moving.center.x - SHAPE_WIDTH, moving.center.y);
                break;
            case 3:
                touched.center = CGPointMake(grabberTouched.center.x, grabberTouched.center.y + SHAPE_WIDTH);
                moving.center = CGPointMake(touched.center.x, touched.center.y + SHAPE_WIDTH);
                grabberMoving.center = CGPointMake(moving.center.x, moving.center.y + SHAPE_WIDTH);
                break;
            default:
                break;
        }
		[self checkBounds];
    }
    else if(grabberTouched == GrabberB)
    {
        grabberTouched.center = location;
        touched = ItemB;
        moving = ItemA;
        grabberMoving = GrabberA;
        switch (Orientation) 
        {
            case 0:
                touched.center = CGPointMake(grabberTouched.center.x - SHAPE_WIDTH, grabberTouched.center.y);
                moving.center = CGPointMake(touched.center.x - SHAPE_WIDTH, touched.center.y);
                grabberMoving.center = CGPointMake(moving.center.x - SHAPE_WIDTH, moving.center.y);
                break;
            case 1:
                touched.center = CGPointMake(grabberTouched.center.x, grabberTouched.center.y + SHAPE_WIDTH);
                moving.center = CGPointMake(touched.center.x, touched.center.y + SHAPE_WIDTH);
                grabberMoving.center = CGPointMake(moving.center.x, moving.center.y + SHAPE_WIDTH);
                break;
            case 2:
                touched.center = CGPointMake(grabberTouched.center.x + SHAPE_WIDTH, grabberTouched.center.y);
                moving.center = CGPointMake(touched.center.x + SHAPE_WIDTH, touched.center.y);
                grabberMoving.center = CGPointMake(moving.center.x + SHAPE_WIDTH, moving.center.y);
                break;
            case 3:
                touched.center = CGPointMake(grabberTouched.center.x, grabberTouched.center.y - SHAPE_WIDTH);
                moving.center = CGPointMake(touched.center.x, touched.center.y - SHAPE_WIDTH);
                grabberMoving.center = CGPointMake(moving.center.x, moving.center.y - SHAPE_WIDTH);
                break;
            default:
                break;
        }
    }
    
    [self checkBounds];
    
}

-(void)setShadow:(CGPoint)ShaddowALoc:(CGPoint)ShaddowBLoc{
    ShaddowA.center =  ShaddowALoc;
    ShaddowB.center = ShaddowBLoc;
    ShaddowA.alpha = 0.4f;
    ShaddowB.alpha = 0.4f;
        
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

- (void)setItemA:(GameItem *) itemA {
    ItemA = itemA;
    ItemA.IsPaired = TRUE;
    ShaddowA.image = [[UIImage imageWithCGImage:[ItemA.ItemView.image CGImage]] retain];
    ShaddowA.alpha = 0.0f;
}

- (void)setItemB:(GameItem *) itemB {
    ItemB = itemB;
    ItemB.IsPaired = TRUE;
    ShaddowB.image = [[UIImage imageWithCGImage:[ItemB.ItemView.image CGImage]] retain];
    ShaddowB.alpha = 0.0f;
}
@end

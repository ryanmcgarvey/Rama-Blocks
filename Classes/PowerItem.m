//
//  PowerItem.m
//  Rama Blocks
//
//  Created by Ryan McGarvey on 7/29/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import "PowerItem.h"
#import "Rama_BlocksAppDelegate.h"


@implementation PowerItem


- (id)init{
   
    return self;
}

- (void)makeCollection:(ItemCollection *)collection{
	itemCollection = collection;

}

-(void)placeAnchor:(GameItem *)item{
	Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSMutableArray * BombArray = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_ROWS * NUMBER_OF_COLUMNS];
	Cell * cell = [itemCollection GetCell:item.Row :item.Column];
	[BombArray addObject:cell];
	appDelegate.isAttaching = YES;
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
	[itemCollection RemoveFromCellsAndRefactor:BombArray];
}

-(void)makeAnchor:(GameItem *)item{
	
	Cell * cell = [itemCollection GetCell:item.Row :item.Column];
	cell.ItemInCell.IsAnchored = YES;
	cell.ItemInCell.ItemView.backgroundColor = [UIColor purpleColor];
	//[itemCollection createNewWithSelf:itemCollection];
	
}

-(void)useBombItem:(GameItem *)item{
	
	NSMutableArray * BombArray = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_ROWS * NUMBER_OF_COLUMNS];
	Cell * cell = [itemCollection GetCell:item.Row :item.Column];
	
	[BombArray addObject:cell];
	Cell * neighbor;
	
	
	neighbor = [itemCollection GetCell:cell.Row + 1 : item.Column];
	Shape * neighborShape = (Shape*)neighbor.ItemInCell;
	if( neighbor.ItemInCell != nil && neighborShape.shapeType != Vortex){
		[BombArray addObject:neighbor];
	}
	neighbor = [itemCollection GetCell:cell.Row - 1 : item.Column];
	neighborShape = (Shape*)neighbor.ItemInCell;
	if( neighbor.ItemInCell != nil && neighborShape.shapeType != Vortex){
		[BombArray addObject:neighbor];
	}
	neighbor = [itemCollection GetCell:cell.Row  : item.Column + 1];
	neighborShape = (Shape*)neighbor.ItemInCell;
	if( neighbor.ItemInCell != nil && neighborShape.shapeType != Vortex){
		[BombArray addObject:neighbor];
	}
	neighbor = [itemCollection GetCell:cell.Row  : item.Column - 1];
	neighborShape = (Shape*)neighbor.ItemInCell;
	if( neighbor.ItemInCell != nil && neighborShape.shapeType != Vortex){
		[BombArray addObject:neighbor];
	}
	neighbor = [itemCollection GetCell:cell.Row + 1 : item.Column + 1];
	neighborShape = (Shape*)neighbor.ItemInCell;
	if( neighbor.ItemInCell != nil && neighborShape.shapeType != Vortex){
		[BombArray addObject:neighbor];
	}
	neighbor = [itemCollection GetCell:cell.Row - 1 : item.Column - 1];
	neighborShape = (Shape*)neighbor.ItemInCell;
	if( neighbor.ItemInCell != nil && neighborShape.shapeType != Vortex){
		[BombArray addObject:neighbor];
	}
	neighbor = [itemCollection GetCell:cell.Row - 1  : item.Column + 1];
	neighborShape = (Shape*)neighbor.ItemInCell;
	if( neighbor.ItemInCell != nil && neighborShape.shapeType != Vortex){
		[BombArray addObject:neighbor];
	}
	neighbor = [itemCollection GetCell:cell.Row + 1  : item.Column - 1];
	neighborShape = (Shape*)neighbor.ItemInCell;
	if( neighbor.ItemInCell != nil && neighborShape.shapeType != Vortex){
		[BombArray addObject:neighbor];
	}
	[itemCollection RemoveFromCellsAndRefactor:BombArray];
	
	
}




- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
}


@end

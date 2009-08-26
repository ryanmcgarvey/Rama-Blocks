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

-(void)stopGravity:(GameItem *)item{
	NSMutableArray * gravityArray = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_ROWS * NUMBER_OF_COLUMNS];
	Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	appDelegate.allowGravity = NO;
	[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(returnGravity) userInfo:nil repeats:NO];
	
	Cell * cell = [itemCollection GetCell:item.Row :item.Column];
	[gravityArray addObject:cell];
	[itemCollection RemoveFromCellsAndRefactor:gravityArray];
	
	[gravityArray release];
	[NSTimer release];
	
	
}

-(void)returnGravity{
	Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	appDelegate.allowGravity = YES;
	
}

-(void)placeFilter:(GameItem *)item{
	Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSMutableArray * filterArray = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_ROWS * NUMBER_OF_COLUMNS];
	Cell * cell = [itemCollection GetCell:item.Row :item.Column];
	
	appDelegate.isFiltering = YES;
	
	[filterArray addObject:cell];
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
	[itemCollection RemoveFromCellsAndRefactor:filterArray];
	
	[filterArray release];
}

-(void)makeFilter:(GameItem *)item{
	
	int row = 0;
	int column = 0;
    
	Shape * shape = (Shape *) item;
	NSMutableArray * filterArray = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_ROWS * NUMBER_OF_COLUMNS];
	
	for (row = 0; row <= NUMBER_OF_ROWS; row++) 
	{
		for (column =0; column <= NUMBER_OF_COLUMNS; column++) 
		{
			Cell *removeCell = [itemCollection GetCell:row :column];
			Shape * shapeToFilter = (Shape *) removeCell.ItemInCell;
			if(shapeToFilter.shapeType == shape.shapeType && shapeToFilter.colorType == shape.colorType){
				[filterArray addObject:removeCell];
				[itemCollection RemoveFromCellsAndRefactor:filterArray];
			}
			
		}
	}
	[filterArray release];
}


-(void)placeAnchor:(GameItem *)item{
	Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSMutableArray * anchorArray = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_ROWS * NUMBER_OF_COLUMNS];
	Cell * cell = [itemCollection GetCell:item.Row :item.Column];
	
	appDelegate.isAttaching = YES;
	
	[anchorArray addObject:cell];
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
	[itemCollection RemoveFromCellsAndRefactor:anchorArray];
	
	[anchorArray release];
}

-(void)makeAnchor:(GameItem *)item{
	
	Cell * cell = [itemCollection GetCell:item.Row :item.Column];
	cell.ItemInCell.IsAnchored = YES;
	cell.ItemInCell.ItemView.backgroundColor = [UIColor purpleColor];
	//[itemCollection createNewWithSelf:itemCollection];
	
}

-(void)placeUpgrader:(GameItem *)item{
	Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSMutableArray * upgradeArray = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_ROWS * NUMBER_OF_COLUMNS];
	Cell * cell = [itemCollection GetCell:item.Row :item.Column];
	
	appDelegate.isUpgrading = YES;
	
	[upgradeArray addObject:cell];
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
	[itemCollection RemoveFromCellsAndRefactor:upgradeArray];
	
	[upgradeArray release];
}

-(void)makeUpgrader:(GameItem *)item{
	
	Cell * cell = [itemCollection GetCell:item.Row :item.Column];
	[itemCollection TransformItem:cell.ItemInCell];
	
	
}

-(void)shuffleBoard:(GameItem *)item{
	
	int row = 0;
	int column = 0;
    
	NSMutableArray * shuffleArray = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_ROWS * NUMBER_OF_COLUMNS];
	NSMutableArray * removeShuffleArray = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_ROWS * NUMBER_OF_COLUMNS];
	Cell * shuffleCell = [itemCollection GetCell:item.Row :item.Column];
	[itemCollection RemoveFromCellsAndRefactor:removeShuffleArray];
	
	removeShuffleArray = nil;
	removeShuffleArray = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_ROWS * NUMBER_OF_COLUMNS];
	
	[removeShuffleArray addObject:shuffleCell];
	for (row = 0; row <= NUMBER_OF_ROWS; row++) {
		for (column =0; column <= NUMBER_OF_COLUMNS; column++) {
			
			Cell *removeCell = [itemCollection GetCell:row :column];
			
			Shape *shuffleShape = (Shape *)removeCell.ItemInCell;
			shuffleShape.IsAnchored = NO;
			if(removeCell.ItemInCell != nil){
				[shuffleArray addObject:removeCell.ItemInCell];
			}
			}
	}
	
	int i,j;
	int numberOfShapes = [shuffleArray count];
	
	for( i = 0; i < numberOfShapes; i++ ){
		j = rand() % numberOfShapes;
		[shuffleArray exchangeObjectAtIndex:i withObjectAtIndex:j];
	}
	
	[itemCollection cleanBoard];
	[itemCollection setShuffledArray:shuffleArray];
	[shuffleArray release];
	[removeShuffleArray release];
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
	
	[BombArray release];
}




- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
}


@end

//
//  ItemCollection.m
//  RumbaBlocks
//
//  Created by Ryan McGarvey on 7/29/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import "ItemCollection.h"


@implementation ItemCollection

-(id)init: (int) rows : (int) columns : (int)rowPixelLength : (int)columnPixelLength{	

	complexity = 0;
	gravityDirection = down;
	RowLength = rows;
	ColumnLength = columns;
	RowPixelLength = rowPixelLength;
	ColumnPixelLength = columnPixelLength;
	cells = malloc((rows * columns)*sizeof(Cell *));
    
	int row = 0;
	int column = 0;
    
	for (row = 0; row < RowLength; row++) 
	{
		for (column =0; column < ColumnLength; column++) 
		{
			float x = (GRID_LEFT_EDGE + (SHAPE_WIDTH / 2)) + (ColumnPixelLength * column);
			float y = (  MAX_Y  - (RowPixelLength * row) - (SHAPE_WIDTH / 2) );
			CGPoint point = CGPointMake( x , y );
			cells[(row * ColumnLength) + column] = [[Cell alloc] initWithData: point : row : column];
		}
	}
	
	return self;
}

/**************************************
 Public
 **************************************/

-(BOOL)AddItemPair: (ItemPair *)itemPair;{

	int rowA; int rowB; int columnA; int columnB;
	Cell * cellA;
	Cell * cellB;
	
	// Which column is each item in
	columnA = (int)(itemPair->ItemA.center.x - GRID_LEFT_EDGE  ) / (int)SHAPE_WIDTH;
	columnB = (int)(itemPair->ItemB.center.x - GRID_LEFT_EDGE ) / (int)SHAPE_WIDTH;
	
	// Which column is each item in
	rowA = (int)(GRID_Y_BOTTOM - itemPair->ItemA.center.y + (SHAPE_WIDTH / 2)) / (int)SHAPE_WIDTH;
	rowB = (int)(GRID_Y_BOTTOM - itemPair->ItemB.center.y + (SHAPE_WIDTH / 2)) / (int)SHAPE_WIDTH;
	if(rowA >= NUMBER_OF_ROWS)
    {
        rowA = NUMBER_OF_ROWS - 1;
    }
    if(rowB >= NUMBER_OF_ROWS)
    {
        rowB = NUMBER_OF_ROWS - 1;
    }
	cellA = [self GetCell:rowA:columnA];
	cellB = [self GetCell:rowB:columnB];
	
	if(cellA == cellB)
    {
		if(itemPair->ItemA.center.y > itemPair->ItemB.center.y)
        {
			cellA = [self GetCell:cellA->Row -1 : cellA->Column];
		}
        else
        {
			cellB = [self GetCell:cellB->Row -1 : cellB->Column];
		}
	}
	if(!([self CheckCellToSet:cellA] && [self CheckCellToSet:cellB]))
    {
		NSLog(@"Collision, unding shit");
		return FALSE;
	}
	
	[self SetItemToCell:itemPair->ItemA :cellA];
	[self SetItemToCell:itemPair->ItemB :cellB];
	
	itemPair->ItemA->IsPaired = FALSE;
	itemPair->ItemB->IsPaired = FALSE;
    [self ApplyGravity];
	return TRUE;
}

-(ShapeType)getComplexity{
	return complexity;
}


/**************************************
 TRANSFORMS
 **************************************/
-(void)TransformItem:(GameItem*)item{
    if([item isKindOfClass: [Shape class]])
    {
        Shape * shape = (Shape *)item;
	NSMutableArray * transFormGroup = [self CheckTransform : item];
    Cell * cell = [self GetCell:item];
	if([transFormGroup count] >= 2){
		[transFormGroup removeObject:cell];
		[self RemoveFromCellsAndRefactor: transFormGroup];

            if(shape->shapeType == Triangle && complexity < 1){
                complexity = 2;
            }
            if(shape->shapeType == Square && complexity < 2){
                complexity = 3;
            }
            if(shape->shapeType == Pentagon && complexity < 3){
                complexity = 4;
            }
            if(shape->shapeType == Hexagon && complexity < 4){
                complexity = 5;
            }	
            [shape TransForm];
            [self CheckTransform:item];
        

	}
	[transFormGroup removeAllObjects];
    [self ApplyGravity];
    }
}
-(void)RemoveFromCellsAndRefactor:(NSMutableArray *)TransFormGroup{
	for(Cell * cell in TransFormGroup){
		//NSLog(@"Removing shape");
		[cell->ItemInCell removeFromSuperview];
		[cell->ItemInCell release];		
        cell->ItemInCell = nil;
		
	}
	[TransFormGroup removeAllObjects];
}

-(NSMutableArray *)CheckTransform:(int)row : (int)column{
    
    NSMutableArray * TransformGroup = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_ROWS * NUMBER_OF_COLUMNS];
	Cell * cell = [self GetCell:row :column];
	if(cell->ItemInCell != nil && ! cell->IsTransforming)
    {
        cell->IsTransforming = TRUE;
        GameItem * item = cell->ItemInCell;
        if([item isKindOfClass:[Shape class]])
        {
            Shape * shape = (Shape * )item;
            Cell * neighbor = nil;
            //Check right
            neighbor = [self GetCell:cell->Row + 1 : cell->Column];
            if(neighbor != nil && !neighbor->IsTransforming && neighbor->ItemInCell != nil && 
               [shape Equals:(Shape *)neighbor->ItemInCell])
            {
                [TransformGroup addObjectsFromArray:[self CheckTransform:neighbor->Row: neighbor->Column]];
            }
            //Check left
            neighbor = [self GetCell:cell->Row - 1 : cell->Column];

            //Check up
            neighbor = [self GetCell:cell->Row  : cell->Column + 1];

            //Check down
            neighbor = [self GetCell:cell->Row  : cell->Column - 1];

            NSLog(@"adding self");
            [TransformGroup addObject:cell];
            cell->IsTransforming = FALSE;
        }
	}
	return TransformGroup;	
	
}




-(NSMutableArray *)CheckTransform:(Shape *)shape{
	return [self CheckTransform:shape->Row : shape->Column];
}



/**************************************
 GRAVITY
 **************************************/


-(void)SetGravity:(Gravity)gravity{
    gravityDirection = gravity;
    [self ApplyGravity];
}

-(void)ApplyGravity{
    int row;int column;
    switch (gravityDirection) {
        case left:
            for(row = 0; row < NUMBER_OF_ROWS; row++)
            {
                for(column = 0; column < NUMBER_OF_COLUMNS; column ++)
                {
                    [self ApplyGravityToCell:[self GetCell:row : column]];
                }
            }
            return;
        case right:
            for(row = 0; row < NUMBER_OF_ROWS; row++)
            {
                for(column = NUMBER_OF_COLUMNS - 1; column >= 0; column --)
                {
                    [self ApplyGravityToCell:[self GetCell:row : column]];
                }
            }
            return;
        case down:
            for(column = 0; column < NUMBER_OF_COLUMNS; column ++)
            {
                for(row = 0; row < NUMBER_OF_ROWS; row++)
                {
                    [self ApplyGravityToCell:[self GetCell:row : column]];
                }
            }
            return;
        case up:
            for(column = 0; column < NUMBER_OF_COLUMNS; column ++)
            {
                for(row = NUMBER_OF_ROWS -1 ; row >= 0; row--)
                {
                    [self ApplyGravityToCell:[self GetCell:row : column]];
                }
            }
            return;
        case zero:
            return;
        default:
            break;
    }
}

-(void)ApplyGravityToCell:(Cell *)cell{
    if(cell->ItemInCell !=nil){
        Cell * cellToMoveTo = [self FindCellToFallTo:cell->ItemInCell];
        if(cellToMoveTo != nil && cellToMoveTo->ItemInCell !=nil){
            return;
        }
        [self SetItemToCell:cell->ItemInCell :cellToMoveTo];
        cell->ItemInCell = nil;
    }
}

-(Cell *)FindCellToFallTo:(GameItem *) item{
    Cell * cell = nil;
    int column;
    int row;
    switch (gravityDirection) {
        case left:
            column = item->Column;
            while(cell != nil &&cell->ItemInCell == nil && column >= 0){
                column--;
                cell = [self GetCell:item->Row : column];
            }
            return [self GetCell:item->Row : column + 1];
        case right:
            column = item->Column;
            while(cell != nil &&cell->ItemInCell == nil && column < NUMBER_OF_COLUMNS){
                column++;
                cell = [self GetCell:item->Row : column];
            }
            return [self GetCell:item->Row : column - 1];            
        case down:
            row = item->Row;
            while(cell != nil && cell->ItemInCell == nil && row >= 0){
                row--;
                cell = [self GetCell:row : item->Column];
            }
            cell = [self GetCell:row +1 : item->Column];
            return cell;
        case up:
            row = item->Row;
            while(cell != nil &&cell->ItemInCell == nil && row < NUMBER_OF_ROWS){
                row++;
                cell = [self GetCell:row : item->Column];
            }
            cell = [self GetCell:row -1 : item->Column];
            return cell;
        default:
            return nil;
    }
    
}

/**************************************
 Helpers
 **************************************/

-(BOOL)CheckCellToSet:(Cell *) cell{
	return (cell->ItemInCell == nil);
}

-(void)SetItemToCell:(GameItem *)item : (Cell *) cell{
    if(cell == nil || cell->ItemInCell == item){
        return;
    }
    if(cell->ItemInCell != nil){
        [cell->ItemInCell release];
    }
	cell->ItemInCell = [item retain];
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationDuration:0.15];
	item.center = cell->Center;
	item->Row = cell->Row;
	item->Column = cell->Column;
	[UIView commitAnimations];
}

-(Cell *)GetCell:(int)row : (int)column{
	if(row >= 0 && row < RowLength && column >= 0 && column < ColumnLength)
		return cells[(row) * ColumnLength + column];
	return nil;
	
}
-(Cell *)GetCell:(GameItem *)item{
	return [self GetCell:item->Row :item->Column];
}

@end

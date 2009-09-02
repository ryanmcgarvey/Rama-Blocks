//
//  ItemCollection.m
//  RumbaBlocks
//
//  Created by Ryan McGarvey on 7/29/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import "ItemCollection.h"
#import "Rama_BlocksAppDelegate.h"

@implementation ItemCollection

-(id)init: (int) rows : (int) columns : (int)rowPixelLength : (int)columnPixelLength : (Level *) level{	
	
    Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
    gameState = [appDelegate FetchGameState];
	
    currentLevel = level;
    solution = [NSMutableArray new];
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


-(void)cleanBoard{
	int row = 0;
	int column = 0;
    
	for (row = 0; row <= NUMBER_OF_ROWS; row++) 
	{
		for (column =0; column <= NUMBER_OF_COLUMNS; column++) 
		{
			Cell *removeCell = [self GetCell:row :column];
			[removeCell.ItemInCell removeFromSuperview];
			removeCell.ItemInCell = nil;
			[removeCell.ItemInCell release];
			
			
		}
	}
}

-(void)UpdateState{
    numberOfMoves = [gameState.currentBoard.numberOfMovies intValue];
    numberOfTransforms = [gameState.currentBoard.numberOfTransforms intValue];
    numberOfAttempts = [gameState.currentBoard.numberOfAttempts intValue];
}

-(void)SaveState {
    Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray * items = [appDelegate FetchCollectionItemStates];
    
    for(int i = 0; i < NUMBER_OF_ROWS * NUMBER_OF_COLUMNS; i++)
    {
		Cell * cell = cells[i];
		ItemState * itemState = [items objectAtIndex:i];
		if(cell.ItemInCell != nil && [cell.ItemInCell isKindOfClass:[Shape class]])
		{
			Shape * shape = (Shape *) cell.ItemInCell;
			itemState.shapeType = 
			[NSNumber numberWithInt:shape.shapeType];
			itemState.colorType = 
			[NSNumber numberWithInt:shape.colorType];
			itemState.Row = [NSNumber numberWithInt:cell.Row];
			itemState.Column = [NSNumber numberWithInt:cell.Column];
		}else{
			itemState.shapeType = [NSNumber numberWithInt:-1];
			itemState.colorType = [NSNumber numberWithInt:-1];
		}
    }
    items = [appDelegate FetchLockItems];
    for(int i = 0; i < currentLevel.lockCount; i++)
    {
        ItemState * itemState = [items objectAtIndex:i];
        LockShape * lock = [currentLevel GetLockAtIndex:i];
        itemState.shapeType = [NSNumber numberWithInt:lock.shapeType];
        itemState.colorType = [NSNumber numberWithInt:lock.colorType];
        itemState.canSeeColor = [NSNumber numberWithBool:lock.canSeeColor];
        itemState.canSeeItem = [NSNumber numberWithBool:lock.canSeeShape];
    }
    gameState.currentBoard.numberOfMovies = [NSNumber numberWithInt:numberOfMoves];
    gameState.currentBoard.numberOfTransforms = [NSNumber numberWithInt:numberOfTransforms];
    gameState.currentBoard.numberOfAttempts = [NSNumber numberWithInt:numberOfAttempts];
}

/**************************************
 Public
 **************************************/
-(BOOL)DrawShadowForItemPair: (ItemPair *)itemPair{
    
    int rowA; int rowB; int columnA; int columnB;
	Cell * cellA;
	Cell * cellB;
	
	// Which column is each item in
	columnA = (int)(itemPair.ItemA.center.x - GRID_LEFT_EDGE  ) / (int)SHAPE_WIDTH;
	columnB = (int)(itemPair.ItemB.center.x - GRID_LEFT_EDGE ) / (int)SHAPE_WIDTH;
	
	// Which column is each item in
	rowA = (int)(GRID_Y_BOTTOM - 6 - itemPair.ItemA.center.y + (SHAPE_WIDTH / 2)) / (int)SHAPE_WIDTH;
	rowB = (int)(GRID_Y_BOTTOM - 6 -itemPair.ItemB.center.y + (SHAPE_WIDTH / 2)) / (int)SHAPE_WIDTH;
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
		if(itemPair.ItemA.center.y > itemPair.ItemB.center.y)
        {
			cellA = [self GetCell:cellA.Row -1 : cellA.Column];
		}
        else
        {
			cellB = [self GetCell:cellB.Row -1 : cellB.Column];
		}
	}
	if(!([self CheckCellToSet:cellA] && [self CheckCellToSet:cellB]))
    {
		NSLog(@"Collision, undoing shit");
		return FALSE;
	}
    
    itemPair.ItemA.Row = rowA;
    itemPair.ItemB.Row = rowB;
    itemPair.ItemA.Column = columnA;
    itemPair.ItemB.Column = columnB;
    
    cellA = [self FindCellToFallTo:itemPair.ItemA];
    cellB = [self FindCellToFallTo:itemPair.ItemB];
    if(cellA == cellB)
    {
        switch (gravityDirection) {
            case down:
                if(itemPair.ItemA.center.y < itemPair.ItemB.center.y)
                {
                    cellA = [self GetCell:cellA.Row + 1 : cellA.Column];
                }
                else
                {
                    cellB = [self GetCell:cellB.Row + 1 : cellB.Column];
                }
                break;
            case up:
                if(itemPair.ItemA.center.y > itemPair.ItemB.center.y)
                {
                    cellA = [self GetCell:cellA.Row - 1 : cellA.Column];
                }
                else
                {
                    cellB = [self GetCell:cellB.Row - 1 : cellB.Column];
                }
                break;
            case left:
                if(itemPair.ItemA.center.x > itemPair.ItemB.center.x)
                {
                    cellA = [self GetCell:cellA.Row : cellA.Column + 1];
                }
                else
                {
                    cellB = [self GetCell:cellB.Row : cellB.Column + 1];
                }
                break;
				
            case right:
				
                if(itemPair.ItemA.center.x < itemPair.ItemB.center.x)
                {
                    cellA = [self GetCell:cellA.Row : cellA.Column - 1];
                }
                else
                {
                    cellB = [self GetCell:cellB.Row : cellB.Column - 1];
                }
                break;
        }
		
	}
    
    [itemPair setShadow:cellA.Center : cellB.Center];
    
    return TRUE;
}


-(BOOL)AddItemPair: (ItemPair *)itemPair;{
	
	int rowA; int rowB; int columnA; int columnB;
	Cell * cellA;
	Cell * cellB;
	
	// Which column is each item in
	columnA = (int)(itemPair.ItemA.center.x - GRID_LEFT_EDGE  ) / (int)SHAPE_WIDTH;
	columnB = (int)(itemPair.ItemB.center.x - GRID_LEFT_EDGE ) / (int)SHAPE_WIDTH;
	
	// Which column is each item in
	rowA = (int)(GRID_Y_BOTTOM - itemPair.ItemA.center.y + (SHAPE_WIDTH / 2)) / (int)SHAPE_WIDTH;
	rowB = (int)(GRID_Y_BOTTOM - itemPair.ItemB.center.y + (SHAPE_WIDTH / 2)) / (int)SHAPE_WIDTH;
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
		if(itemPair.ItemA.center.y > itemPair.ItemB.center.y)
        {
			cellA = [self GetCell:cellA.Row -1 : cellA.Column];
		}
        else
        {
			cellB = [self GetCell:cellB.Row -1 : cellB.Column];
		}
	}
	if(!([self CheckCellToSet:cellA] && [self CheckCellToSet:cellB]))
    {
		NSLog(@"Collision, undoing shit");
		return FALSE;
	}
	numberOfMoves ++;
	[self SetItemToCell:itemPair.ItemA :cellA];
	[self SetItemToCell:itemPair.ItemB :cellB];
	
	itemPair.ItemA.IsPaired = FALSE;
	itemPair.ItemB.IsPaired = FALSE;
    [currentLevel addItem:itemPair.ItemA];
    [currentLevel addItem:itemPair.ItemB];
    [self ApplyGravity];
	return TRUE;
}

/**************************************
 TRANSFORMS
 **************************************/
-(BOOL)TransformItem:(GameItem*)item{
    BOOL couldTransform = FALSE;
	NSMutableArray * transFormGroup = [self CheckTransform : item];
	
	SEL  arraySelector;
	NSMethodSignature * animateSignature;
	NSInvocation * animateInvocation;
	
	arraySelector = @selector(RemoveFromCellsAndRefactor:);
	animateSignature = [ItemCollection instanceMethodSignatureForSelector:arraySelector];
	animateInvocation = [NSInvocation invocationWithMethodSignature:animateSignature];
	[animateInvocation setSelector:arraySelector];
	
	[animateInvocation setTarget:self];
	[animateInvocation setArgument:&transFormGroup atIndex:2];
	
    if([item isKindOfClass: [Shape class]])
    {
        Shape * shape = (Shape *)item;
        
        Cell * cell = [self GetCell:item];
        if([transFormGroup count] > 2)
        {
            [transFormGroup removeObject:cell];
            [self animateTransform: transFormGroup];
			
			
			[NSTimer timerWithTimeInterval:1 invocation:animateInvocation repeats:NO];
			[NSTimer release];
			
			
			if(shape.shapeType != NUMBER_OF_SHAPES){
				[shape TransForm];
			}
			else{
				[cell.ItemInCell removeFromSuperview];
				[cell.ItemInCell release];		
				cell.ItemInCell = nil;
				return FALSE;
			}
			
            [currentLevel addItem:shape];
            //[self CheckTransform:item];
            couldTransform = TRUE;
            numberOfTransforms ++;
        }
        [transFormGroup removeAllObjects];
		transFormGroup = nil;
		[transFormGroup release];
        [self ApplyGravity];
    }
    return couldTransform;
}

-(void)animateTransform:(NSMutableArray *)TransFormGroup{
	for(Cell * cell in TransFormGroup){	
		Shape * shape = (Shape *)cell.ItemInCell;
		if(shape.colorType == Red){
			cell.ItemInCell.ItemView.image = nil; 
			
			cell.ItemInCell.ItemView.contentMode = UIViewContentModeRedraw;
			
			[UIView beginAnimations:nil context:nil]; 
			[UIView setAnimationDuration:1];
			
			UIImageView * piece1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redpiece1.png"]];
			UIImageView * piece2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redpiece2.png"]];
			UIImageView * piece3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redpiece3.png"]];
			UIImageView * piece4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redpiece4.png"]];
			UIImageView * piece5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redpiece5.png"]];
			[cell.ItemInCell addSubview:piece1];
			[cell.ItemInCell addSubview:piece2];
			[cell.ItemInCell addSubview:piece3];
			[cell.ItemInCell addSubview:piece4];
			[cell.ItemInCell addSubview:piece5];
			
			piece1.center = CGPointMake(piece1.center.x + ((float)((uint)arc4random())/0xFFFFFFFF * 10),piece1.center.x + ((float)((uint)arc4random())/0xFFFFFFFF * 10));
			piece2.center = CGPointMake(piece2.center.x - ((float)((uint)arc4random())/0xFFFFFFFF * 10),piece2.center.x - ((float)((uint)arc4random())/0xFFFFFFFF * 10));
			piece3.center = CGPointMake(piece3.center.x - ((float)((uint)arc4random())/0xFFFFFFFF * 10),piece3.center.x + ((float)((uint)arc4random())/0xFFFFFFFF * 10));
			piece4.center = CGPointMake(piece4.center.x + ((float)((uint)arc4random())/0xFFFFFFFF * 10),piece4.center.x - ((float)((uint)arc4random())/0xFFFFFFFF * 10));
			piece5.center = CGPointMake(piece5.center.x + ((float)((uint)arc4random())/0xFFFFFFFF * 5),piece5.center.x + ((float)((uint)arc4random())/0xFFFFFFFF * 5));
			[cell.ItemInCell setNeedsDisplay];
			cell.ItemInCell.alpha = 0;
			cell.ItemInCell = nil;
			
			
			[UIView commitAnimations]; 
			piece1 = nil;
			piece2 = nil;
			piece3 = nil;
			piece4 = nil;
			piece5 = nil;
			
			[piece1 release];
			[piece2 release];
			[piece3 release];
			[piece4 release];
			[piece5 release];
			
			[piece1 dealloc];
			[piece2 dealloc];
			[piece3 dealloc];
			[piece4 dealloc];
			[piece5 dealloc];
			
			cell.ItemInCell = nil;
			[cell.ItemInCell release];
		}
		if(shape.colorType == Green){
			cell.ItemInCell.ItemView.image = nil; 
			
			cell.ItemInCell.ItemView.contentMode = UIViewContentModeRedraw;
			
			[UIView beginAnimations:nil context:nil]; 
			[UIView setAnimationDuration:1];
			
			UIImageView * piece1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"greenpiece1.png"]];
			UIImageView * piece2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"greenpiece2.png"]];
			UIImageView * piece3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"greenpiece3.png"]];
			UIImageView * piece4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"greenpiece4.png"]];
			UIImageView * piece5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"greenpiece5.png"]];
			[cell.ItemInCell addSubview:piece1];
			[cell.ItemInCell addSubview:piece2];
			[cell.ItemInCell addSubview:piece3];
			[cell.ItemInCell addSubview:piece4];
			[cell.ItemInCell addSubview:piece5];
			
			piece1.center = CGPointMake(piece1.center.x + ((float)((uint)arc4random())/0xFFFFFFFF * 10),piece1.center.x + ((float)((uint)arc4random())/0xFFFFFFFF * 10));
			piece2.center = CGPointMake(piece2.center.x - ((float)((uint)arc4random())/0xFFFFFFFF * 10),piece2.center.x - ((float)((uint)arc4random())/0xFFFFFFFF * 10));
			piece3.center = CGPointMake(piece3.center.x - ((float)((uint)arc4random())/0xFFFFFFFF * 10),piece3.center.x + ((float)((uint)arc4random())/0xFFFFFFFF * 10));
			piece4.center = CGPointMake(piece4.center.x + ((float)((uint)arc4random())/0xFFFFFFFF * 10),piece4.center.x - ((float)((uint)arc4random())/0xFFFFFFFF * 10));
			piece5.center = CGPointMake(piece5.center.x + ((float)((uint)arc4random())/0xFFFFFFFF * 5),piece5.center.x + ((float)((uint)arc4random())/0xFFFFFFFF * 5));
			[cell.ItemInCell setNeedsDisplay];
			cell.ItemInCell.alpha = 0;
			cell.ItemInCell = nil;
			
			
			[UIView commitAnimations]; 
			piece1 = nil;
			piece2 = nil;
			piece3 = nil;
			piece4 = nil;
			piece5 = nil;
			
			[piece1 release];
			[piece2 release];
			[piece3 release];
			[piece4 release];
			[piece5 release];
			
			[piece1 dealloc];
			[piece2 dealloc];
			[piece3 dealloc];
			[piece4 dealloc];
			[piece5 dealloc];
			
			cell.ItemInCell = nil;
			[cell.ItemInCell release];
		}
		if(shape.colorType == Blue){
			cell.ItemInCell.ItemView.image = nil; 
			
			cell.ItemInCell.ItemView.contentMode = UIViewContentModeRedraw;
			
			[UIView beginAnimations:nil context:nil]; 
			[UIView setAnimationDuration:1];
			
			UIImageView * piece1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bluepiece1.png"]];
			UIImageView * piece2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bluepiece2.png"]];
			UIImageView * piece3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bluepiece3.png"]];
			UIImageView * piece4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bluepiece4.png"]];
			UIImageView * piece5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bluepiece5.png"]];
			[cell.ItemInCell addSubview:piece1];
			[cell.ItemInCell addSubview:piece2];
			[cell.ItemInCell addSubview:piece3];
			[cell.ItemInCell addSubview:piece4];
			[cell.ItemInCell addSubview:piece5];
			
			piece1.center = CGPointMake(piece1.center.x + ((float)((uint)arc4random())/0xFFFFFFFF * 10),piece1.center.x + ((float)((uint)arc4random())/0xFFFFFFFF * 10));
			piece2.center = CGPointMake(piece2.center.x - ((float)((uint)arc4random())/0xFFFFFFFF * 10),piece2.center.x - ((float)((uint)arc4random())/0xFFFFFFFF * 10));
			piece3.center = CGPointMake(piece3.center.x - ((float)((uint)arc4random())/0xFFFFFFFF * 10),piece3.center.x + ((float)((uint)arc4random())/0xFFFFFFFF * 10));
			piece4.center = CGPointMake(piece4.center.x + ((float)((uint)arc4random())/0xFFFFFFFF * 10),piece4.center.x - ((float)((uint)arc4random())/0xFFFFFFFF * 10));
			piece5.center = CGPointMake(piece5.center.x + ((float)((uint)arc4random())/0xFFFFFFFF * 5),piece5.center.x + ((float)((uint)arc4random())/0xFFFFFFFF * 5));
			[cell.ItemInCell setNeedsDisplay];
			cell.ItemInCell.alpha = 0;
			cell.ItemInCell = nil;
			
			
			[UIView commitAnimations]; 
			piece1 = nil;
			piece2 = nil;
			piece3 = nil;
			piece4 = nil;
			piece5 = nil;
			
			[piece1 release];
			[piece2 release];
			[piece3 release];
			[piece4 release];
			[piece5 release];
			
			[piece1 dealloc];
			[piece2 dealloc];
			[piece3 dealloc];
			[piece4 dealloc];
			[piece5 dealloc];
			
			cell.ItemInCell = nil;
			[cell.ItemInCell release];
		}
		if(shape.colorType == Yellow){
			cell.ItemInCell.ItemView.image = nil; 
			
			cell.ItemInCell.ItemView.contentMode = UIViewContentModeRedraw;
			
			[UIView beginAnimations:nil context:nil]; 
			[UIView setAnimationDuration:1];
			
			UIImageView * piece1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yellowpiece1.png"]];
			UIImageView * piece2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yellowpiece2.png"]];
			UIImageView * piece3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yellowpiece3.png"]];
			UIImageView * piece4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yellowpiece4.png"]];
			UIImageView * piece5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yellowpiece5.png"]];
			[cell.ItemInCell addSubview:piece1];
			[cell.ItemInCell addSubview:piece2];
			[cell.ItemInCell addSubview:piece3];
			[cell.ItemInCell addSubview:piece4];
			[cell.ItemInCell addSubview:piece5];
			
			piece1.center = CGPointMake(piece1.center.x + ((float)((uint)arc4random())/0xFFFFFFFF * 10),piece1.center.x + ((float)((uint)arc4random())/0xFFFFFFFF * 10));
			piece2.center = CGPointMake(piece2.center.x - ((float)((uint)arc4random())/0xFFFFFFFF * 10),piece2.center.x - ((float)((uint)arc4random())/0xFFFFFFFF * 10));
			piece3.center = CGPointMake(piece3.center.x - ((float)((uint)arc4random())/0xFFFFFFFF * 10),piece3.center.x + ((float)((uint)arc4random())/0xFFFFFFFF * 10));
			piece4.center = CGPointMake(piece4.center.x + ((float)((uint)arc4random())/0xFFFFFFFF * 10),piece4.center.x - ((float)((uint)arc4random())/0xFFFFFFFF * 10));
			piece5.center = CGPointMake(piece5.center.x + ((float)((uint)arc4random())/0xFFFFFFFF * 5),piece5.center.x + ((float)((uint)arc4random())/0xFFFFFFFF * 5));
			[cell.ItemInCell setNeedsDisplay];
			cell.ItemInCell.alpha = 0;
			cell.ItemInCell = nil;
			
			
			[UIView commitAnimations]; 
			
			piece1 = nil;
			piece2 = nil;
			piece3 = nil;
			piece4 = nil;
			piece5 = nil;
			
			[piece1 release];
			[piece2 release];
			[piece3 release];
			[piece4 release];
			[piece5 release];
			
			[piece1 dealloc];
			[piece2 dealloc];
			[piece3 dealloc];
			[piece4 dealloc];
			[piece5 dealloc];
			
			cell.ItemInCell = nil;
			[cell.ItemInCell release];
		}
		if(shape.colorType == Purple){
			cell.ItemInCell.ItemView.image = nil; 
			
			cell.ItemInCell.ItemView.contentMode = UIViewContentModeRedraw;
			
			[UIView beginAnimations:nil context:nil]; 
			[UIView setAnimationDuration:1];
			
			UIImageView * piece1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"purplepiece1.png"]];
			UIImageView * piece2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"purplepiece2.png"]];
			UIImageView * piece3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"purplepiece3.png"]];
			UIImageView * piece4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"purplepiece4.png"]];
			UIImageView * piece5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"purplepiece5.png"]];
			[cell.ItemInCell addSubview:piece1];
			[cell.ItemInCell addSubview:piece2];
			[cell.ItemInCell addSubview:piece3];
			[cell.ItemInCell addSubview:piece4];
			[cell.ItemInCell addSubview:piece5];
			
			piece1.center = CGPointMake(piece1.center.x + ((float)((uint)arc4random())/0xFFFFFFFF * 10),piece1.center.x + ((float)((uint)arc4random())/0xFFFFFFFF * 10));
			piece2.center = CGPointMake(piece2.center.x - ((float)((uint)arc4random())/0xFFFFFFFF * 10),piece2.center.x - ((float)((uint)arc4random())/0xFFFFFFFF * 10));
			piece3.center = CGPointMake(piece3.center.x - ((float)((uint)arc4random())/0xFFFFFFFF * 10),piece3.center.x + ((float)((uint)arc4random())/0xFFFFFFFF * 10));
			piece4.center = CGPointMake(piece4.center.x + ((float)((uint)arc4random())/0xFFFFFFFF * 10),piece4.center.x - ((float)((uint)arc4random())/0xFFFFFFFF * 10));
			piece5.center = CGPointMake(piece5.center.x + ((float)((uint)arc4random())/0xFFFFFFFF * 5),piece5.center.x + ((float)((uint)arc4random())/0xFFFFFFFF * 5));
			[cell.ItemInCell setNeedsDisplay];
			cell.ItemInCell.alpha = 0;
			
			
			[UIView commitAnimations]; 
			
			piece1 = nil;
			piece2 = nil;
			piece3 = nil;
			piece4 = nil;
			piece5 = nil;
			
			[piece1 release];
			[piece2 release];
			[piece3 release];
			[piece4 release];
			[piece5 release];
			
			[piece1 dealloc];
			[piece2 dealloc];
			[piece3 dealloc];
			[piece4 dealloc];
			[piece5 dealloc];
			
			cell.ItemInCell = nil;
			[cell.ItemInCell release];
			
		}
		
		
	}
	
	//[self RemoveFromCellsAndRefactor:TransFormGroup];
}

-(void)RemoveFromCellsAndRefactor:(NSMutableArray *)TransFormGroup{
    [currentLevel removeItems:TransFormGroup];
	//[self animateTransform:TransFormGroup];
	for(Cell * cell in TransFormGroup)
    {	
		[cell.ItemInCell removeFromSuperview];
		[cell.ItemInCell release];		
        cell.ItemInCell = nil;
	}
    [self ApplyGravity];
}

-(NSMutableArray *)CheckTransform:(int)row : (int)column{
    
    NSMutableArray * TransformGroup = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_ROWS * NUMBER_OF_COLUMNS];
	Cell * cell = [self GetCell:row :column];
	if(cell.ItemInCell != nil && ! cell.IsTransforming)
    {
        cell.IsTransforming = TRUE;
        GameItem * item = cell.ItemInCell;
        if([item isKindOfClass:[Shape class]])
        {
            Shape * shape = (Shape * )item;
            Cell * neighbor = nil;
            //Check right
            neighbor = [self GetCell:cell.Row + 1 : cell.Column];
            if(!neighbor.IsTransforming && neighbor.ItemInCell != nil && 
               [shape Equals:(Shape *)neighbor.ItemInCell])
            {
                [TransformGroup addObjectsFromArray:[self CheckTransform:neighbor.Row: neighbor.Column]];
            }
            //Check left
            neighbor = [self GetCell:cell.Row - 1 : cell.Column];
            if(!neighbor.IsTransforming && neighbor.ItemInCell != nil && 
               [shape Equals:(Shape *)neighbor.ItemInCell])
            {
                [TransformGroup addObjectsFromArray:[self CheckTransform:neighbor.Row: neighbor.Column]];
            }
            //Check up
            neighbor = [self GetCell:cell.Row  : cell.Column + 1];
            if(!neighbor.IsTransforming && neighbor.ItemInCell != nil && 
               [shape Equals:(Shape *)neighbor.ItemInCell])
            {
                [TransformGroup addObjectsFromArray:[self CheckTransform:neighbor.Row: neighbor.Column]];
            }
            //Check down
            neighbor = [self GetCell:cell.Row  : cell.Column - 1];
            if(!neighbor.IsTransforming && neighbor.ItemInCell != nil && 
               [shape Equals:(Shape *)neighbor.ItemInCell])
            {
                [TransformGroup addObjectsFromArray:[self CheckTransform:neighbor.Row: neighbor.Column]];
            }
			
            [TransformGroup addObject:cell];
            cell.IsTransforming = FALSE;
        }
	}
	[TransformGroup autorelease];
	return TransformGroup;	
	
}

-(NSMutableArray *)CheckTransform:(Shape *)shape{
	return [self CheckTransform:shape.Row : shape.Column];
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
                    Cell * cell = [self GetCell:row : column];
					if(cell.ItemInCell != 0 && cell.ItemInCell.IsAnchored == NO){
						[self ApplyGravityToCell:cell];
					}
                }
            }
            return;
        case right:
            for(row = 0; row < NUMBER_OF_ROWS; row++)
            {
                for(column = NUMBER_OF_COLUMNS - 1; column >= 0; column --)
                {
                    Cell * cell = [self GetCell:row : column];
					if(cell.ItemInCell != 0 && cell.ItemInCell.IsAnchored == NO){
						[self ApplyGravityToCell:cell];
					}
                }
            }
            return;
        case down:
            for(column = 0; column < NUMBER_OF_COLUMNS; column ++)
            {
                for(row = 0; row < NUMBER_OF_ROWS; row++)
                {
                    Cell * cell = [self GetCell:row : column];
					if(cell.ItemInCell != 0 && cell.ItemInCell.IsAnchored == NO){
						[self ApplyGravityToCell:cell];
					}
                }
            }
            return;
        case up:
            for(column = 0; column < NUMBER_OF_COLUMNS; column ++)
            {
                for(row = NUMBER_OF_ROWS -1 ; row >= 0; row--)
                {
                    Cell * cell = [self GetCell:row : column];
					if(cell.ItemInCell != 0 && cell.ItemInCell.IsAnchored == NO){
						[self ApplyGravityToCell:cell];
					}
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
    if(cell.ItemInCell !=nil)
    {
		//GameItem *rotatedShape = [GameItem new];
		GameItem * rotatedShape = cell.ItemInCell;
		switch (gravityDirection) {
			case left:
				
				rotatedShape.transform = CGAffineTransformIdentity;
				rotatedShape.transform = CGAffineTransformRotate(cell.ItemInCell.transform, rotate_xDegrees(90));
				cell.ItemInCell = rotatedShape;
				rotatedShape = nil;
				break;
			case right:
				
				rotatedShape.transform = CGAffineTransformIdentity;
				rotatedShape.transform = CGAffineTransformRotate(cell.ItemInCell.transform, rotate_xDegrees(270));
				cell.ItemInCell = rotatedShape;
				rotatedShape = nil;
				break;
			case up:
				
				rotatedShape.transform = CGAffineTransformIdentity;
				rotatedShape.transform = CGAffineTransformRotate(cell.ItemInCell.transform, rotate_xDegrees(180));
				cell.ItemInCell = rotatedShape;
				rotatedShape = nil;
				break;
			case down:
				
				rotatedShape.transform = CGAffineTransformIdentity;
				cell.ItemInCell = rotatedShape;
				rotatedShape = nil;
				break;
				
		}
		
        Cell * cellToMoveTo = [self FindCellToFallTo:cell.ItemInCell];
        if(cellToMoveTo == nil || cellToMoveTo.ItemInCell != nil)
        {
            return;
        }
		
		
        [self SetItemToCell:cell.ItemInCell :cellToMoveTo];
		
        cell.ItemInCell = nil;
    }
}

-(Cell *)FindCellToFallTo:(GameItem *) item{
    Cell * cell = nil;
    int column;
    int row;
    switch (gravityDirection) 
    {
        case left:
            column = item.Column;
            while(cell.ItemInCell == nil && column >= 0)
            {
                column--;
                cell = [self GetCell:item.Row : column];
            }
            return [self GetCell:item.Row : column + 1];
        case right:
            column = item.Column;
            while(cell.ItemInCell == nil && column < NUMBER_OF_COLUMNS)
            {
                column++;
                cell = [self GetCell:item.Row : column];
            }
            return [self GetCell:item.Row : column - 1];            
        case down:
            row = item.Row;
            while(cell.ItemInCell == nil && row >= 0)
            {
                row--;
                cell = [self GetCell:row : item.Column];
            }
            cell = [self GetCell:row +1 : item.Column];
            return cell;
        case up:
            row = item.Row;
            while(cell.ItemInCell == nil && row < NUMBER_OF_ROWS)
            {
                row++;
                cell = [self GetCell:row : item.Column];
            }
            cell = [self GetCell:row -1 : item.Column];
            return cell;
        default:
            return nil;
    }
}

/**************************************
 Solution
 **************************************/

-(void)HighLightShapes{
    for(Shape * shape in solution)
    {
        [shape setBackgroundColor:[UIColor lightGrayColor]];
    }
}
-(void)UnHighLightShapes{
    for(Shape * shape in solution)
    {
        [shape setBackgroundColor:[UIColor clearColor]];
    }
}
-(void)AddShapeToSolution:(Shape *)shape{
    
    if(shape != nil)
    {
        if([solution count] ==0 || [shape IsNeighbor:[solution lastObject]] &&![solution containsObject:shape]  )
        {
            [solution addObject:shape];
            [self HighLightShapes];
        }
    }
}

-(void)ClearSolution{
    [self UnHighLightShapes];
    [solution removeAllObjects];
}

-(BOOL)CheckSolution{
    
    BOOL isCorrect = [currentLevel checkSolution:solution];
    numberOfAttempts ++;
    [self ClearSolution];
    
    return isCorrect;
}

/**************************************
 Helpers
 **************************************/

-(BOOL)CheckCellToSet:(Cell *) cell{
	return (cell.ItemInCell == nil);
}

-(void)SetItemToCell:(GameItem *)item : (Cell *) cell{
    if(cell == nil || cell.ItemInCell == item){
		
        return;
    }
    if(cell.ItemInCell != nil){
        
        [cell.ItemInCell release];
    }
	cell.ItemInCell = [item retain];
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationDuration:0.15];
    item.center = cell.Center;
	item.Row = cell.Row;
	item.Column = cell.Column;
	[UIView commitAnimations];
}

-(void)setShuffledArray:(NSMutableArray *)shuffledPieces{
    
	int i;
	int row;
	int column;
	int numberOfShapes = [shuffledPieces count];
	
	for (row = 0; row <= NUMBER_OF_ROWS; row++) {
		for (column =0; column <= NUMBER_OF_COLUMNS; column++) {
			
			if(i < numberOfShapes){
				Cell *placedCell = [self GetCell:row :column];
				Shape *shuffleShape = [shuffledPieces objectAtIndex:i];
				[shuffleShape ChangeColorAndShape:shuffleShape.colorType :shuffleShape.shapeType];
				placedCell.ItemInCell = shuffleShape;
				placedCell.ItemInCell.ItemView = shuffleShape.ItemView;
				[self ApplyGravity];
				
			}
			i++;
			
			
		}
	}
	NSLog(@"adding");
	
	
}

-(Cell *)GetCell:(int)row : (int)column{
	if(row >= 0 && row < RowLength && column >= 0 && column < ColumnLength)
		return cells[(row) * ColumnLength + column];
	return nil;
	
}
-(Cell *)GetCell:(GameItem *)item{
	return [self GetCell:item.Row :item.Column];
}

-(GameItem *)GetItemFromCoordinate:(CGPoint) point{
    // Which column is each shape in
	int columnA = (int)(point.x - GRID_LEFT_EDGE  ) / (int)SHAPE_WIDTH;
	
	// Which column is each shape in
	int rowA = (int)(GRID_Y_BOTTOM - point.y + (SHAPE_WIDTH / 2)) / (int)SHAPE_WIDTH;
    
    Cell * cell = [self GetCell:rowA:columnA];
    return cell.ItemInCell;
}

- (void)dealloc {
    for(int i = 0; i <NUMBER_OF_ROWS * NUMBER_OF_COLUMNS; i++)
    {
        [cells[i] release];
    }
    [solution dealloc];
    [currentLevel dealloc];
    [super dealloc];
    
}



@end

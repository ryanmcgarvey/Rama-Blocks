//
//  ItemCollection.h
//  RumbaBlocks
//
//  Created by Ryan McGarvey on 7/29/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameItem.h"
#import "Cell.h"
#import "GlobalDefines.h"
#import "ItemPair.h"
#import "Shape.h"
#import "Level.h"

typedef enum enum_Gravity {
    zero,
    down,
    left,
    right,
    up
} Gravity;

@interface ItemCollection : NSObject {
    
	id * cells;
@public;
	int RowLength;
	int ColumnLength;
	int RowPixelLength;
	int ColumnPixelLength;
    Gravity gravityDirection;
    NSMutableArray * solution;
    Level * currentLevel;
}

-(id)init: (int) rows : (int) columns : (int)rowPixelLength : (int)columnPixelLength : (Level *)level;

-(BOOL)AddItemPair: (ItemPair *)itemPair;

-(NSMutableArray *)CheckTransform:(int)row : (int)column;
-(NSMutableArray *)CheckTransform:(GameItem *)item;

-(Cell *)GetCell:(int)row : (int)column;
-(Cell *)GetCell:(GameItem *) item;

-(BOOL)TransformItem:(GameItem*)shape;

-(void)RemoveFromCellsAndRefactor:(NSMutableArray *)TransFormGroup;

-(void)ApplyGravity;
-(Cell *)FindCellToFallTo:(GameItem *) item;

-(BOOL)CheckCellToSet:(Cell *) cell;

-(void)SetItemToCell:(GameItem *)item : (Cell *)cell;

-(void)SetGravity:(Gravity)gravity;
-(void)ApplyGravityToCell:(Cell *)cell;

-(void)HighLightShapes;
-(void)UnHighLightShapes;
-(void)AddShapeToSolution:(Shape *)shape;
-(BOOL)CheckSolution;

-(GameItem *)GetItemFromCoordinate:(CGPoint) point;
@end

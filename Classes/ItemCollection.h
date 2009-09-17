//
//  ItemCollection.h
//  RumbaBlocks
//
//  Created by Ryan McGarvey on 7/29/09.
//  Copyright 2009 Simplical. All rights reserved.
//

@class PowerItem;

#import <Foundation/Foundation.h>
#import "GameItem.h"
#import "Cell.h"
#import "GlobalDefines.h"
#import "ItemPair.h"
#import "Shape.h"
#import "Level.h"
#import "GameState.h"
#import "ItemState.h"
#import "BoardState.h"


typedef enum enum_Gravity {
    zero,
    down,
    left,
    right,
    up
} Gravity;

#define rotate_xDegrees(x) (M_PI * x / 180.0)

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
    GameState * gameState;
	
	UIDevice * CurrentDevice;
    
    int numberOfAttempts;
    int numberOfTransforms;
    int numberOfMoves;
	
	int maxY;
	
    
	
}


-(id)init: (int) rows : (int) columns : (int)rowPixelLength : (int)columnPixelLength : (Level *)level;
-(void)cleanBoard;

-(BOOL)DrawShadowForItemPair: (ItemPair *)itemPair;
-(BOOL)AddItemPair: (ItemPair *)itemPair;

-(NSMutableArray *)CheckTransform:(int)row : (int)column;
-(NSMutableArray *)CheckTransform:(GameItem *)item;

-(Cell *)GetCell:(int)row : (int)column;
-(Cell *)GetCell:(GameItem *) item;

-(BOOL)TransformItem:(GameItem*)shape;
-(void)animateTransform:(NSMutableArray *)TransFormGroup;

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
-(void)ClearSolution;

-(GameItem *)GetItemFromCoordinate:(CGPoint) point;

-(void)SaveState;

-(void)UpdateState;

-(void)setShuffledArray:(NSMutableArray *)item;

@end

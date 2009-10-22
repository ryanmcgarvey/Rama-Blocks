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
	
	NSMutableSet * phaseSetRed;
	NSMutableSet * phaseSetYellow;
	NSMutableSet * phaseSetPurple;
	NSMutableSet * phaseSetGreen;
	NSMutableSet * phaseSetBlue;
	
	NSMutableSet * phaseSetTriangle;
	NSMutableSet * phaseSetSquare;
	NSMutableSet * phaseSetPentagon;
	NSMutableSet * phaseSetHexagon;
	NSMutableSet * phaseSetCircle;
	
    Gravity gravityDirection;
    Level * currentLevel;
    GameState * gameState;
	
	UIDevice * CurrentDevice;
    CGAffineTransform spawnedShapeRotateTransform;
    int numberOfAttempts;
    int numberOfTransforms;
    int numberOfMoves;
	
	int maxY;
	
	int multiplier;
	
}

@property(assign)Gravity gravityDirection;
@property(readwrite, assign)int multiplier;

-(id)init: (int) rows : (int) columns : (int)rowPixelLength : (int)columnPixelLength : (Level *)level;

-(void)cleanBoard;

-(BOOL)checkPiece:(int)difficulty;
-(BOOL)checkPieceForPhase1:(int) row :(int) column;
-(BOOL)checkPieceForPhase2:(int) row :(int) column;
-(BOOL)checkPieceForPhase3:(int) row :(int) column;

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


-(GameItem *)GetItemFromCoordinate:(CGPoint) point;

-(void)SaveState;

-(void)UpdateState;

-(void)setShuffledArray:(NSMutableArray *)item;

@end

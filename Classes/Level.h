//
//  Level.h
//  Rama Blocks
//
//  Created by Ryan McGarvey on 8/1/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Shape.h"
#import "GlobalDefines.h"
#import "GameState.h"

@interface Level : NSObject {
    int difficulty;
    NSMutableArray * solution;
	
    float shapeSpawnProbability [NUMBER_OF_SHAPES];
    int totalShapes [NUMBER_OF_SHAPES];
    
    ColorType maxColor;
    ShapeType maxShape;
    
    GameState * gameState;
    
	int rowsBlockedHigh;
	int rowsBlockedLow;
	int columnsBlockedHigh;
	int columnsBlockedLow;
	
}

@property (readonly) int difficulty;


@property (readwrite, assign) int rowsBlockedHigh;
@property (readwrite, assign) int rowsBlockedLow;
@property (readwrite, assign) int columnsBlockedHigh;
@property (readwrite, assign) int columnsBlockedLow;



-(id)init:(int)predefinedDifficulty;

-(void)addItem: (GameItem *) item;
-(void)removeItem:(GameItem *) item;
-(void)removeItems:(NSMutableArray *) items;
-(void)updateProbability;
-(void)updateView;

-(ShapeType)createShapeFromCollection;

-(ShapeType)createRandomShape;
-(ColorType)createRandomColor;

-(void)setDifficulty:(int)difficultyToSet;


@end

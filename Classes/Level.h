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
#import "LockShape.h"
#import "GameState.h"

typedef enum enum_Difficulty {
    VeryEasy,
    Easy,
    SortaEasy,
    NotSoEasy,
    SortaHard,
    Hard,
    VeryHard,
    Impossible
} Difficulty;

@interface Level : NSObject {
    Difficulty difficulty;
    NSMutableArray * solution;

    float shapeSpawnProbability [NUMBER_OF_SHAPES];
    int totalShapes [NUMBER_OF_SHAPES];
    
    ColorType maxColor;
    ShapeType maxShape;
    int lockCount;
    
    int attempts;
    
    GameState * gameState;
    
}

@property (readonly) Difficulty difficulty;
@property int attempts;
@property int lockCount;


-(id)init:(Difficulty)predefinedDifficulty;

-(void)SetLockAtIndex:(LockShape *)lock : (int) index;

-(LockShape *)GetLockAtIndex:(int)index;

-(BOOL)checkSolution:(NSMutableArray *)shapes;

-(BOOL)addSolutionToView:(UIView *)view;


-(void)addItem: (GameItem *) item;
-(void)removeItem:(GameItem *) item;
-(void)removeItems:(NSMutableArray *) items;
-(void)updateProbability;
-(void)updateView;

-(ShapeType)createShapeFromCollection;


-(ShapeType)createRandomShape;
-(ColorType)createRandomColor;

-(void)setDifficulty:(Difficulty)difficultyToSet;


@end

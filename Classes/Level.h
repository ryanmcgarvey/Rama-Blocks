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

typedef enum enum_Difficulty {
    Easy,
    Medium,
    Hard,
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
}

@property (readonly) Difficulty difficulty;

-(id)initWithSolution:(NSMutableArray *)predefinedSolution : (Difficulty)predefinedDifficulty;

-(id)init:(Difficulty)predefinedDifficulty;

-(BOOL)checkSolution:(NSMutableArray *)shapes;


-(void)addItem: (GameItem *) item;
-(void)removeItem:(GameItem *) item;
-(void)removeItems:(NSMutableArray *) items;
-(void)update;

-(ShapeType)createShapeFromCollection;


-(ShapeType)createRandomShape;
-(ColorType)createRandomColor;

-(void)setDifficulty:(Difficulty)difficultyToSet;


@end

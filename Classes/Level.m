//
//  Level.m
//  Rama Blocks
//
//  Created by Ryan McGarvey on 8/1/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import "Level.h"


@implementation Level
@synthesize difficulty;

/*****************************************************
Init
 *****************************************************/

-(id)init:(Difficulty)predefinedDifficulty{
    solution = [NSMutableArray new];
    [self setDifficulty:predefinedDifficulty];
    for (int i = 0; i < lockCount; i++) 
    {
        Shape * shape = [[Shape alloc] initWithInfo:[self createRandomColor] : [self createRandomShape]:CGPointMake(0,0)];
        [solution addObject: shape];
    }
    [self update];
    return self;
}

-(id)initWithSolution:(NSMutableArray *)predefinedSolution : (Difficulty)predefinedDifficulty{
    [self setDifficulty:predefinedDifficulty];
     solution = [predefinedSolution retain];
    [self update];
    return self;
}

/*****************************************************
Solution
 *****************************************************/
-(BOOL)checkSolution:(NSMutableArray *)shapes{
    if([shapes count] != [solution count])
        return FALSE;
    for(int i = 0; i < [shapes count]; i++)
    {
        Shape * guess = (Shape *) [shapes objectAtIndex:i];
        Shape * actual = (Shape *) [solution objectAtIndex:i];
        if(guess.shapeType != actual.shapeType ||
            guess.colorType != actual.colorType)
        {
            return FALSE;
        }
    }
    return TRUE;
}


/*****************************************************
 Collection Tracker
 *****************************************************/

-(void)addItem: (GameItem *) item{
    if([item isKindOfClass:[Shape class]])
    {
        Shape * shape = (Shape *)item;
        totalShapes[shape.shapeType] ++;
        [self update];
    }
}

-(void)removeItem:(GameItem *) item{
    
    if([item isKindOfClass:[Shape class]])
    {
        Shape * shape = (Shape *)item;
        totalShapes[shape.shapeType] --;
        [self update];
    }
}
-(void)removeItems:(NSMutableArray *) items
{
    for(GameItem * item in items)
    {
        if([item isKindOfClass:[Shape class]])
        {
            Shape * shape = (Shape *)item;
            totalShapes[shape.shapeType] --;
            [self update];
        }
    }
}

-(void)update{
    int total = totalShapes[Triangle] + totalShapes[Square] + totalShapes[Pentagon] + totalShapes[Hexagon] + totalShapes[Circle];
   
    if(total > 0 )
    {
        shapeSpawnProbability[Triangle] = totalShapes[Triangle]/(float)total;
        
        shapeSpawnProbability[Square] = shapeSpawnProbability[Triangle] + totalShapes[Square]/(float)total;
        
        shapeSpawnProbability[Pentagon] = shapeSpawnProbability[Square] + totalShapes[Pentagon]/(float)total;
        
        shapeSpawnProbability[Hexagon] = shapeSpawnProbability[Pentagon] + totalShapes[Hexagon]/(float)total;
        
        shapeSpawnProbability[Circle] =  shapeSpawnProbability[Hexagon] + totalShapes[Circle]/(float)total;
    }else{
        shapeSpawnProbability[Triangle] = 1;
    }
}

-(ShapeType)createShapeFromCollection{
    
    float probabilityCheck = (float)((uint)arc4random())/0xFFFFFFFF;  
    NSLog(@"Random item: %f", probabilityCheck);
    if(probabilityCheck <= shapeSpawnProbability[Triangle]){
        return Triangle;
    }
    if(probabilityCheck > shapeSpawnProbability[Triangle] && probabilityCheck <= shapeSpawnProbability[Square]){
        return Square;
    }
    if(probabilityCheck > shapeSpawnProbability[Square] && probabilityCheck <= shapeSpawnProbability[Pentagon]){
        return Pentagon;
    }
    if(probabilityCheck > shapeSpawnProbability[Pentagon] && probabilityCheck <= shapeSpawnProbability[Hexagon]){
        return Hexagon;
    }
    
    return Circle;
}


/*****************************************************
Helpers
 *****************************************************/

-(ShapeType)createRandomShape{
    return (uint)arc4random() % maxColor;
}

-(ColorType)createRandomColor{
    return (uint)arc4random() % maxColor;
}

-(void)setDifficulty:(Difficulty)difficultyToSet{
    difficulty = difficultyToSet;
    switch (difficulty) {
        case Easy:
            maxColor = 2;
            maxShape = Pentagon;
            lockCount = 3;
            break;
        case Medium:
            maxColor = 2;
            maxShape = Hexagon;
            lockCount = 4;
            break;
        case Hard:
            maxColor = 3;
            maxShape = Circle;
            lockCount = 5;
            break;
        case Impossible:
            maxColor = 4;
            maxShape = Circle;
            lockCount = 6;
            break;
        default:
            break;
    }
}
            
            
@end

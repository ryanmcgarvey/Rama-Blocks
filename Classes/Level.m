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
@synthesize attempts;

/*****************************************************
Init
 *****************************************************/

-(id)init:(Difficulty)predefinedDifficulty{
    solution = [NSMutableArray new];
    [self setDifficulty:predefinedDifficulty];
    for (int i = 0; i < lockCount; i++) 
    {
        LockShape * shape = [[LockShape alloc] initWithInfo:[self createRandomColor] : [self createRandomShape]:CGPointMake(LOCK_LOCATION_X + LOCK_LOCATION_X * i,LOCK_LOCATION_Y)];
        shape.canSeeColor = FALSE;
        shape.canSeeShape = FALSE;
        [solution addObject: shape];
    }
    [self updateProbability];
    return self;
}

/*****************************************************
Solution
 *****************************************************/
-(BOOL)addSolutionToView:(UIView *)view{
    [self updateView];
    for(Shape * shape in solution)
    {
        [view addSubview:shape];
    }
    [self updateProbability];
    return TRUE;
}

-(BOOL)checkSolution:(NSMutableArray *)shapes{
    if([shapes count] < [solution count])
        return FALSE;
    
    BOOL victory = TRUE;
    
    for(int i = 0; i < [solution count]; i++)
    {
        Shape * guess = (Shape *) [shapes objectAtIndex:i];
        LockShape * actual = (LockShape *) [solution objectAtIndex:i];
        if(guess.shapeType == actual.shapeType)
        {
            actual.canSeeShape = TRUE;
        }
        if(guess.colorType == actual.colorType)
        {
            actual.canSeeColor = TRUE;
        }
        if(guess.shapeType != actual.shapeType ||
            guess.colorType != actual.colorType)
        {
            victory = FALSE;
        }
    }
    [self updateView];
    attempts++;
    return victory;
}

/*****************************************************
 Collection Tracker
 *****************************************************/

-(void)addItem: (GameItem *) item{
    if([item isKindOfClass:[Shape class]])
    {
        Shape * shape = (Shape *)item;
        totalShapes[shape.shapeType] ++;
        [self updateProbability];
    }
}

-(void)removeItem:(GameItem *) item{
    
    if([item isKindOfClass:[Shape class]])
    {
        Shape * shape = (Shape *)item;
        totalShapes[shape.shapeType] --;
        [self updateProbability];
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
            [self updateProbability];
        }
    }
}

-(void)updateProbability{
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

-(void)updateView{
    for(LockShape * shape in solution)
    {
        [shape UpdateView];
    }
}

-(ShapeType)createShapeFromCollection{
    
    float probabilityCheck = (float)((uint)arc4random())/0xFFFFFFFF;  
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
    return (uint)arc4random() % (maxShape + 1);
}

-(ColorType)createRandomColor{
    return (uint)arc4random() % maxColor;
}

-(void)setDifficulty:(Difficulty)difficultyToSet{
    
    difficulty = difficultyToSet;
    switch (difficulty) {
        case VeryEasy:
            maxColor = 2;
            maxShape = Triangle;
            lockCount = 3;
            break;
        case Easy:
            maxColor = 2;
            maxShape = Square;
            lockCount = 3;
            break;
            
        case SortaEasy:
            maxColor = 3;
            maxShape = Pentagon;
            lockCount = 3;
            break;
        case NotSoEasy:
            maxColor = 3;
            maxShape = Hexagon;
            lockCount = 3;
            break;
        case SortaHard:
            maxColor = 3;
            maxShape = Hexagon;
            lockCount = 4;
            break;
        case Hard:
            maxColor = 3;
            maxShape = Circle;
            lockCount = 4;
            break;
            
        case VeryHard:
            maxColor = 4;
            maxShape = Circle;
            lockCount = 4;
            break;
        case Impossible:
            maxColor = 5;
            maxShape = Circle;
            lockCount = 5;
            break;

        default:
            maxColor = 5;
            maxShape = Circle;
            lockCount = 5;

            break;
    }
}
            
            
@end

//
//  Level.m
//  Rama Blocks
//
//  Created by Ryan McGarvey on 8/1/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import "Level.h"
#import "Rama_BlocksAppDelegate.h"


@implementation Level
@synthesize difficulty, rowsBlockedHigh, columnsBlockedHigh , rowsBlockedLow, columnsBlockedLow;


/*****************************************************
 Init
 *****************************************************/

-(id)init:(int)predefinedDifficulty{
    
	[self setDifficulty:predefinedDifficulty];
    [self updateProbability];
    return self;
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
-(void)removeItems:(NSMutableArray *) items{
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
    
}
-(ShapeType)createShapeFromCollection{
    //return Circle;
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
    int ret = (uint)arc4random() % (maxShape + 1);
	if(ret > Circle){
		NSLog(@"spawned super circle");
	}
	return ret;
}

-(ColorType)createRandomColor{
    return (uint)arc4random() % maxColor;
}

-(void)setDifficulty:(int)difficultyToSet{
    
    difficulty = difficultyToSet;
	
    
    switch (difficulty) {
        
        case 1:
            maxColor = 3;
            maxShape = Triangle;
			rowsBlockedHigh = 6;
			rowsBlockedLow = 3;
			columnsBlockedHigh = 6;
			columnsBlockedLow = 3;
            break;
            
        case 2:
            maxColor = 3;
            maxShape = Square;
			rowsBlockedHigh = 7;
			rowsBlockedLow = 2;
			columnsBlockedHigh = 6;
			columnsBlockedLow = 3;
            break;
        case 3:
            maxColor = 4;
            maxShape = Square;
			rowsBlockedHigh = 7;
			rowsBlockedLow = 2;
			columnsBlockedHigh = 7;
			columnsBlockedLow = 2;
            break;
        case 4:
            maxColor = 4;
            maxShape = Pentagon;
			rowsBlockedHigh = 7;
			rowsBlockedLow = 1;
			columnsBlockedHigh = 7;
			columnsBlockedLow = 2;
            break;
        case 5:
            maxColor = 5;
            maxShape = Pentagon;
			rowsBlockedHigh = 8;
			rowsBlockedLow = 1;
			columnsBlockedHigh = 7;
			columnsBlockedLow = 2;
            break;
            
        case 6:
            maxColor = 5;
            maxShape = Hexagon;
			rowsBlockedHigh = 8;
			rowsBlockedLow = 1;
			columnsBlockedHigh = 8;
			columnsBlockedLow = 1;
            break;
        case 7:
            maxColor = 5;
            maxShape = Hexagon;
			rowsBlockedHigh = 8;
			rowsBlockedLow = 0;
			columnsBlockedHigh = 8;
			columnsBlockedLow = 1;
            break;
            
        case 8:
            maxColor = 5;
            maxShape = Circle;
			rowsBlockedHigh = 9;
			rowsBlockedLow = 0;
			columnsBlockedHigh = 8;
			columnsBlockedLow = 1;
            break;
        case 9:
            maxColor = 5;
            maxShape = Circle;
			rowsBlockedHigh = 9;
			rowsBlockedLow = 0;
			columnsBlockedHigh = 9;
			columnsBlockedLow = 0;
            break;
		case 0:
            maxColor = 5;
            maxShape = Triangle;
			rowsBlockedHigh = 9;
			rowsBlockedLow = 0;
			columnsBlockedHigh = 9;
			columnsBlockedLow = 0;
            break;
    }
}


@end

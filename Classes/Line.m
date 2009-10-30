//
//  Line.m
//  Rama Blocks
//
//  Created by Ryan McGarvey on 10/10/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import "Line.h"


@implementation Line

/*
-(id)init:(ItemCollection *) _collection:(Level *) _level:(NSArray *) description{
    self = [super init];
    collection = _collection;
    level = _level;
    shapes = description;
    anchorShape = [shapes objectAtIndex:0];
    return self;
}

-(BOOL)CheckPhase{
    
    if([self SetAnchors]){
    
        for(Cell * cell in anchorCells){
            if([self CheckSolution: cell]){
                return TRUE;
            }
        }
    
    }
    
    return FALSE;
}

-(BOOL)CheckSolution:(Cell *) cell{

    if([self CheckSolutionForDirection:cell :1 :0])
        return TRUE;
    if([self CheckSolutionForDirection:cell :-1 :0])
        return TRUE;
    if([self CheckSolutionForDirection:cell :0 :1])
        return TRUE;
    if([self CheckSolutionForDirection:cell :0 :-1])
        return TRUE;
    return FALSE;

}

-(BOOL)CheckSolutionForDirection:(Cell *)cell:(int)rowDirection:(int)colDirection{
    
    Cell * current_cell = nil;
    int r = cell.Row;
    int c = cell.Column;
    //North
    for (int i = 1; i < [shapes count]; i++) 
    {
        r += rowDirection;
        c += colDirection;
        current_cell = [collection GetCell:r: c];
        if(![self IsShapeInCell:[shapes objectAtIndex:i] :current_cell])
            return FALSE;
    }
    return TRUE;
}

-(BOOL)SetAnchors{

    int i = 0;
    int j = 0;
    [anchorCells release];
    anchorCells = [NSMutableArray new];
    Cell * current_cell = nil;
    for(i = 0;i < NUMBER_OF_ROWS; i++)
    {
        for(j = 0; j < NUMBER_OF_COLUMNS; j++)
        {
            current_cell = [collection GetCell:i : j];
            if([self IsShapeInCell:anchorShape :current_cell])
            {
                [anchorCells addObject:current_cell];
            }
        }
    }
     return ([anchorCells count] > 0);
}

*/

@end

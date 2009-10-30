//
//  Set.m
//  Rama Blocks
//
//  Created by Ryan McGarvey on 10/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Set.h"


@implementation Set
/*

-(id)init:(ItemCollection *) _collection:(Level *) _level:(NSDictionary *) description{
    self = [super init];
    collection = _collection;
    level = _level;
    shapes = description;
    anchorShape = [shapes objectAtIndex:0];
    return self;
}

-(BOOL)CheckPhase{

    for (Shape * shape in shapes) {
        if(![self IsShapeInCollection: shape : [shapes objectForKey:shape]]){
            return FALSE;
        }
    }

}

-(BOOL)IsShapeInCollection:(Shape *) shape: (int) count{

    
    int i = 0;
    int j = 0;
    int found = 0;
    Cell * current_cell = nil;
    for(i = 0;i < NUMBER_OF_ROWS; i++)
    {
        for(j = 0; j < NUMBER_OF_COLUMNS; j++)
        {
            current_cell = [collection GetCell:i : j];
            if([self IsShapeInCell:anchorShape :current_cell])
            {
                found++;
                if(found >= count){
                    return TRUE;
                }
            }
        }
    }
}
*/
@end

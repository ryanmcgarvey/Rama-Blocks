//
//  Line.h
//  Rama Blocks
//
//  Created by Ryan McGarvey on 10/10/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Phase.h"
#import "ItemCollection.h"
#import "Shape.h"


@interface Line : Phase {

    NSDictionary * shapes;
    
    Shape * anchorShape;
    NSMutableArray * anchorCells;
    
    
}
-(id)init:(ItemCollection *) _collection:(Level *) _level:(NSArray *) description;

-(BOOL)SetAnchors;

-(BOOL)CheckSolution:(Cell *) cell;

-(BOOL)CheckSolutionForDirection:(Cell *)cell:(int)rowDirection:(int)colDirection;

@end

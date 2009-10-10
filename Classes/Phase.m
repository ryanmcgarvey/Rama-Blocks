//
//  Phase.m
//  Rama Blocks
//
//  Created by Ryan McGarvey on 10/10/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import "Phase.h"


@implementation Phase

-(BOOL)CheckPhase{
    return FALSE;
}

-(BOOL)IsShapeInCell:(Shape *)shape:(Cell *)cell{
    
    if ([cell.ItemInCell isKindOfClass:[Shape class]] ) 
    {
        Shape * cellShape = (Shape *)(cell.ItemInCell);
        return (shape.colorType == cellShape.colorType &&
                shape.shapeType == cellShape.shapeType);
    }
    return FALSE;
}



@end

//
//  levelStatistics.h
//  Rama Blocks
//
//  Created by Ryan McGarvey on 8/2/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalDefines.h"
#include "Shape.h"

@interface levelStatistics : NSObject {

    int attempts;
    int totalDrops [NUMBER_OF_COLORS][NUMBER_OF_SHAPES];
    
    int totalTransform [NUMBER_OF_COLORS][NUMBER_OF_SHAPES];
    
    //time info
    //gravity stats
    //num transforms
    //
    
}

@property int attempts;

-(void)addShapeToDrop:(Shape *)shape;
-(void)addShapeToTransform:(Shape *)shape;
@end

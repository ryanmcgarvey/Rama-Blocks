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
    
}

@property int attempts;

-(void)addShapeToCollection:(Shape *)shape;

@end

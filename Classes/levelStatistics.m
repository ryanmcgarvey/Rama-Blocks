//
//  levelStatistics.m
//  Rama Blocks
//
//  Created by Ryan McGarvey on 8/2/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import "levelStatistics.h"


@implementation levelStatistics
@synthesize attempts;

-(void)addShapeToCollection:(Shape *)shape{
}
-(void)addShapeToDrop:(Shape *)shape{
    totalDrops[shape.colorType][shape.shapeType]++;
}
-(void)addShapeToTransform:(Shape *)shape{
    totalTransform[shape.colorType][shape.shapeType]++;
}

@end

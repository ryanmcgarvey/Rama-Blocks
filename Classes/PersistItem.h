//
//  PersistItem.h
//  Rama Blocks
//
//  Created by Ryan McGarvey on 8/7/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Shape.h"


@interface PersistItem : NSObject {
    ShapeType shapeType;
    ColorType colorType;
    BOOL Active;
}



@property ShapeType shapeType;
@property ColorType colorType;
@property BOOL Active;
@end

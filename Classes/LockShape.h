//
//  LockShape.h
//  Rama Blocks
//
//  Created by Ryan McGarvey on 8/1/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Shape.h"

@interface LockShape : Shape {

     BOOL canSeeShape;
     BOOL canSeeColor;
    
}

@property BOOL canSeeShape;
@property BOOL canSeeColor;


-(void)UpdateView;

@end

//
//  Cell.h
//  Rama Blocks
//
//  Created by Ryan McGarvey on 7/29/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage+Shapes.h"
#import "GlobalDefines.h"
#import "GameItem.h"

@interface Cell : NSObject {
@public;
    GameItem * ItemInCell;
    int Row;
    int Column;
    
    CGPoint Center;
    
    BOOL IsTransforming;
}

- (id)initWithData : (CGPoint)center : (int) row: (int) column;

@end

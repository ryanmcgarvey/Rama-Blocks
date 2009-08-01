//
//  GameItem.m
//  Rama Blocks
//
//  Created by Ryan McGarvey on 7/29/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import "GameItem.h"


@implementation GameItem


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        tapped = 0;
        IsPaired = TRUE;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [ItemView dealloc];
    [super dealloc];
}


-(void)SnapShape:(int)newRow : (int)newColumn {
	Row = Row;
	Column = Column;
}
@end

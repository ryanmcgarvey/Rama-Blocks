//
//  GameItem.m
//  Rama Blocks
//
//  Created by Ryan McGarvey on 7/29/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import "GameItem.h"


@implementation GameItem
@synthesize ItemView, tapped, IsPaired, Row, Column, IsAnchored;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        tapped = 0;
        IsPaired = FALSE;
		IsAnchored = NO;
        self.clearsContextBeforeDrawing = YES;

    }
    return self;
}

- (void)drawRect:(CGRect)rect{

}

- (void)dealloc {
    //[ItemView release];
    [super dealloc];
}

-(void)SnapShape:(int)newRow : (int)newColumn {
	Row = Row;
	Column = Column;
}
@end

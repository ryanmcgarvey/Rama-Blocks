//
//  Cell.m
//  Rama Blocks
//
//  Created by Ryan McGarvey on 7/29/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import "Cell.h"


@implementation Cell
@synthesize ItemInCell, Row, Column, Center, IsTransforming;

- (id)initWithData :(CGPoint)center : (int) row: (int) column{
	if ((self = [super init])) 
    {	
		ItemInCell = nil;
		Row = row;
		Column = column;
		Center = center;
        IsTransforming = FALSE;
	}
	return self;
}

- (void)dealloc {
    [ItemInCell release];
    [super dealloc];
}
@end

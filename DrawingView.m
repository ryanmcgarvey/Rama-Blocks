//
//  DrawingView.m
//  Rama Blocks
//
//  Created by Chad Gapac on 8/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DrawingView.h"


@implementation DrawingView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
		ItemView = [[UIImageView alloc] initWithFrame:frame];
		ItemView.image = [UIImage imageNamed:@"ItemC.png"];
		[self addSubview:ItemView];
    
	}
    return self;
}


- (void)drawRect:(CGRect)rect {
	
	self.center = circleDrawingPoint;
}

-(CGPoint)makeCirclePoint:(CGPoint)itemA :(CGPoint)itemB{
	int x;
	int y;
	x = (itemA.x + itemB.x)/2;
	y = (itemA.y + itemB.y)/2;
	circleDrawingPoint = CGPointMake(x,y);
	
	return circleDrawingPoint;
}
	

- (void)dealloc {
    [super dealloc];
}


@end

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
		[self addSubview:ItemView];
		[self drawRect:frame];
    
	}
    return self;
}


- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
	//CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 1);
	CGContextSetRGBFillColor(ctx, 255, 255, 255, 1);
	CGContextFillEllipseInRect(ctx, CGRectMake(.5f, .5f, 90, 90));
	//CGContextStrokeEllipseInRect(ctx, CGRectMake(15, 15, 90, 90));
	
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

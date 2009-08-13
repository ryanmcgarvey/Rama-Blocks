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
	CGContextSetRGBStrokeColor(ctx, 0, 0, 255, 1);
    CGContextStrokeEllipseInRect(ctx, CGRectMake(0, 0, 89, 89));
	self.center = circleDrawingPoint;
}

-(void)makeCirclePoint:(CGPoint)itemA :(CGPoint)itemB{
	int x;
	int y;
	x = (itemA.x + itemB.x)/2;
	y = (itemA.y + itemB.y)/2;
	circleDrawingPoint = CGPointMake(x,y);
	
}
	

- (void)dealloc {
    [super dealloc];
}


@end

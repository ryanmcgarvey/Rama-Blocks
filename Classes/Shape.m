//
//  Shape.m
//  Rama Blocks
//
//  Created by Ryan McGarvey on 7/29/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import "Shape.h"


@implementation Shape


- (id)initWithInfo:(CGRect)frame : (ColorType)cType : (ShapeType) sType{
    
    if (self = [super initWithFrame:frame]) 
    {
        ItemView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SHAPE_WIDTH, SHAPE_WIDTH)];
		[self ChangeColorAndShape: cType : sType];  
        [self addSubview:ItemView];
    }
    return self;
}

-(BOOL)ChangeColorAndShape: (ColorType)cType : (ShapeType) sType{
	colorType = cType;
	shapeType = sType;
    ItemView.image = [UIImage imageWithColorAndShape: cType : sType];
	self.backgroundColor = [UIColor clearColor];
	return TRUE;
}


-(BOOL)TransForm{
	shapeType = shapeType ++ % NUMBER_OF_SHAPES;
	[self ChangeColorAndShape:colorType :shapeType];
	return TRUE;
}




- (void)dealloc {
    [super dealloc];
}


-(BOOL)Equals:(Shape *)shape{
    
    return(shapeType == shape->shapeType && colorType == shape->colorType);
}

@end

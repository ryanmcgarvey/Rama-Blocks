//
//  Shape.m
//  Rama Blocks
//
//  Created by Ryan McGarvey on 7/29/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import "Shape.h"


@implementation Shape

@synthesize shapeType, colorType;

- (id)initWithInfo:(ColorType)cType : (ShapeType) sType:(CGPoint)location{  
    CGRect frame = CGRectMake(0.0f, 0.0f, SHAPE_WIDTH, SHAPE_WIDTH);
    if (self = [super initWithFrame:frame]) 
    {
        self.center = location;
        ItemView = [[UIImageView alloc] initWithFrame:frame];
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
    
    return(shapeType == shape.shapeType && colorType == shape.colorType);
}

-(BOOL)IsNeighbor:(Shape *)shape{
    uint row = abs(Row - shape.Row);
    uint column = abs(Column - shape.Column);
    
    return ( (column == 0 && row ==1) || (column == 1 && row == 0));
}
@end

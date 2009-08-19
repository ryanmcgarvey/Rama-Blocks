//
//  LockShape.m
//  Rama Blocks
//
//  Created by Ryan McGarvey on 8/1/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import "LockShape.h"


@implementation LockShape

@synthesize canSeeColor, canSeeShape;




-(void)UpdateView{
	
    if(canSeeColor && canSeeShape){
		ItemView.alpha = 1;
		self.backgroundColor = [UIColor clearColor];
		NSString * color;
		NSString * shape;
		switch(shapeType){
			case Triangle:
				shape = [NSString stringWithFormat:@"triangle"];
				break;
			case Square:
				shape = [NSString stringWithFormat:@"square"];
				break;
			case Pentagon:
				shape = [NSString stringWithFormat:@"pentagon"];
				break;
			case Hexagon:
				shape = [NSString stringWithFormat:@"hexagon"];
				break;
			case Circle:
				shape = [NSString stringWithFormat:@"circle"];
				break;
		}
		switch(colorType){
			case Red:
				color = [NSString stringWithFormat:@"red"];
				break;
			case Purple:
				color = [NSString stringWithFormat:@"purple"];
				break;
			case Yellow:
				color = [NSString stringWithFormat:@"yellow"];
				break;
			case Green:
				color = [NSString stringWithFormat:@"green"];
				break;
			case Blue:
				color = [NSString stringWithFormat:@"blue"];
				break;
		}
		NSString *theImage = [NSString stringWithFormat:@"%@%@.png", color, shape];
		ItemView.image = [UIImage imageNamed:theImage];
		return;
	}
    if(canSeeColor){
        
        ItemView.alpha = 1;
        switch(colorType)
        {
            case Red:
                ItemView.image = [UIImage imageNamed:@"redglow.png"];
                return;
            case Green:
                ItemView.image = [UIImage imageNamed:@"greenglow.png"];
                return;
            case Blue:
                ItemView.image = [UIImage imageNamed:@"blueglow.png"];
                return;
            case Purple:
                ItemView.image = [UIImage imageNamed:@"purpleglow.png"];
                return;
            case Yellow:
				ItemView.image = [UIImage imageNamed:@"yellowglow.png"];
                return;
        }
        return;
    }
    if(canSeeShape){
		ItemView.alpha = 1;
		self.backgroundColor = [UIColor clearColor];
		switch(shapeType){
			case Triangle:
				ItemView.image = [UIImage imageNamed:@"greytriangle.png"];
				return;
			case Square:
				ItemView.image = [UIImage imageNamed:@"greysquare.png"];
				return;
			case Pentagon:
				ItemView.image = [UIImage imageNamed:@"greypentagon.png"];
				return;
			case Hexagon:
				ItemView.image = [UIImage imageNamed:@"greyhexagon.png"];
				return;
			case Circle:
				ItemView.image = [UIImage imageNamed:@"greycircle.png"];
				return;
		}
		return;
	}			
    ItemView.alpha = 0.0f;
    self.backgroundColor = [UIColor clearColor];
}


@end

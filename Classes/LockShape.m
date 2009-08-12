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
			case Orange:
				color = [NSString stringWithFormat:@"orange"];
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
        
        ItemView.alpha = 0;
        switch(colorType)
        {
            case Red:
                self.backgroundColor = [UIColor redColor];
                return;
            case Green:
                self.backgroundColor = [UIColor greenColor];
                return;
            case Blue:
                self.backgroundColor = [UIColor blueColor];
                return;
            case Orange:
                self.backgroundColor = [UIColor orangeColor];
                return;
            case Yellow:
               self.backgroundColor = [UIColor yellowColor];
                return;
        }
        return;
    }
    if(canSeeShape){
		ItemView.alpha = 1;
		self.backgroundColor = [UIColor clearColor];
		switch(shapeType){
			case Triangle:
				ItemView.image = [UIImage imageNamed:@"whitetriangle.png"];
				return;
			case Square:
				ItemView.image = [UIImage imageNamed:@"whitesquare.png"];
				return;
			case Pentagon:
				ItemView.image = [UIImage imageNamed:@"whitepentagon.png"];
				return;
			case Hexagon:
				ItemView.image = [UIImage imageNamed:@"whitehexagon.png"];
				return;
			case Circle:
				ItemView.image = [UIImage imageNamed:@"whitecircle.png"];
				return;
		}
		return;
	}			
    ItemView.alpha = 0.0f;
    self.backgroundColor = [UIColor clearColor];
}


@end

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
    if(canSeeColor && canSeeShape)
    {
        self.backgroundColor = [UIColor clearColor];
        ItemView.alpha = 1.0f;
        return;
    }
    if(canSeeColor)
    {
        
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
    if(canSeeShape)
    {
        
        ItemView.alpha = 0.5f;
        self.backgroundColor = [UIColor whiteColor];
        return;
    }
    ItemView.alpha = 0.0f;
    self.backgroundColor = [UIColor clearColor];
}


@end

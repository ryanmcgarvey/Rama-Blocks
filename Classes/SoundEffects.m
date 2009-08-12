//
//  SoundEffects.m
//  Rama Blocks
//
//  Created by Ryan McGarvey on 8/1/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import "SoundEffects.h"



@implementation SoundEffects
@synthesize volume;

-(void)playTransform{
    if(transform == nil)
        transform = [[SoundPlayer alloc] init:@"/transform.wav"];
    [transform changeVolume:volume];
    [transform play];
}
-(void)playVictory {
    if(victory == nil)
        victory = [[SoundPlayer alloc] init:@"/victory.wav"];
    [transform changeVolume:volume];
    [victory play];

}

    


@end

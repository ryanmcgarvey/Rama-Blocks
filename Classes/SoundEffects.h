//
//  SoundEffects.h
//  Rama Blocks
//
//  Created by Ryan McGarvey on 8/1/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "SoundPlayer.h"

@interface SoundEffects : NSObject{
    SoundPlayer * transform;
    SoundPlayer * victory;
    float volume;
}

@property float volume;

-(void)playTransform;
-(void)playVictory;

@end

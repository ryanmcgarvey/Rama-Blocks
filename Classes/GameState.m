//
//  GameState.m
//  Rama Blocks
//
//  Created by Ryan McGarvey on 8/1/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import "GameState.h"


@implementation GameState

@synthesize currentDifficulty, audio;

-(id)init{
    audio = [SoundEffects new];
    currentDifficulty = VeryEasy;
    return self;
}

@end

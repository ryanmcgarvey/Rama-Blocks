//
//  GameState.h
//  Rama Blocks
//
//  Created by Ryan McGarvey on 8/1/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SoundEffects.h"
#import "Level.h"

@interface GameState : NSObject {
    SoundEffects * audio;
    Difficulty currentDifficulty;
}

@property (readonly) SoundEffects * audio;
@property Difficulty currentDifficulty;

@end

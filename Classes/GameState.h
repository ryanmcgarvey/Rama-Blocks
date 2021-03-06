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
#import "ItemCollection.h"

@interface GameState : NSObject {
    SoundEffects * audio;
    Difficulty currentDifficulty;
    float volume;
    //id *mirrorCells;

}


//@property(retain)id *mirrorCells;
@property (readwrite, assign) float volume;
@property (readwrite, retain) SoundEffects * audio;
@property Difficulty currentDifficulty;

-(void)initNonPersist;
- (void)createMirrorCells:(id *)mirrorCell;
-(SoundEffects *)GetAudioPlayer;

@end

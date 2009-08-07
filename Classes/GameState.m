//
//  GameState.m
//  Rama Blocks
//
//  Created by Ryan McGarvey on 8/1/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import "GameState.h"


@implementation GameState

@synthesize currentDifficulty, audio, volume;

-(id)init{
    [self initNonPersist];
    volume = audio.volume;
    currentDifficulty = VeryEasy;
//mirrorCells = malloc((12 * 10)*sizeof(Cell *));
    
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super init];
	if( self != nil )
	{
		//self = [[decoder decodeObjectForKey:@"encodedState"]retain];
        self.currentDifficulty = [decoder decodeIntForKey:@"encodedStateDifficulty"];
        float CurrentVolume = [decoder decodeFloatForKey:@"encodedStateVolume"];
        self.volume = CurrentVolume;
        [self initNonPersist];
	}
	return self;
}
-(void)initNonPersist{
    audio = [SoundEffects new];
}
- (void)encodeWithCoder:(NSCoder *)encoder
{
    int CurrentDifficulty;
    CurrentDifficulty = self.currentDifficulty;
    [encoder encodeInt:CurrentDifficulty forKey:@"encodedStateDifficulty"];
    [encoder encodeFloat:volume forKey:@"encodedStateVolume"];
}

- (void)createMirrorCells:(id *)mirrorCell
{
    //self.mirrorCells = mirrorCell;
    
    
}

-(SoundEffects *)GetAudioPlayer{
    if(audio == nil){
        audio = [SoundEffects new];
    }
    return audio;
}


-(void)dealloc{
    [audio dealloc];
    [super dealloc];
}
@end

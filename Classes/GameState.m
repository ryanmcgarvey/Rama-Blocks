//
//  GameState.m
//  Rama Blocks
//
//  Created by Ryan McGarvey on 8/1/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import "GameState.h"


@implementation GameState

@synthesize currentDifficulty, audio, sfxVolume, musicVolume, Active;

-(id)init{
    [self initNonPersist];
    sfxVolume = audio.volume;
    currentDifficulty = VeryEasy;
    musicVolume = audio.volume;
    Active = FALSE;
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
        self.sfxVolume = [decoder decodeFloatForKey:@"encodedSfxVolume"];
        self.musicVolume = [decoder decodeFloatForKey:@"encodedMusicVolume"];
        self.Active = [decoder decodeBoolForKey:@"encodeActive"];
        [self initNonPersist];
	}
	return self;
}
-(void)initNonPersist{
    audio = [SoundEffects new];
    
}
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInt:currentDifficulty forKey:@"encodedStateDifficulty"];
    [encoder encodeFloat:sfxVolume forKey:@"encodedSfxVolume"];
    [encoder encodeFloat:musicVolume forKey:@"encodedMusicVolume"];
    [encoder encodeBool:Active forKey:@"encodeActive"];
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

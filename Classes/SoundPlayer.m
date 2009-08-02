//
//  SoundPlayer.m
//  Rama Blocks
//
//  Created by Ryan McGarvey on 8/1/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import "SoundPlayer.h"


@implementation SoundPlayer

-(id)init : (NSString *) fileToPlay;{
    volume = 0.5f;
    //((RumbaBlocksAppDelegate *)[UIApplication sharedApplication].delegate).SfxVolume;
		
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    resourcePath = [resourcePath stringByAppendingString:fileToPlay];
    NSError* err;
    
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:resourcePath] error:&err];
    
    if( err )
    {
        NSLog(@"Failed with reason: %@", [err localizedDescription]);
    }else{
        [player prepareToPlay];
    }

return self;
}

-(void)changeVolume:(float)volumeToSet{
    volume = volumeToSet;
}


-(void)play{
	if(player)
    {
        [player stop];
        player.currentTime = 0.0f;
        player.volume = volume;
        [player play];
    }
}

- (void)dealloc {
	/*This will never happen, but cleaning up is good*/
	if( player )
    {
		[player stop];
		[player release];
		player = nil;
	}
    
    [super dealloc];
}

@end

//
//  SoundPlayer.h
//  Rama Blocks
//
//  Created by Ryan McGarvey on 8/1/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface SoundPlayer : NSObject {
	AVAudioPlayer * player;
	float  volume;
}

-(id)init : (NSString *) fileToPlay;
-(void)play;
-(void)changeVolume:(float)volumeToSet;
@end

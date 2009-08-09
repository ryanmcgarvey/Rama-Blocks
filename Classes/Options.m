//
//  Options.m
//  RamaMenu
//
//  Created by Chad Gapac on 7/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Options.h"
#import "Rama_BlocksAppDelegate.h"

@implementation Options

@synthesize sfxVolume, musicVolume;

- (void)viewDidLoad {
    Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
    gameState = [[appDelegate FetchGameState] retain];
    sfxVolume.value = [gameState.sfxVolume floatValue];
    musicVolume.value = [gameState.musicVolume floatValue];
    [super viewDidLoad];
}


- (IBAction)returnToMenu:(id)sender 
{
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)changeShapeColors{
    
}

-(void)changeMusicVolume{
    gameState.musicVolume = [NSNumber numberWithFloat:musicVolume.value];
}
-(void)changeSfxVolume{
    gameState.sfxVolume = [NSNumber numberWithFloat:sfxVolume.value];
}




- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    
}

- (void)dealloc {
    [gameState release];
    [super dealloc];
}


@end

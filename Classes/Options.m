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

@synthesize sfxVolume, musicVolume, difficulty;

- (void)viewDidLoad {
    Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
    gameState = appDelegate.gameState;
    sfxVolume.value = gameState.audio.volume;

    difficulty.value = (float)gameState.currentDifficulty / NUMBER_OF_DIFF;
    
    [super viewDidLoad];
}


- (IBAction)returnToMenu:(id)sender 
{
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)changeShapeColors{
    
}

-(void)changeMusicVolume{
}
-(void)changeSfxVolume{
    gameState.audio.volume = sfxVolume.value;
}
-(void)changeDifficulty{
    Difficulty diff = (Difficulty)(difficulty.value * NUMBER_OF_DIFF);
    NSLog(@"Setting Difficulty %d", diff);
    if(diff == NUMBER_OF_DIFF)
        diff--;
    gameState.currentDifficulty = diff;
}




- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

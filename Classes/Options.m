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

@synthesize sfxVolume, musicVolume, difficulty, difficultyLabel;

- (void)viewDidLoad {
    Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
    gameState = [appDelegate loadEncodedGameState];
    sfxVolume.value = gameState.sfxVolume;
    musicVolume.value = gameState.musicVolume;
    difficulty.maximumValue = NUMBER_OF_DIFF - 1;
    difficulty.minimumValue = 0;
    difficulty.value = gameState.currentDifficulty;
    [self changeDifficulty];
    
    [super viewDidLoad];
}


- (IBAction)returnToMenu:(id)sender 
{
	[self dismissModalViewControllerAnimated:YES];
    Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate saveEncodedGameState];
}

- (IBAction)changeShapeColors{
    
}

-(void)changeMusicVolume{
    gameState.musicVolume = musicVolume.value;
}
-(void)changeSfxVolume{
    gameState.audio.volume = sfxVolume.value;
    gameState.sfxVolume = sfxVolume.value;
}
-(void)changeDifficulty{
    Difficulty diff = (Difficulty)(difficulty.value);
    switch (diff) {
        case VeryEasy:
            difficultyLabel.text = @"Very Easy";
            break;
        case Easy:
            difficultyLabel.text = @"Easy";
            break;
        case SortaEasy:
            difficultyLabel.text = @"Sorta Easy";
            break;
        case NotSoEasy:
            difficultyLabel.text = @"Not So Easy";
            break;
        case SortaHard:
            difficultyLabel.text = @"Sorta Hard";
            break;
        case Hard:
           difficultyLabel.text = @"Hard";
            break;
        case VeryHard:
            difficultyLabel.text = @"Very Hard";
            break;
        case Impossible:
            difficultyLabel.text = @"Impossible";
            break;
    }
    
    gameState.currentDifficulty = diff;
}




- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    
}


- (void)dealloc {
    [super dealloc];
}


@end

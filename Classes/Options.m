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
    gameState = [[appDelegate FetchGameState] retain];
    sfxVolume.value = [gameState.sfxVolume floatValue];
    musicVolume.value = [gameState.musicVolume floatValue];
    difficulty.maximumValue = NUMBER_OF_DIFF - 1;
    difficulty.minimumValue = 0;
    difficulty.value = [gameState.currentDifficulty intValue];
    [self changeDifficulty];
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
    
    gameState.currentDifficulty = [NSNumber numberWithInt:diff];
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

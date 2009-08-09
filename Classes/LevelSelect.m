//
//  LevelSelect.m
//  Rama Blocks
//
//  Created by Ryan McGarvey on 8/9/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import "LevelSelect.h"
#import "Rama_BlocksAppDelegate.h"


@implementation LevelSelect



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
    gameState = [[appDelegate FetchGameState] retain];
    levelSelect.value = [gameState.currentLevel floatValue];
    
    
    recapText.text = [NSString stringWithFormat:@"Number of Attempts: %d", [gameState.currentBoard.numberOfAttempts intValue]];

    [self ChangeLevel];
    [super viewDidLoad];
}
- (IBAction)returnToMenu
{
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction)ChangeLevel{
    
    int level = levelSelect.value;
    
    if(level > [gameState.highestLevel intValue])
    {
        
        level = [gameState.highestLevel intValue];
        levelSelect.value = level;
    }
    switch (level) {
        case VeryEasy:
            levelLabel.text = @"Very Easy";
            break;
        case Easy:
            levelLabel.text = @"Easy";
            break;
        case SortaEasy:
            levelLabel.text = @"Sorta Easy";
            break;
        case NotSoEasy:
            levelLabel.text = @"Not So Easy";
            break;
        case SortaHard:
            levelLabel.text = @"Sorta Hard";
            break;
        case Hard:
            levelLabel.text = @"Hard";
            break;
        case VeryHard:
            levelLabel.text = @"Very Hard";
            break;
        case Impossible:
            levelLabel.text = @"Impossible";
            break;
        default:
            levelLabel.text = @"Good luck";
        break;
    }
    
    gameState.currentLevel = [NSNumber numberWithInt:level];
}
-(IBAction)PlayLevel{
    [self presentModalViewController:[[GameBoardViewController alloc] initWithNibName:@"GameBoardViewController" bundle:nil] animated:YES];
}
- (void)viewWillAppear:(BOOL)animate{
    Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];

    NSArray * levels = [appDelegate FetchPlayedLevels];
    
    LevelStatistics * latest = [levels lastObject];
    
    recapText.text = [NSString stringWithFormat:
                      @"Number of Attempts: %d \n\
 Number of Transforms: %d \n\
 Number of Moves: %d \n\
 Time: %f", 
                      [latest.numerOfAttempts intValue],
                      [latest.numberOfTransforms intValue],
                      [latest.numberOfMoves intValue],
                      [latest.timeToComplete doubleValue]];
    levelSelect.value = [gameState.currentLevel intValue];
    [self ChangeLevel];
    
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

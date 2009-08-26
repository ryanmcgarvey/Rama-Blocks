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

-(IBAction)changeColor{
	Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.level.selectMaxColor = (int)colorSelect.value;
	colorAmount.text = [NSString stringWithFormat:@"Maximum Colors Spawned: %d", (int)colorSelect.value];
}
-(IBAction)changeShape{
	Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.level.selectMaxShape = (int)shapeSelect.value;
	shapeAmount.text = [NSString stringWithFormat:@"Maximum Shapes Spawned: %d", (int)shapeSelect.value];
}
-(IBAction)changeLock{
	Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.level.selectMaxLock = (int)lockSelect.value;
	lockAmount.text = [NSString stringWithFormat:@"Maximum Locks Spawned: %d", (int)lockSelect.value];
}

-(IBAction)ChangeLevel{
    
    int level = levelSelect.value;
    
    if(level > [gameState.highestLevel intValue])
    {
        
        level = [gameState.highestLevel intValue];
        levelSelect.value = level;
    }
    switch (level) {
        case 0:
            //levelLabel.text = @"Very Easy";
            break;
        case 1:
            //levelLabel.text = @"Easy";
            break;
        case 2:
            //levelLabel.text = @"Sorta Easy";
            break;
        case 3:
            //levelLabel.text = @"Not So Easy";
            break;
        case 4:
            //levelLabel.text = @"Sorta Hard";
            break;
        case 5:
            //levelLabel.text = @"Hard";
            break;
        case 6:
            //levelLabel.text = @"Very Hard";
            break;
        case 7:
            //levelLabel.text = @"Impossible";
            break;
        case 8:
            //levelLabel.text = @"Good luck";
            break;
        case 9:
            //levelLabel.text = @"You're not gonna get this far";
            break;
    }
    
    gameState.currentLevel = [NSNumber numberWithInt:level];
}
-(IBAction)PlayLevel{
	[self changeLock];
	[self changeColor];
	[self changeShape];
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

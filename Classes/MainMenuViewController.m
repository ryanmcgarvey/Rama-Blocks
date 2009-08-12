//
//  MainMenuViewController.m
//  MainMenu
//
//  Created by Johnny Moralez on 6/23/09.
//  Copyright 2009 Simplical, LLC. All rights reserved.
//

#import "MainMenuViewController.h"
#import "Rama_BlocksAppDelegate.h"



@implementation MainMenuViewController
@synthesize testAnimation, testImages;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
        gameState = [[appDelegate FetchGameState] retain];
    }
    
    return self;
}
- (void)viewWillAppear:(BOOL)animate{
    if([gameState.currentBoard.Active boolValue])
    {
        
        [GameBoardButton setTitle: @"Play Puzzle Mode" forState:UIControlStateNormal];
    }
    /*
	else{
        [GameBoardButton setTitle: @"Play" forState:UIControlStateNormal];
    }
	 */
    [GameBoardButton.titleLabel setNeedsLayout];

    [super viewWillAppear:animate];
}
- (void)viewDidLoad {
	
	testImages = [[NSMutableArray alloc] init];
	
	for(int i = 1; i < 13; i++){
		NSString *theImage = [NSString stringWithFormat:@"flag%d.png", i];
		NSLog(@"%@", theImage); 
		UIImage *flag = [UIImage imageNamed:theImage];
		[testImages addObject:flag];
	}
	
	[testAnimation setAnimationImages:testImages];
	[testAnimation setAnimationDuration:1.0f];
	[testAnimation startAnimating];
	
	
	[super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {

}


- (void)dealloc {
    [super dealloc];
}

- (IBAction)loadOptions:(id)sender 
{	
	[self presentModalViewController:[[Options alloc] initWithNibName:@"Options" bundle:nil] animated:YES];
}


- (IBAction)loadTutorial:(id)sender 
{
	
	[self presentModalViewController:[[Tutorial alloc] initWithNibName:@"Tutorial" bundle:nil] animated:YES];
	
}
- (IBAction)loadLevelSelect:(id)sender 
{
	[self presentModalViewController:[[LevelSelect alloc] initWithNibName:@"LevelSelect" bundle:nil] animated:YES];
}

- (IBAction)loadGameBoard:(id)sender 
{
	Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.gameType = 1;
	[self presentModalViewController:[[GameBoardViewController alloc] initWithNibName:@"GameBoardViewController" bundle:nil] animated:YES];
}

- (IBAction)loadTimeBoard:(id)sender 
{
	Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.gameType = 2;
	[self presentModalViewController:[[GameBoardViewController alloc] initWithNibName:@"GameBoardViewController" bundle:nil] animated:YES];
}

@end

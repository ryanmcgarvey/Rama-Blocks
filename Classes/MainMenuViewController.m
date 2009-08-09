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
        
        [GameBoardButton setTitle: @"Continue" forState:UIControlStateNormal];
    }
    else{
        [GameBoardButton setTitle: @"Play" forState:UIControlStateNormal];
    }  
    [GameBoardButton.titleLabel setNeedsLayout];

    [super viewWillAppear:animate];
}
- (void)viewDidLoad {

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
	[self presentModalViewController:[[GameBoardViewController alloc] initWithNibName:@"GameBoardViewController" bundle:nil] animated:YES];
}

@end

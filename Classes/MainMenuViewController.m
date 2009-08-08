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

@synthesize options, profile, tutorial, purchase;


- (void)viewDidLoad {
    Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
    gameState = [appDelegate loadEncodedGameState];

	[super viewDidLoad];
    
    if(gameState.Active)
    {
        [self presentModalViewController:[[GameBoardViewController alloc] initWithNibName:@"GameBoardViewController" bundle:nil] animated:YES];
    }

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

- (IBAction)loadProfile:(id)sender 
{
	
	[self presentModalViewController:[[Profile alloc] initWithNibName:@"Profile" bundle:nil] animated:YES];

	
}

- (IBAction)loadTutorial:(id)sender 
{
	
	[self presentModalViewController:[[Tutorial alloc] initWithNibName:@"Tutorial" bundle:nil] animated:YES];
	
}

- (IBAction)loadPurchase:(id)sender 
{
	
	[self presentModalViewController:[[Purchase alloc] initWithNibName:@"Purchase" bundle:nil] animated:YES];

	
}

- (IBAction)loadGameBoard:(id)sender 
{
	[self presentModalViewController:[[GameBoardViewController alloc] initWithNibName:@"GameBoardViewController" bundle:nil] animated:YES];
}

@end

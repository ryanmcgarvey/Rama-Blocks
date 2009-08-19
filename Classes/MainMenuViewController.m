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
		buttonGraphic = [[UIImageView alloc]init];

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


- (IBAction)loadTutorial:(id)sender {
	[self presentModalViewController:[[Tutorial alloc] initWithNibName:@"Tutorial" bundle:nil] animated:YES];	
}

- (IBAction)loadLevelSelect:(id)sender{
	
	
	[self presentModalViewController:[[LevelSelect alloc] initWithNibName:@"LevelSelect" bundle:nil] animated:YES];
	
}

- (IBAction)loadGameBoard:(id)sender 
{
	Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.gameType = 1;
	
	
	 buttonCenter = buttonGraphic.center;
	 titleCenter = titleGraphic.center;
	 behindButtonCenter = behindButtonGraphic.center;
	
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationDuration:1.6f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animateButtons)];
	buttonGraphic.center = CGPointMake(buttonGraphic.center.x - 300,buttonGraphic.center.y);
	titleGraphic.center = CGPointMake(titleGraphic.center.x,titleGraphic.center.y - 300);
	behindButtonGraphic.center = CGPointMake(behindButtonGraphic.center.x+ 300,behindButtonGraphic.center.y);
	[UIView commitAnimations];
	
	//buttonGraphic.center = originalButton;
	
		
	
}

- (IBAction)loadTimeBoard:(id)sender 
{
	Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.gameType = 2;
	[self presentModalViewController:[[GameBoardViewController alloc] initWithNibName:@"GameBoardViewController" bundle:nil] animated:YES];
}

-(void)animateButtons{
	[self presentModalViewController:[[GameBoardViewController alloc] initWithNibName:@"GameBoardViewController" bundle:nil] animated:YES];
	[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(restoreCenters) userInfo:nil repeats:YES];
	
	//buttonGraphic.center = buttonCenter;
	//titleGraphic.center = titleCenter;
	//behindButtonGraphic.center = behindButtonCenter;
	
	
}

-(void)restoreCenters{
	buttonGraphic.center = buttonCenter;
	titleGraphic.center = titleCenter;
	behindButtonGraphic.center = behindButtonCenter;
}
	

@end

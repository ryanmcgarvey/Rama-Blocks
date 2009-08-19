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

@synthesize zoomBack;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
        gameState = [[appDelegate FetchGameState] retain];
		buttonGraphic = [[UIImageView alloc]init];
		zoomBack = [[UIImageView alloc] initWithFrame:CGRectMake(140, 200, 40, 60)]; 
		zoomBack.image = [UIImage imageNamed:@"zoomBack.png"];
		zoomBack.alpha = 0.3f;
		self.view.contentMode = UIViewContentModeCenter;

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
	[UIView setAnimationDuration:2.0f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animateBoard)];
	buttonGraphic.center = CGPointMake(buttonGraphic.center.x - 300,buttonGraphic.center.y);
	titleGraphic.center = CGPointMake(titleGraphic.center.x,titleGraphic.center.y - 300);
	behindButtonGraphic.center = CGPointMake(behindButtonGraphic.center.x+ 300,behindButtonGraphic.center.y);
	
	
	
	[UIView commitAnimations];
	
	

	
}

- (IBAction)loadTimeBoard:(id)sender 
{
	Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.gameType = 2;
	[self presentModalViewController:[[GameBoardViewController alloc] initWithNibName:@"GameBoardViewController" bundle:nil] animated:YES];
}


-(void)animateBoard{
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationDuration:2.0f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animateButtons)];
	
	[self.view addSubview:zoomBack];
	[self.view bringSubviewToFront:zoomBack];
	
	zoomBack.bounds = CGRectMake(0, 0, 320, 480);
	zoomBack.alpha = 1;
	zoomBack.center = CGPointMake(zoomBack.center.x,zoomBack.center.y + 10.5);
	
	[UIView commitAnimations];
	
}


-(void)animateButtons{
	[self presentModalViewController:[[GameBoardViewController alloc] initWithNibName:@"GameBoardViewController" bundle:nil] animated:NO];
	[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(restoreCenters) userInfo:nil repeats:NO];
	
	buttonGraphic.center = buttonCenter;
	titleGraphic.center = titleCenter;
	behindButtonGraphic.center = behindButtonCenter;
	
	
}

-(void)restoreCenters{
	buttonGraphic.center = buttonCenter;
	titleGraphic.center = titleCenter;
	behindButtonGraphic.center = behindButtonCenter;
	[zoomBack removeFromSuperview];
	zoomBack = nil;
	[zoomBack release];
	zoomBack = [[UIImageView alloc] initWithFrame:CGRectMake(140, 200, 40, 60)];
	zoomBack.image = [UIImage imageNamed:@"zoomBack.png"];
	zoomBack.alpha = 0.3f;
	
}
	

@end

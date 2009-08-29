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
		zoomBack.image = [UIImage imageNamed:@"mainMenuBackGround.png"];
		zoomBack.alpha = 0.3f;
		
		levelNumbers = [[UIImageView alloc] initWithFrame:CGRectMake(321, -50, 290, 360)]; 
		levelNumbers.image = [UIImage imageNamed:@"NumberGrid.png"];
		
		levelSelectText = [[UIImageView alloc] initWithFrame:CGRectMake(160, -50, 190, 35)]; 
		levelSelectText.image = [UIImage imageNamed:@"levelText.png"];
		
		levelSelectGrayBox = [[UIImageView alloc] initWithFrame:CGRectMake(-50, 500, 270, 130)]; 
		levelSelectGrayBox.image = [UIImage imageNamed:@"grayBox.png"];
		
		level1 = [[UIImageView alloc] initWithFrame:CGRectMake(68, 101, 18, 25)]; 
		level1.image = [UIImage imageNamed:@"level1.png"];
		level1.center = CGPointMake(level1.center.x - 320,level1.center.y - 250);
		
		level2 = [[UIImageView alloc] initWithFrame:CGRectMake(98, 98, 25, 28)]; 
		level2.image = [UIImage imageNamed:@"level2.png"];
		level2.center = CGPointMake(level2.center.x - 320,level2.center.y - 250);
		
		level3 = [[UIImageView alloc] initWithFrame:CGRectMake(135, 93, 28, 30)]; 
		level3.image = [UIImage imageNamed:@"level3.png"];
		level3.center = CGPointMake(level3.center.x - 320,level3.center.y - 250);
		
		level4 = [[UIImageView alloc] initWithFrame:CGRectMake(185, 85, 32, 31)]; 
		level4.image = [UIImage imageNamed:@"level4.png"];
		level4.center = CGPointMake(level4.center.x - 320,level4.center.y - 250);
		
		level5 = [[UIImageView alloc] initWithFrame:CGRectMake(245, 79, 38, 35)]; 
		level5.image = [UIImage imageNamed:@"level5.png"];
		level5.center = CGPointMake(level5.center.x - 320,level5.center.y - 250);
		
		level6 = [[UIImageView alloc] initWithFrame:CGRectMake(60, 134, 23, 26)]; 
		level6.image = [UIImage imageNamed:@"level6.png"];
		level6.center = CGPointMake(level6.center.x - 320,level6.center.y - 250);
		
		level11 = [[UIImageView alloc] initWithFrame:CGRectMake(51, 165, 27, 27)]; 
		level11.image = [UIImage imageNamed:@"level11.png"];
		level11.center = CGPointMake(level11.center.x - 320,level11.center.y - 250);
		
		level16 = [[UIImageView alloc] initWithFrame:CGRectMake(44, 200, 30, 29)]; 
		level16.image = [UIImage imageNamed:@"level16.png"];
		level16.center = CGPointMake(level16.center.x - 320,level16.center.y - 250);
		
		level21 = [[UIImageView alloc] initWithFrame:CGRectMake(34, 236, 33, 32)]; 
		level21.image = [UIImage imageNamed:@"level21.png"];
		level21.center = CGPointMake(level21.center.x - 320,level21.center.y - 250);
		
		
		
		[self.view addSubview:levelNumbers];
		[self.view addSubview:levelSelectText];
		[self.view addSubview:levelSelectGrayBox];
		
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


- (void)actualLoadGameBoard
{

	[self presentModalViewController:[[GameBoardViewController alloc] initWithNibName:@"GameBoardViewController" bundle:nil] animated:NO];
}


 - (IBAction)loadGameBoard:(id)sender 
 {
	 if([gameState.currentBoard.Active boolValue]){
		 
		 [self actualLoadGameBoard];
	 
	 }else{
		 buttonCenter = buttonGraphic.center;
		 titleCenter = titleGraphic.center;
		 behindButtonCenter = behindButtonGraphic.center;
		 
		 [UIView beginAnimations:nil context:nil]; 
		 [UIView setAnimationDuration:2.0f];
		 [UIView setAnimationDelegate:self];
		 [UIView setAnimationDidStopSelector:@selector(animateBoard)];
		 buttonGraphic.center = CGPointMake(buttonGraphic.center.x - 320,buttonGraphic.center.y);
		 titleGraphic.center = CGPointMake(titleGraphic.center.x,titleGraphic.center.y - 320);
		 behindButtonGraphic.center = CGPointMake(behindButtonGraphic.center.x+ 320,behindButtonGraphic.center.y);
		 
		 [UIView commitAnimations];
	 }
 }
 

-(void)animateBoard{
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationDuration:2.0f];
	[UIView setAnimationDelegate:self];

	[self.view bringSubviewToFront:levelNumbers];
	
	levelNumbers.center = CGPointMake(160,240);
	levelSelectText.center = CGPointMake(160,30);
	levelSelectGrayBox.center = CGPointMake(135,432);	
	
	level1.center = CGPointMake(level1.center.x + 320,level1.center.y + 250);
	level1.tag = 1;
	level1.userInteractionEnabled = TRUE;
	
	level2.center = CGPointMake(level2.center.x + 320,level2.center.y + 250);
	level2.tag = 2;
	level2.userInteractionEnabled = TRUE;
	
	level3.center = CGPointMake(level3.center.x + 320,level3.center.y + 250);
	level3.tag = 3;
	level3.userInteractionEnabled = TRUE;
	
	level4.center = CGPointMake(level4.center.x + 320,level4.center.y + 250);
	level4.tag = 4;
	level4.userInteractionEnabled = TRUE;
	
	level5.center = CGPointMake(level5.center.x + 320,level5.center.y + 250);
	level5.tag = 5;
	level5.userInteractionEnabled = TRUE;
	
	level6.center = CGPointMake(level6.center.x + 320,level6.center.y + 250);
	level6.tag = 6;
	level6.userInteractionEnabled = TRUE;
	
	level11.center = CGPointMake(level11.center.x + 320,level11.center.y + 250);
	level11.tag = 11;
	level11.userInteractionEnabled = TRUE;
	
	level16.center = CGPointMake(level16.center.x + 320,level16.center.y + 250);
	level16.tag = 16;
	level16.userInteractionEnabled = TRUE;
	
	level21.center = CGPointMake(level21.center.x + 320,level21.center.y + 250);
	level21.tag = 21;
	level21.userInteractionEnabled = TRUE;
	
	[self.view addSubview:level1];
	[self.view addSubview:level2];
	[self.view addSubview:level3];
	[self.view addSubview:level4];
	[self.view addSubview:level5];
	[self.view addSubview:level6];
	[self.view addSubview:level11];
	[self.view addSubview:level16];
	[self.view addSubview:level21];
	
	[self.view addSubview:levelNumbers];
	[self.view addSubview:levelSelectText];
	[self.view addSubview:levelSelectGrayBox];
	
	
	[UIView commitAnimations];
	
	
	
}
 
 
 -(void)animateButtons{
	 
	 
	 
	 [UIView beginAnimations:nil context:nil]; 
	 [UIView setAnimationDuration:2.0f];
	 [UIView setAnimationDelegate:self];
	 
	 levelNumbers.center = CGPointMake(321, -50);
	 levelSelectText.center = CGPointMake(160, -50);
	 levelSelectGrayBox.center = CGPointMake(-50, 500);	
	 
	 level1.center = CGPointMake(level1.center.x - 320,level1.center.y - 250);
	 level2.center = CGPointMake(level2.center.x - 320,level2.center.y - 250);
	 level3.center = CGPointMake(level3.center.x - 320,level3.center.y - 250);
	 level4.center = CGPointMake(level4.center.x - 320,level4.center.y - 250);
	 level5.center = CGPointMake(level5.center.x - 320,level5.center.y - 250);
	 level6.center = CGPointMake(level6.center.x - 320,level6.center.y - 250);
	 
	 level11.center = CGPointMake(level11.center.x - 320,level11.center.y - 250);
	 
	 level16.center = CGPointMake(level16.center.x - 320,level16.center.y - 250);
	 
	 level21.center = CGPointMake(level21.center.x - 320,level21.center.y - 250);
	 
	 
	 [self.view addSubview:zoomBack];
	 [self.view bringSubviewToFront:zoomBack];
	 
	 zoomBack.bounds = CGRectMake(0, 0, 320, 480);
	 zoomBack.alpha = 1;
	 zoomBack.center = CGPointMake(zoomBack.center.x,zoomBack.center.y + 10.5);
	 
	 [UIView commitAnimations];
	 
	 
	 [NSTimer scheduledTimerWithTimeInterval:2.1f target:self selector:@selector(actualLoadGameBoard) userInfo:nil repeats:NO];
	 [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(restoreCenters) userInfo:nil repeats:NO];
 
 
 }
 
 -(void)restoreCenters{
	 buttonGraphic.center = buttonCenter;
	 titleGraphic.center = titleCenter;
	 behindButtonGraphic.center = behindButtonCenter;
	 [zoomBack removeFromSuperview];
	 zoomBack = nil;
	 [zoomBack release];
	 zoomBack = [[UIImageView alloc] initWithFrame:CGRectMake(140, 200, 40, 60)];
	 zoomBack.image = [UIImage imageNamed:@"mainMenuBackGround.png"];
	 zoomBack.alpha = 0.3f;
	 
	 [level1 removeFromSuperview];
	 [level2 removeFromSuperview];
	 [level3 removeFromSuperview];
	 [level4 removeFromSuperview];
	 [level5 removeFromSuperview];
	 [level6 removeFromSuperview];
	 [level11 removeFromSuperview];
	 [level16 removeFromSuperview];
	 [level21 removeFromSuperview];
	 
	 [levelNumbers removeFromSuperview];
	 [levelSelectText removeFromSuperview];
	 [levelSelectGrayBox removeFromSuperview];
 
 }
 

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	UIImageView * touchedItem = (UIImageView *)[touch view];
	
	if(touchedItem.tag != 0){
		int level = touchedItem.tag;
		
		if(level > [gameState.highestLevel intValue])
		{
			level = [gameState.highestLevel intValue];
		}
		gameState.currentLevel = [NSNumber numberWithInt:level];
	
		[self animateButtons];
	}
	
}


@end

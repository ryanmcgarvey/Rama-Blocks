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

@synthesize zoomBack, backGroundMenu, backGround;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
        gameState = [[appDelegate FetchGameState] retain];
		
		buttonGraphic = [[UIImageView alloc]init];
		backGroundMenu = [[UIImageView alloc]init];
		backGround = [[UIImageView alloc]init];
		
		zoomBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 640, 960)]; 
		zoomBack.image = [UIImage imageNamed:@"BigBackground.png"];
		zoomBack.alpha = 0.3f;
		
		levelNumbers = [[UIImageView alloc] initWithFrame:CGRectMake(321, -50, 290, 360)]; 
		levelNumbers.image = [UIImage imageNamed:@"NumberGrid.png"];
		
		levelSelectText = [[UIImageView alloc] initWithFrame:CGRectMake(160, -50, 190, 35)]; 
		levelSelectText.image = [UIImage imageNamed:@"levelText.png"];
		
		levelSelectGrayBox = [[UIImageView alloc] initWithFrame:CGRectMake(-50, 500, 270, 130)]; 
		levelSelectGrayBox.image = [UIImage imageNamed:@"grayBox.png"];
		
		level1 = [[UIImageView alloc] initWithFrame:CGRectMake(70.5f, 106, 18, 25)]; 
		level1.image = [UIImage imageNamed:@"level1.png"];
		level1.center = CGPointMake(level1.center.x - 320,level1.center.y - 250);
		
		level2 = [[UIImageView alloc] initWithFrame:CGRectMake(99.5f, 99, 25, 28)]; 
		level2.image = [UIImage imageNamed:@"level2.png"];
		level2.center = CGPointMake(level2.center.x - 320,level2.center.y - 250);
		
		level3 = [[UIImageView alloc] initWithFrame:CGRectMake(135, 93, 28, 30)]; 
		level3.image = [UIImage imageNamed:@"level3.png"];
		level3.center = CGPointMake(level3.center.x - 320,level3.center.y - 250);
		
		level4 = [[UIImageView alloc] initWithFrame:CGRectMake(185, 87, 32, 31)]; 
		level4.image = [UIImage imageNamed:@"level4.png"];
		level4.center = CGPointMake(level4.center.x - 320,level4.center.y - 250);
		
		level5 = [[UIImageView alloc] initWithFrame:CGRectMake(244.5f, 79, 38, 35)]; 
		level5.image = [UIImage imageNamed:@"level5.png"];
		level5.center = CGPointMake(level5.center.x - 320,level5.center.y - 250);
		
		level6 = [[UIImageView alloc] initWithFrame:CGRectMake(60.5f, 134.5f, 23, 26)]; 
		level6.image = [UIImage imageNamed:@"level6.png"];
		level6.center = CGPointMake(level6.center.x - 320,level6.center.y - 250);
		
		level7 = [[UIImageView alloc] initWithFrame:CGRectMake(93.5f, 132.5f, 24, 29)]; 
		level7.image = [UIImage imageNamed:@"level7.png"];
		level7.center = CGPointMake(level7.center.x - 320,level7.center.y - 250);
		
		level8 = [[UIImageView alloc] initWithFrame:CGRectMake(128, 130, 29, 31)]; 
		level8.image = [UIImage imageNamed:@"level8.png"];
		level8.center = CGPointMake(level8.center.x - 320,level8.center.y - 250);
		
		level9 = [[UIImageView alloc] initWithFrame:CGRectMake(174, 127, 32, 32)]; 
		level9.image = [UIImage imageNamed:@"level9.png"];
		level9.center = CGPointMake(level9.center.x - 320,level9.center.y - 250);
		
		level10 = [[UIImageView alloc] initWithFrame:CGRectMake(226, 126, 56, 35)]; 
		level10.image = [UIImage imageNamed:@"level10.png"];
		level10.center = CGPointMake(level10.center.x - 320,level10.center.y - 250);
		/*
		level11 = [[UIImageView alloc] initWithFrame:CGRectMake(52.5f, 166, 27, 27)]; 
		level11.image = [UIImage imageNamed:@"level11.png"];
		level11.center = CGPointMake(level11.center.x - 320,level11.center.y - 250);
		
		level12 = [[UIImageView alloc] initWithFrame:CGRectMake(82, 167.5f, 33, 30)]; 
		level12.image = [UIImage imageNamed:@"level12.png"];
		level12.center = CGPointMake(level12.center.x - 320,level12.center.y - 250);
		
		level13 = [[UIImageView alloc] initWithFrame:CGRectMake(119, 170, 39, 31)]; 
		level13.image = [UIImage imageNamed:@"level13.png"];
		level13.center = CGPointMake(level13.center.x - 320,level13.center.y - 250);
		
		level14 = [[UIImageView alloc] initWithFrame:CGRectMake(164, 170.5f, 45, 34)]; 
		level14.image = [UIImage imageNamed:@"level14.png"];
		level14.center = CGPointMake(level14.center.x - 320,level14.center.y - 250);
		
		level15 = [[UIImageView alloc] initWithFrame:CGRectMake(222, 174, 55, 37)]; 
		level15.image = [UIImage imageNamed:@"level15.png"];
		level15.center = CGPointMake(level15.center.x - 320,level15.center.y - 250);
		
		level16 = [[UIImageView alloc] initWithFrame:CGRectMake(44, 200.5f, 30, 29)]; 
		level16.image = [UIImage imageNamed:@"level16.png"];
		level16.center = CGPointMake(level16.center.x - 320,level16.center.y - 250);
		
		level17 = [[UIImageView alloc] initWithFrame:CGRectMake(75.5f, 205, 34, 31)]; 
		level17.image = [UIImage imageNamed:@"level17.png"];
		level17.center = CGPointMake(level17.center.x - 320,level17.center.y - 250);
		
		level18 = [[UIImageView alloc] initWithFrame:CGRectMake(111, 210, 39, 34)]; 
		level18.image = [UIImage imageNamed:@"level18.png"];
		level18.center = CGPointMake(level18.center.x - 320,level18.center.y - 250);
		
		level19 = [[UIImageView alloc] initWithFrame:CGRectMake(155, 216, 46, 37)]; 
		level19.image = [UIImage imageNamed:@"level19.png"];
		level19.center = CGPointMake(level19.center.x - 320,level19.center.y - 250);
		
		level20 = [[UIImageView alloc] initWithFrame:CGRectMake(207, 224, 68, 44)]; 
		level20.image = [UIImage imageNamed:@"level20.png"];
		level20.center = CGPointMake(level20.center.x - 320,level20.center.y - 250);
		
		level21 = [[UIImageView alloc] initWithFrame:CGRectMake(32.5f, 236.5f, 33, 32)]; 
		level21.image = [UIImage imageNamed:@"level21.png"];
		level21.center = CGPointMake(level21.center.x - 320,level21.center.y - 250);
		
		*/
		
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
		
        
    }
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationDuration:45.0f];
	backGround.center = CGPointMake(backGround.center.x - 280, backGround.center.y - 300);
	
	[UIView commitAnimations];
    [super viewWillAppear:animate];
}
- (void)viewDidLoad {
	
	
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
	backGround.center = CGPointMake(backGround.center.x + 280, backGround.center.y + 300);
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
		 backGroundCenter = backGround.center;
		 
		 [UIView beginAnimations:nil context:nil]; 
		 [UIView setAnimationDuration:1.0f];
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
	[UIView setAnimationDuration:1.5f];
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
	
	level7.center = CGPointMake(level7.center.x + 320,level7.center.y + 250);
	level7.tag = 7;
	level7.userInteractionEnabled = TRUE;
	
	level8.center = CGPointMake(level8.center.x + 320,level8.center.y + 250);
	level8.tag = 8;
	level8.userInteractionEnabled = TRUE;
	
	level9.center = CGPointMake(level9.center.x + 320,level9.center.y + 250);
	level9.tag = 9;
	level9.userInteractionEnabled = TRUE;
	
	level10.center = CGPointMake(level10.center.x + 320,level10.center.y + 250);
	level10.tag = 10;
	level10.userInteractionEnabled = TRUE;
	/*
	level11.center = CGPointMake(level11.center.x + 320,level11.center.y + 250);
	level11.tag = 11;
	level11.userInteractionEnabled = TRUE;
	
	level12.center = CGPointMake(level12.center.x + 320,level12.center.y + 250);
	level12.tag = 12;
	level12.userInteractionEnabled = TRUE;
	
	level13.center = CGPointMake(level13.center.x + 320,level13.center.y + 250);
	level13.tag = 13;
	level13.userInteractionEnabled = TRUE;
	
	level14.center = CGPointMake(level14.center.x + 320,level14.center.y + 250);
	level14.tag = 14;
	level14.userInteractionEnabled = TRUE;
	
	level15.center = CGPointMake(level15.center.x + 320,level15.center.y + 250);
	level15.tag = 15;
	level15.userInteractionEnabled = TRUE;
	
	level16.center = CGPointMake(level16.center.x + 320,level16.center.y + 250);
	level16.tag = 16;
	level16.userInteractionEnabled = TRUE;
	
	level17.center = CGPointMake(level17.center.x + 320,level17.center.y + 250);
	level17.tag = 17;
	level17.userInteractionEnabled = TRUE;
	
	level18.center = CGPointMake(level18.center.x + 320,level18.center.y + 250);
	level18.tag = 18;
	level18.userInteractionEnabled = TRUE;
	
	level19.center = CGPointMake(level19.center.x + 320,level19.center.y + 250);
	level19.tag = 19;
	level19.userInteractionEnabled = TRUE;
	
	level20.center = CGPointMake(level20.center.x + 320,level20.center.y + 250);
	level20.tag = 20;
	level20.userInteractionEnabled = TRUE;
	
	level21.center = CGPointMake(level21.center.x + 320,level21.center.y + 250);
	level21.tag = 21;
	level21.userInteractionEnabled = TRUE;
	*/
	[self.view addSubview:level1];
	[self.view addSubview:level2];
	[self.view addSubview:level3];
	[self.view addSubview:level4];
	[self.view addSubview:level5];
	[self.view addSubview:level6];
	[self.view addSubview:level7];
	[self.view addSubview:level8];
	[self.view addSubview:level9];
	[self.view addSubview:level10];
	/*
	[self.view addSubview:level11];
	[self.view addSubview:level12];
	[self.view addSubview:level13];
	[self.view addSubview:level14];
	[self.view addSubview:level15];
	[self.view addSubview:level16];
	[self.view addSubview:level17];
	[self.view addSubview:level18];
	[self.view addSubview:level19];
	[self.view addSubview:level20];
	[self.view addSubview:level21];
	*/
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
	 level7.center = CGPointMake(level7.center.x - 320,level7.center.y - 250);
	 level8.center = CGPointMake(level8.center.x - 320,level8.center.y - 250);
	 level9.center = CGPointMake(level9.center.x - 320,level9.center.y - 250);
	 level10.center = CGPointMake(level10.center.x - 320,level10.center.y - 250);
	 /*
	 level11.center = CGPointMake(level11.center.x - 320,level11.center.y - 250);
	 level12.center = CGPointMake(level12.center.x - 320,level12.center.y - 250);
	 level13.center = CGPointMake(level13.center.x - 320,level13.center.y - 250);
	 level14.center = CGPointMake(level14.center.x - 320,level14.center.y - 250);
	 level15.center = CGPointMake(level15.center.x - 320,level15.center.y - 250);
	 level16.center = CGPointMake(level16.center.x - 320,level16.center.y - 250);
	 level17.center = CGPointMake(level17.center.x - 320,level17.center.y - 250);
	 level18.center = CGPointMake(level18.center.x - 320,level18.center.y - 250);
	 level19.center = CGPointMake(level19.center.x - 320,level19.center.y - 250);
	 level20.center = CGPointMake(level20.center.x - 320,level20.center.y - 250);
	 level21.center = CGPointMake(level21.center.x - 320,level21.center.y - 250);
	 */
	 
	 [self.view addSubview:zoomBack];
	 [self.view bringSubviewToFront:zoomBack];
	 
	 backGround.bounds = CGRectMake(0, 0, 640, 960);
	 backGround.contentMode = UIViewContentModeScaleToFill;
	 zoomBack.alpha = 1;
	 
	 [UIView commitAnimations];
	 
	 [NSTimer scheduledTimerWithTimeInterval:2.1f target:self selector:@selector(actualLoadGameBoard) userInfo:nil repeats:NO];
	 [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(restoreCenters) userInfo:nil repeats:NO];
 
 
 }
 
 -(void)restoreCenters{
	 buttonGraphic.center = buttonCenter;
	 titleGraphic.center = titleCenter;
	 backGround.center = backGroundCenter;
	 behindButtonGraphic.center = behindButtonCenter;
	 [zoomBack removeFromSuperview];
	 zoomBack.alpha = 0.3f;
	 backGround.center = CGPointMake(160,240);
	 
	 [level1 removeFromSuperview];
	 [level2 removeFromSuperview];
	 [level3 removeFromSuperview];
	 [level4 removeFromSuperview];
	 [level5 removeFromSuperview];
	 [level6 removeFromSuperview];
	 [level7 removeFromSuperview];
	 [level8 removeFromSuperview];
	 [level9 removeFromSuperview];
	 [level10 removeFromSuperview];/*
	 [level11 removeFromSuperview];
	 [level12 removeFromSuperview];
	 [level13 removeFromSuperview];
	 [level14 removeFromSuperview];
	 [level15 removeFromSuperview];
	 [level16 removeFromSuperview];
	 [level17 removeFromSuperview];
	 [level18 removeFromSuperview];
	 [level19 removeFromSuperview];
	 [level20 removeFromSuperview];
	 [level21 removeFromSuperview];
	 */
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
			touchedItem.alpha = 0.5f;
			return;
		}
		if(level <= [gameState.highestLevel intValue]){
		
			gameState.currentLevel = [NSNumber numberWithInt:level];
			[self animateButtons];
		}
		
	}
	
}


@end

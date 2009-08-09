//
//  GameBoardViewController.m
//  RumbaBlocks
//
//  Created by Johnny Moralez on 6/23/09.
//  Copyright 2009 Simplical, LLC. All rights reserved.
//

#import "GameBoardViewController.h"
#import "Rama_BlocksAppDelegate.h"
@implementation GameBoardViewController
@synthesize buttonMenu, buttonOptions, buttonMainMenu, buttonResume, menuView, attemptsString;


-(void)SaveState{
    if([gameState.currentBoard.Active boolValue])
    {
        CFTimeInterval totalTime = CFAbsoluteTimeGetCurrent() - startTime;
        
        [itemCollection SaveState];
        Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        Shape * shape = (Shape *)SpawnedPair.ItemA;
        NSArray * pair = [appDelegate FetchSpawnedItems];
        ItemState * item = [pair objectAtIndex:0];
        item.colorType = [NSNumber numberWithInt:shape.colorType];
        item.shapeType = [NSNumber numberWithInt:shape.shapeType];
        
        item = [pair objectAtIndex:1];
        shape = (Shape *)SpawnedPair.ItemB;
        item.colorType = [NSNumber numberWithInt:shape.colorType];
        item.shapeType = [NSNumber numberWithInt:shape.shapeType];
        
        gameState.currentBoard.timePlayed = [NSNumber numberWithDouble:[gameState.currentBoard.timePlayed doubleValue] + totalTime];
    }
}

/*****************************************************
GameBoard Behavior
*****************************************************/
-(void)SpawnShapes{
	if(SpawnedPair==nil)
    {
		SpawnedPair = [ItemPair new];
    }
    [SpawnedPair.GrabberA removeFromSuperview];
    [SpawnedPair.GrabberB removeFromSuperview];
	
    [SpawnedPair.ItemA release];
    SpawnedPair.ItemA = [[Shape alloc] initWithInfo:[currentLevel createRandomColor]: [currentLevel createShapeFromCollection] : CGPointMake(SPAWN_LOCATION_X,SPAWN_LOCATION_Y)];
    
    
    [SpawnedPair.ItemB release];
    SpawnedPair.ItemB = [[Shape alloc] initWithInfo:[currentLevel createRandomColor]: [currentLevel createShapeFromCollection] : CGPointMake(SPAWN_LOCATION_X + SHAPE_WIDTH ,SPAWN_LOCATION_Y)];
    
    [SpawnedPair Reset];
    
    [self.view addSubview:SpawnedPair.GrabberA];
    [self.view addSubview:SpawnedPair.GrabberB];
    
    [self.view addSubview:SpawnedPair.ItemA];
    [self.view addSubview:SpawnedPair.ItemB];
    
    [self.view addSubview:SpawnedPair.ShaddowA];
    [self.view addSubview:SpawnedPair.ShaddowB];

}


- (void)resetTap:(NSTimer *)tapTimer 
{
	GameItem *tappedShape = (GameItem *)[tapTimer userInfo];
	tappedShape.tapped = 0;
}

-(void)ResetShapePair:(ItemPair *)pair{
	pair.ItemA.center = CGPointMake((SPAWN_LOCATION_X), SPAWN_LOCATION_Y);
	pair.ItemB.center = CGPointMake((SPAWN_LOCATION_X + SHAPE_WIDTH), SPAWN_LOCATION_Y);
}

/*****************************************************
UIController Delegates
*****************************************************/
- (void)viewDidLoad {   
    Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
    gameState = [appDelegate FetchGameState];
    
    audio = [appDelegate FetchAudio];


    
	//// Create background
    backGround = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	backGround.clipsToBounds = YES;
	backGround.autoresizesSubviews = NO;
    backGround.contentMode = UIViewContentModeTopLeft;
    backGround.image = [[UIImage imageNamed:@"BackGround.png"] retain];
    backGround.userInteractionEnabled = FALSE;
    self.view.backgroundColor = [UIColor blackColor];
    [self.view sendSubviewToBack:backGround];
	[self.view addSubview:backGround];
    [self.view bringSubviewToFront:buttonMenu];
    [self.view bringSubviewToFront:menuView];
    [self.view bringSubviewToFront:attemptsString];
    //add solution to view
    
    CurrentDevice = [UIDevice currentDevice];
    [CurrentDevice beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRotate:)
                                                 name:@"UIDeviceOrientationDidChangeNotification" object:nil];

    currentLevel = [[Level alloc] init:[gameState.currentLevel intValue]];
    itemCollection = [[ItemCollection alloc] init:NUMBER_OF_ROWS :NUMBER_OF_COLUMNS :SHAPE_WIDTH :SHAPE_WIDTH: currentLevel];
    SpawnedPair = [[ItemPair new]retain];
    if([gameState.currentBoard.Active boolValue])
    {
        NSArray * pair = [appDelegate FetchSpawnedItems];
        ItemState * item = [pair objectAtIndex:0];
        SpawnedPair.ItemA = [[Shape alloc] initWithInfo:
                             [item.colorType intValue] :
                             [item.shapeType intValue] : 
                             CGPointMake(SPAWN_LOCATION_X,SPAWN_LOCATION_Y)];
        
        item = [pair objectAtIndex:1];

        SpawnedPair.ItemB = [[Shape alloc] initWithInfo:
                              [item.colorType intValue] :
                              [item.shapeType intValue] : 
                              CGPointMake(SPAWN_LOCATION_X + SHAPE_WIDTH ,SPAWN_LOCATION_Y)];
        
        for(ItemState * item in [appDelegate FetchLockItems])
        {
            if([item.shapeType intValue] != -1 && [item.colorType intValue] != -1)
            {
                
                LockShape * lockShape = [[LockShape alloc] initWithInfo:[item.colorType intValue] :
                                  [item.shapeType intValue] :
                                  CGPointMake(SPAWN_LOCATION_X,SPAWN_LOCATION_Y)];
                lockShape.canSeeColor = 
                    [item.canSeeColor boolValue];
                lockShape.canSeeShape = 
                    [item.canSeeItem boolValue];

                [currentLevel SetLockAtIndex:lockShape : [item.index intValue]];
            }
        }

        for(ItemState * item in [appDelegate FetchCollectionItemStates])
        {
            if([item.shapeType intValue] != -1 && [item.colorType intValue] != -1)
            {
                
                Shape * shape = [[[Shape alloc] initWithInfo:[item.colorType intValue] :[item.shapeType intValue] : CGPointMake(SPAWN_LOCATION_X,SPAWN_LOCATION_Y)]retain];
                
                Cell * cell = [itemCollection GetCell:[item.Row intValue] : [item.Column intValue]];
                [itemCollection SetItemToCell:shape : cell];
                [self.view addSubview:shape];
            }
        }
        [itemCollection UpdateState];
        [SpawnedPair.GrabberA removeFromSuperview];
        [SpawnedPair.GrabberB removeFromSuperview];
        
        [SpawnedPair Reset];
        
        [self.view addSubview:SpawnedPair.GrabberA];
        [self.view addSubview:SpawnedPair.GrabberB];
        
        [self.view addSubview:SpawnedPair.ItemA];
        [self.view addSubview:SpawnedPair.ItemB];
        
        [self.view addSubview:SpawnedPair.ShaddowA];
        [self.view addSubview:SpawnedPair.ShaddowB];

    }else{
        gameState.currentBoard.Active = [NSNumber numberWithBool:YES];
    	[self SpawnShapes];
        
    }
    [currentLevel addSolutionToView:self.view];
    [self didRotate:nil];

    [super viewDidLoad];
    
    startTime = CFAbsoluteTimeGetCurrent();
}


-(void)didRotate:(NSNotification *)notification{
    switch (CurrentDevice.orientation) {
        case UIInterfaceOrientationLandscapeRight:
            [itemCollection SetGravity:left];
            break;
        case UIInterfaceOrientationLandscapeLeft:
            [itemCollection SetGravity:right];
            break;
        case UIInterfaceOrientationPortrait:
            [itemCollection SetGravity:down];
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            [itemCollection SetGravity:up];
            break;            
        default:
            break;
    }
}


-(IBAction)ClickButtonMenu{
    menuView.hidden = FALSE;
    menuView.userInteractionEnabled = TRUE;
    [self.view bringSubviewToFront:menuView];
    NSLog(@"Button Clicked");
    
}
-(IBAction)ClickButtonResume {
    menuView.hidden = TRUE;
    menuView.userInteractionEnabled = FALSE;
    
}
-(IBAction)ClickButtonOptions{
    [self presentModalViewController:[[Options alloc] initWithNibName:@"Options" bundle:nil] animated:YES];
}
-(IBAction)ClickButtonMainMenu{
    [self dismissModalViewControllerAnimated:YES];
}
/*****************************************************
    Touches
 *****************************************************/


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	
	if([[touch view] isKindOfClass: [GameItem class]])
	{
		GameItem * touchedItem = (GameItem *)[touch view];
        touchedItem.tapped++;
        TouchTimer = [[NSTimer scheduledTimerWithTimeInterval:TAP_WAIT_TIME target:self selector:@selector(resetTap:) userInfo:touchedItem repeats:NO] retain];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
    if(![[touch view] isKindOfClass: [LockShape class]])
    {
        GameItem * highlightItem = [itemCollection GetItemFromCoordinate:[touch locationInView:backGround]]; 
        if([highlightItem isKindOfClass:[Shape class]] && ! highlightItem.IsPaired)
        {
            Shape * shape = (Shape *) highlightItem;
            [itemCollection AddShapeToSolution:shape];
            shape.tapped = 0;
        }
    }
    if([[touch view] isMemberOfClass:[UIImageView class]] && [touch view] != backGround)
    {
        [SpawnedPair move:[touch locationInView: self.view] :(UIImageView *)[touch view]];
        [itemCollection DrawShadowForItemPair:SpawnedPair];
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	/* Shape was touched */
	if([[touch view] isKindOfClass: [GameItem class]]  && ![[touch view] isKindOfClass: [LockShape class]] )
	{
		GameItem * item = (GameItem *)[touch view];
		
		if(item.IsPaired)
		{
			if (item.tapped == 1) 
            {
				item.tapped = 0;
				[SpawnedPair rotate:item];
			}
		}else
        {
            if(item.tapped > 0)
            {
                item.tapped = 0;
                if([itemCollection TransformItem:item])
                {
                    [audio playTransform];
                }
            }
            else
            {
                if([itemCollection CheckSolution])
                {
                    [audio playVictory];
                    Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
                    [self SaveState];
                    if([gameState.currentLevel intValue] == [gameState.highestLevel intValue] && [gameState.highestLevel intValue] < 10)
                    {
                        
                        LevelStatistics * stat = [appDelegate CreatePlayedLevel];
                        stat.Level = [NSNumber numberWithInt:[gameState.currentLevel intValue]];
                        stat.numberOfMoves = gameState.currentBoard.numberOfMovies;
                        stat.numberOfTransforms = gameState.currentBoard.numberOfTransforms;
                        stat.numerOfAttempts = gameState.currentBoard.numberOfAttempts;
                        stat.timeToComplete = gameState.currentBoard.timePlayed;
                        [gameState addPlayedLevelsObject:stat];
                        gameState.highestLevel = [NSNumber numberWithInt:[gameState.highestLevel intValue] +1];
                        gameState.currentLevel = [NSNumber numberWithInt:[gameState.highestLevel intValue]   ];
                    }
                    
                    gameState.currentBoard.Active = [NSNumber numberWithBool:NO];
                    [self dismissModalViewControllerAnimated:YES];
                }

                attemptsString.text = [[NSString alloc] initWithFormat:@" %d\n", currentLevel.attempts];
            }
        }
	}
    if([[touch view] isMemberOfClass:[UIImageView class]] && [touch view] != backGround)
    {
        if([SpawnedPair IsInGrid])
        {
            if([itemCollection AddItemPair:SpawnedPair])
            {
                [self SpawnShapes];
            }else
            {
                [self ResetShapePair:SpawnedPair];
            }
        }
    }
    [itemCollection ClearSolution];
}


/*****************************************************
Tear down and maintenance
*****************************************************/
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];	
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewWillAppear:(BOOL)animated{
    [self ClickButtonResume];
}

- (void)viewDidUnload {
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [self SaveState];
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    
	[backGround release];
	[SpawnedPair release];
	[itemCollection release];
	[TouchTimer release];
    [super dealloc];
}



@end

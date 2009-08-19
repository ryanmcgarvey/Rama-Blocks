//
//  GameBoardViewController.m
//  RumbaBlocks
//
//  Created by Johnny Moralez on 6/23/09.
//  Copyright 2009 Simplical, LLC. All rights reserved.
//

#import "GameBoardViewController.h"
#import "Rama_BlocksAppDelegate.h"
#import "DrawingView.h"
@implementation GameBoardViewController
@synthesize buttonMenu, buttonOptions, buttonMainMenu, buttonResume, menuView, attemptsString;
@synthesize timeToDrop, countDown, drawingView, startTouchPosition, currentTouchPosition, touchDistanceToItemC;
@synthesize bullshit;


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
	
	CGRect frame = CGRectMake(0.0f, 0.0f, 91, 91);
	drawingView = [DrawingView alloc];
	[drawingView makeCirclePoint:SpawnedPair.ItemA.center:SpawnedPair.ItemB.center];
	[drawingView initWithFrame: frame];
	drawingView.backgroundColor = [UIColor clearColor];
	[SpawnedPair.ItemC setUserInteractionEnabled:false];
	SpawnedPair.ItemC = drawingView;
	SpawnedPair.ItemC.alpha = 0.1f;
    
    //[self.view addSubview:SpawnedPair.GrabberA];
    //[self.view addSubview:SpawnedPair.GrabberB];
    
	[self.view addSubview:SpawnedPair.ItemC];
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
	if(appDelegate.gameType == 2){
		Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
		gameState = [appDelegate FetchGameState];
		powerItem = [[PowerItem alloc]init];
		audio = [appDelegate FetchAudio];
		
		//// Create background
		backGround = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		backGround.clipsToBounds = YES;
		backGround.autoresizesSubviews = NO;
		backGround.contentMode = UIViewContentModeTopLeft;
		backGround.image = [[UIImage imageNamed:@"BackGround.png"] retain];
		backGround.userInteractionEnabled = FALSE;
		self.view.backgroundColor = [UIColor blackColor];
		timeToDrop.backgroundColor = [UIColor clearColor];
		timeToDrop.textColor = [UIColor greenColor];
		
		[self.view sendSubviewToBack:backGround];
		[self.view addSubview:backGround];
		[self.view bringSubviewToFront:buttonMenu];
		[self.view bringSubviewToFront:menuView];
		[self.view bringSubviewToFront:timeToDrop];
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
		
		[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeUntilDrop) userInfo:nil repeats:YES];
	}
	
	if(appDelegate.gameType == 1){
		Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
		gameState = [appDelegate FetchGameState];
		powerItem = [[PowerItem alloc]init];
		audio = [appDelegate FetchAudio];
		
		//// Create background
		backGround = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		backGround.clipsToBounds = YES;
		backGround.autoresizesSubviews = NO;
		backGround.contentMode = UIViewContentModeTopLeft;
		backGround.image = [[UIImage imageNamed:@"gameBoardGrid.png"] retain];
		backGround.userInteractionEnabled = FALSE;
		self.view.backgroundColor = [UIColor blackColor];
		//timeToDrop.backgroundColor = [UIColor clearColor];
		//timeToDrop.textColor = [UIColor greenColor];
		
		[self.view addSubview:backGround];
		
		[self.view sendSubviewToBack:backGround];
		[self.view addSubview:buttonMenu];
		[self.view addSubview:menuView];
		
		
		//[self.view bringSubviewToFront:timeToDrop];
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
			
			//[self.view addSubview:SpawnedPair.GrabberA];
			//[self.view addSubview:SpawnedPair.GrabberB];
			
			CGRect frame = CGRectMake(0.0f, 0.0f, 91, 91);
			drawingView = [DrawingView alloc];
			[drawingView makeCirclePoint:SpawnedPair.ItemA.center:SpawnedPair.ItemB.center];
			[drawingView initWithFrame: frame];
			drawingView.backgroundColor = [UIColor clearColor];
			SpawnedPair.ItemC = drawingView;
			SpawnedPair.ItemC.alpha = 0.2f;
			[SpawnedPair.ItemC setUserInteractionEnabled:false];
			
			[self.view addSubview:SpawnedPair.ItemC];
			[self.view addSubview:SpawnedPair.ItemA];
			[self.view addSubview:SpawnedPair.ItemB];
			
			[self.view addSubview:SpawnedPair.ShaddowA];
			[self.view addSubview:SpawnedPair.ShaddowB];
			
			
			
		}else{
			gameState.currentBoard.Active = [NSNumber numberWithBool:YES];
			[self SpawnShapes];
			
		}
		[currentLevel addSolutionToView:self.view];
		
		//lockSet = [[UIImageView alloc] initWithFrame:CGRectMake(LOCK_LOCATION_X - 11, LOCK_LOCATION_Y - 13, 23, 23)];
		
		experimentArray = [[NSMutableArray alloc] init];
		
		for(int i = 0; i < currentLevel.lockCount; i++){
			UIImageView * newLock = [[UIImageView alloc] initWithFrame:CGRectMake(LOCK_LOCATION_X + (30 * i) - 11, LOCK_LOCATION_Y  - 13, 23, 23)];
			
			for(int x = 1; x < 17; x++){
				NSString *theImage = [NSString stringWithFormat:@"exp%d.png", x];
				NSLog(@"%@", theImage); 
				UIImage *expImage = [UIImage imageNamed:theImage];
				[experimentArray addObject:expImage];
				
				
			}
			
			[newLock setAnimationImages:experimentArray];
			[newLock setAnimationDuration:1.0f + i];
			[newLock startAnimating];
			
			[self.view addSubview:newLock];
			//[self.view bringSubviewToFront:newLock];
			
		}
		
		[self didRotate:nil];
		
		[super viewDidLoad];
		
		startTime = CFAbsoluteTimeGetCurrent();
		
	}
	
}

-(void)timeUntilDrop{
	int currentFontSize = 13;
	countDown++;
	currentFontSize = currentFontSize + (countDown * 3);
	timeToDrop.font = [UIFont boldSystemFontOfSize:currentFontSize];
	timeToDrop.text = [[NSString alloc] initWithFormat:@"%d", countDown];
	if(countDown < 2){
		timeToDrop.textColor = [UIColor greenColor];
	}
	if(countDown > 2){
		timeToDrop.textColor = [UIColor yellowColor];
	}
	if(countDown > 4){
		timeToDrop.textColor = [UIColor redColor];
	}
	if(countDown == 6){
		[self timerDrop];
		countDown = 0;
	}
}
-(void)timerDrop{
	if([itemCollection AddItemPair:SpawnedPair])
	{
		[self SpawnShapes];
	}else
	{
		[self ResetShapePair:SpawnedPair];
	}
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

-(IBAction)ClickReset{
    menuView.hidden = FALSE;
    menuView.userInteractionEnabled = TRUE;
	gameState.currentBoard.Active = FALSE;
    [self.view bringSubviewToFront:menuView];
	[SpawnedPair release];
	[itemCollection release];
	[TouchTimer release];
	SpawnedPair = nil;
	itemCollection = nil;
	TouchTimer = nil;
	[self viewDidLoad];
    NSLog(@"Reset View");
    
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

-(CGFloat)isTouchWithinRange:(CGPoint)touch from:(CGPoint)center{
	
	float x = center.x - touch.x;
	float y = center.y - touch.y;
	
	return sqrt(x * x + y * y);
}


#define HORIZ_SWIPE_DRAG_MIN  60
#define VERT_SWIPE_DRAG_MAX    15

#define VERT_SWIPE_DRAG_MIN  60
#define HORIZ_SWIPE_DRAG_MAX    15

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	startTouchPosition = [touch locationInView:self.view];
	Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.isMoving = YES;
	
	if([[touch view] isKindOfClass: [GameItem class]] && appDelegate.isAttaching == NO){
		GameItem * touchedItem = (GameItem *)[touch view];
		Shape * powerTouchItem = (Shape *)touchedItem;
		
		if([[touch view] isKindOfClass:[Shape class]] && powerTouchItem.shapeType == Vortex){
			
			
			if(powerTouchItem.colorType == Red){
				[powerItem makeCollection:itemCollection];
				[powerItem useBombItem:powerTouchItem];
			}
			if(powerTouchItem.colorType == Purple){
				[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
				[powerItem makeCollection:itemCollection];
				[powerItem placeAnchor:powerTouchItem];
			}
			
		}
		
        touchedItem.tapped++;
        TouchTimer = [[NSTimer scheduledTimerWithTimeInterval:TAP_WAIT_TIME target:self selector:@selector(resetTap:) userInfo:touchedItem repeats:NO] retain];
		
	}
	
	if([[touch view] isKindOfClass: [Shape class]] && appDelegate.isAttaching == YES){
		appDelegate.isAttaching = NO;
		[powerItem makeAnchor:(Shape *)[touch view]];
		
	}
	
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
	currentTouchPosition = [touch locationInView:self.view];
    if(![[touch view] isKindOfClass: [LockShape class]] && appDelegate.isAttaching == NO)
    {
        GameItem * highlightItem = [itemCollection GetItemFromCoordinate:[touch locationInView:backGround]]; 
        if([highlightItem isKindOfClass:[Shape class]] && ! highlightItem.IsPaired)
        {
            Shape * shape = (Shape *) highlightItem;
            [itemCollection AddShapeToSolution:shape];
            shape.tapped = 0;
        }
    }
    if([[touch view] isMemberOfClass:[UIImageView class]] && [touch view] != backGround && appDelegate.isAttaching == NO)
    {
        [SpawnedPair move:[touch locationInView: self.view] :(UIImageView *)[touch view]];
        [itemCollection DrawShadowForItemPair:SpawnedPair];
    }
	
	else{
		
		touchDistanceToItemC = [self isTouchWithinRange:[touch locationInView:self.view] from:SpawnedPair.ItemC.center];
		if(touchDistanceToItemC < 50.0f){
			[SpawnedPair airMove:[touch locationInView:[self view]]];
			SpawnedPair.ItemC.alpha = 0.7f;
			[itemCollection DrawShadowForItemPair:SpawnedPair];
		}
		
		
	}
	
	
	
}





- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
	SpawnedPair.ItemC.alpha = 0.1f;
	if(![[touch view] isKindOfClass: [Shape class]]  && appDelegate.isAttaching == NO && [self isTouchWithinRange: startTouchPosition from: SpawnedPair.ItemC.center] < 130.0f && [self isTouchWithinRange: startTouchPosition from: SpawnedPair.ItemC.center] > 50.0f ){
		
		if (fabsf(startTouchPosition.x - currentTouchPosition.x) >= HORIZ_SWIPE_DRAG_MIN && fabsf(startTouchPosition.y - currentTouchPosition.y) <= VERT_SWIPE_DRAG_MAX){
			[SpawnedPair rotate:SpawnedPair.ItemA];
			SpawnedPair.ItemC.center = [drawingView makeCirclePoint:SpawnedPair.ItemA.center :SpawnedPair.ItemB.center];
			
		}
		
	}
	
	if(![[touch view] isKindOfClass: [Shape class]] && appDelegate.isAttaching == NO && [self isTouchWithinRange: startTouchPosition from: SpawnedPair.ItemC.center] < 130.0f && [self isTouchWithinRange: startTouchPosition from: SpawnedPair.ItemC.center] > 50.0f ){
		
		if (fabsf(startTouchPosition.y - currentTouchPosition.y) >= VERT_SWIPE_DRAG_MIN && fabsf(startTouchPosition.x - currentTouchPosition.x) <= HORIZ_SWIPE_DRAG_MAX){
			[SpawnedPair rotate:SpawnedPair.ItemB];
			SpawnedPair.ItemC.center = [drawingView makeCirclePoint:SpawnedPair.ItemA.center :SpawnedPair.ItemB.center];
			
		}
		
	}
	
	/* Shape was touched */
	
	if([SpawnedPair IsInGrid])
	{
		if([itemCollection AddItemPair:SpawnedPair])
		{
			[SpawnedPair.ItemC release];
			[SpawnedPair.ItemC removeFromSuperview];
			SpawnedPair.ItemC = nil;
			[self SpawnShapes];
			
			
		}else
		{
			[self ResetShapePair:SpawnedPair];
		}
	}
	
	if([[touch view] isKindOfClass: [GameItem class]]  && ![[touch view] isKindOfClass: [LockShape class]] )
	{
		GameItem * item = (GameItem *)[touch view];
		
		if(item.IsPaired)
		{
			if (item.tapped == 0) 
            {
				item.tapped = 0;
				
				[SpawnedPair rotate:SpawnedPair.ItemA];
				SpawnedPair.ItemC.center = [drawingView makeCirclePoint:SpawnedPair.ItemA.center :SpawnedPair.ItemB.center];
				
				
				
				
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
    if([[touch view] isMemberOfClass:[UIView class]] && [touch view] != backGround)
    {
        if([SpawnedPair IsInGrid])
        {
            if([itemCollection AddItemPair:SpawnedPair])
            {
				[SpawnedPair.ItemC release];
				[SpawnedPair.ItemC removeFromSuperview];
				SpawnedPair.ItemC = nil;
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

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
@synthesize timeToDrop, drawingView, startTouchPosition, currentTouchPosition, touchDistanceToItemC;
@synthesize discardCount, transformCount, discard, spawnedShapeRotateTransformA, checkLock, closeLock;


-(void)SaveState{
    if([gameState.currentBoard.Active boolValue]){
        
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
    
    Shape * ItemA = [[Shape alloc] initWithInfo:[currentLevel createRandomColor]: [currentLevel createShapeFromCollection] : CGPointMake(spawnX,spawnY)];
    Shape * ItemB = [[Shape alloc] initWithInfo:[currentLevel createRandomColor]: [currentLevel createShapeFromCollection] : CGPointMake(spawnX,spawnY)];
    [self SpawnShapes:ItemA : ItemB];
}

-(void)SpawnShapes:(Shape *)ItemA : (Shape *)ItemB{
	if(SpawnedPair==nil)
    {
		SpawnedPair = [ItemPair new];
		nextPair = [ItemPair new];
		
		SpawnedPair.ItemA = [ItemA retain];
		SpawnedPair.ItemB = [ItemB retain];
		
		nextPair.ItemA = [[Shape alloc] initWithInfo:[currentLevel createRandomColor]: [currentLevel createShapeFromCollection] : CGPointMake(spawnNextX,spawnNextY)];
		nextPair.ItemB = [[Shape alloc] initWithInfo:[currentLevel createRandomColor]: [currentLevel createShapeFromCollection] : CGPointMake(spawnNextX,spawnNextY)];
	}else{
        
		[SpawnedPair.ItemA release];
		SpawnedPair.ItemA = nil;
		SpawnedPair.ItemA = nextPair.ItemA;
		SpawnedPair.ItemA.center = CGPointMake(spawnX,spawnY);
		
		
		[SpawnedPair.ItemB release];
		SpawnedPair.ItemB = nil;
		SpawnedPair.ItemB = nextPair.ItemB;
		SpawnedPair.ItemB.center = CGPointMake(spawnX + 30.0f ,spawnY);
		
		[nextPair.ItemA removeFromSuperview];
		//[nextPair.ItemA release];
		nextPair.ItemA = nil;
		nextPair.ItemA = [[Shape alloc] initWithInfo:[currentLevel createRandomColor]: [currentLevel createShapeFromCollection] : CGPointMake(spawnNextX,spawnNextY)];
		
		[nextPair.ItemB removeFromSuperview];
		//[nextPair.ItemB release];
		nextPair.ItemB = nil;
		nextPair.ItemB = [[Shape alloc] initWithInfo:[currentLevel createRandomColor]: [currentLevel createShapeFromCollection] : CGPointMake(spawnNextX + rightPix,spawnNextY + upPix)];
		
		[nextPair.ItemC release];
	}
    [SpawnedPair Reset];
	
	[SpawnedPair.ItemC release];
	SpawnedPair.ItemC = nil;
	
	drawingView = [DrawingView alloc];
	[drawingView makeCirclePoint:SpawnedPair.ItemA.center:SpawnedPair.ItemB.center];
	[drawingView initWithFrame: CGRectMake(0, 0, 120, 120)];
	drawingView.backgroundColor = [UIColor clearColor];
	SpawnedPair.ItemC = drawingView;
	SpawnedPair.ItemC.alpha = 0.25f;
	
	SpawnedPair.ItemA.ItemView.contentMode = UIViewContentModeScaleAspectFit;
	SpawnedPair.ItemB.ItemView.contentMode = UIViewContentModeScaleAspectFit;
	SpawnedPair.ItemC.ItemView.contentMode = UIViewContentModeScaleAspectFit;
	
	[self.view addSubview:SpawnedPair.ItemC];
    [self.view addSubview:SpawnedPair.ItemA];
    [self.view addSubview:SpawnedPair.ItemB];
	
	[self.view addSubview:nextPair.ItemA];
    [self.view addSubview:nextPair.ItemB];
	
	[self.view bringSubviewToFront: SpawnedPair.ItemA];
	[self.view bringSubviewToFront: SpawnedPair.ItemB];
    
    [self.view addSubview:SpawnedPair.ShaddowA];
    [self.view addSubview:SpawnedPair.ShaddowB];
	
	
	if(CurrentDevice.orientation != UIDeviceOrientationPortrait && CurrentDevice.orientation != UIDeviceOrientationUnknown ){
		SpawnedPair.ItemA.transform = spawnedShapeRotateTransformA;
		SpawnedPair.ItemB.transform = spawnedShapeRotateTransformA;
		SpawnedPair.ShaddowA.transform = spawnedShapeRotateTransformA;
		SpawnedPair.ShaddowB.transform = spawnedShapeRotateTransformA;
	}
	
	
}


- (void)resetTap:(NSTimer *)tapTimer 
{
	GameItem *tappedShape = (GameItem *)[tapTimer userInfo];
	tappedShape.tapped = 0;
}

-(void)ResetShapePair:(ItemPair *)pair{
	pair.ItemA.center = CGPointMake((spawnX), spawnY);
	pair.ItemB.center = CGPointMake((spawnX + SHAPE_WIDTH), spawnY);
}

/*****************************************************
 UIController Delegates
 *****************************************************/
- (void)viewDidLoad {   
    Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
	gameState = [appDelegate FetchGameState];
	powerItem = [[PowerItem alloc]init];
	
	audio = [appDelegate FetchAudio];
	discardCount = 0;
	transformCount = 0;
	spawnX = SPAWN_LOCATION_X;
	spawnY = SPAWN_LOCATION_Y;
	spawnNextX = SPAWN_LOCATION_X;
	spawnNextY = SPAWN_LOCATION_Y - 78;
	rightPix = 30;
	upPix = 0;
	
	//// Create background
	backGround = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 480, 480)];
	backGround.clipsToBounds = YES;
	backGround.autoresizesSubviews = NO;
	backGround.contentMode = UIViewContentModeTopLeft;
	backGround.image = [[UIImage imageNamed:@"gameBoardGrid.png"] retain];
	backGround.userInteractionEnabled = FALSE;
	self.view.backgroundColor = [UIColor blackColor];
    
    
    lockSet = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lockTab.png"]];
    lockSet.center = CGPointMake(lockSet.center.x, lockSet.center.y - 180);
    closeLock.center = CGPointMake(closeLock.center.x, closeLock.center.y - 180);
    lockFeedBackA = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lockFeedBack.png"]];
    lockFeedBackA.center = CGPointMake(lockSet.center.x, lockSet.center.y);
	lockFeedBackB = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lockFeedBack.png"]];
    lockFeedBackB.center = CGPointMake(lockSet.center.x + 100, lockSet.center.y);
	lockFeedBackC = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lockFeedBack.png"]];
    lockFeedBackC.center = CGPointMake(lockSet.center.x - 100, lockSet.center.y);
    guessView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lockFeedBack.png"]];
	
	[self.view addSubview:backGround];
	[self.view sendSubviewToBack:backGround];
	[self.view addSubview:buttonMenu];
    [self.view addSubview:buttonMenu];
	[self.view addSubview:checkLock];
    [self.view addSubview:lockSet];
    [self.view addSubview:closeLock];
    [self.view addSubview:lockFeedBackA];
	[self.view addSubview:lockFeedBackB];
	[self.view addSubview:lockFeedBackC];
    [self.view sendSubviewToBack:buttonMenu];
    
	
	menuViewCenter = menuView.center;
	
	//add solution to view
	
	CurrentDevice = [UIDevice currentDevice];
	[CurrentDevice beginGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didRotate:)
												 name:@"UIDeviceOrientationDidChangeNotification" object:nil];
	
	currentLevel = [[Level alloc] init:[gameState.currentLevel intValue]];
	
	
	itemCollection = [[ItemCollection alloc] init:NUMBER_OF_ROWS :NUMBER_OF_COLUMNS :SHAPE_WIDTH :SHAPE_WIDTH: currentLevel];
	SpawnedPair = [ItemPair new];
	nextPair = [ItemPair new];
	
	nextPair.ItemA = [[Shape alloc] initWithInfo:[currentLevel createRandomColor]: [currentLevel createShapeFromCollection] : CGPointMake(20,20)];
	nextPair.ItemB = [[Shape alloc] initWithInfo:[currentLevel createRandomColor]: [currentLevel createShapeFromCollection] : CGPointMake(20,20)];
	
	
	if([gameState.currentBoard.Active boolValue])
	{
		//[SpawnedPair.ItemC removeFromSuperview];
		
        NSArray * spawnedItems = [appDelegate FetchSpawnedItems];
        ItemState * itemA = [spawnedItems objectAtIndex:0];
        ItemState * itemB = [spawnedItems objectAtIndex:1];
        
        Shape * shapeA = [[[Shape alloc] initWithInfo:[itemA.colorType intValue] :[itemA.shapeType intValue] : CGPointMake(spawnX,spawnY)]retain];
        Shape * shapeB = [[[Shape alloc] initWithInfo:[itemB.colorType intValue] :[itemB.shapeType intValue] : CGPointMake(spawnX,spawnY)]retain];
		[self SpawnShapes:shapeA : shapeB];
		
		
		for(ItemState * item in [appDelegate FetchLockItems])
		{
			if([item.shapeType intValue] != -1 && [item.colorType intValue] != -1)
			{
				
				LockShape * lockShape = [[LockShape alloc] initWithInfo:[item.colorType intValue] :
										 [item.shapeType intValue] :
										 CGPointMake(spawnX,spawnY)];
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
				
				Shape * shape = [[[Shape alloc] initWithInfo:[item.colorType intValue] :[item.shapeType intValue] : CGPointMake(spawnX,spawnY)]retain];
				
				Cell * cell = [itemCollection GetCell:[item.Row intValue] : [item.Column intValue]];
				[itemCollection SetItemToCell:shape : cell];
				[self.view addSubview:shape];
			}
		}
		
		[itemCollection UpdateState];
		
		[SpawnedPair Reset];
		
		SpawnedPair.ItemA.ItemView.contentMode = UIViewContentModeScaleAspectFit;
		SpawnedPair.ItemB.ItemView.contentMode = UIViewContentModeScaleAspectFit;
		SpawnedPair.ItemC.ItemView.contentMode = UIViewContentModeScaleAspectFit;
		
		[self.view addSubview:SpawnedPair.ItemC];
		[self.view addSubview:SpawnedPair.ItemB];
		[self.view addSubview:SpawnedPair.ItemA];
		
		[self.view addSubview:SpawnedPair.ShaddowA];
		[self.view addSubview:SpawnedPair.ShaddowB];
		
		[self.view addSubview:nextPair.ItemA];
		[self.view addSubview:nextPair.ItemB];
		
		
	}else{
        [self SpawnShapes];
		gameState.currentBoard.Active = [NSNumber numberWithBool:YES];
		
		
	}
	[currentLevel addSolutionToView:self.view];
	
	[self didRotate:nil];
	[itemCollection ApplyGravity];
	[super viewDidLoad];
	
	startTime = CFAbsoluteTimeGetCurrent();
	
	
	
}


-(void)didRotate:(NSNotification *)notification{
    switch (CurrentDevice.orientation) {
        case UIInterfaceOrientationLandscapeRight:
            spawnX = 234;
			spawnY = 96;
			
			spawnNextX = 152;
			spawnNextY = 68;
			
			rightPix = 0;
			upPix = 30;
			
			[itemCollection SetGravity:left];
			[backGround.image release];
			backGround.image = [[UIImage imageNamed:@"rotatedSideRight.png"] retain];
			[self.view addSubview:backGround];
			[self.view sendSubviewToBack:backGround];
			[self.view sendSubviewToBack:buttonMenu];
			
			
			SpawnedPair.ItemA.center = CGPointMake(spawnX,spawnY);
			SpawnedPair.ItemB.center = CGPointMake(spawnX + 30,spawnY);
			SpawnedPair.ItemC.center = CGPointMake(spawnX + 15,spawnY);
			
			nextPair.ItemA.center = CGPointMake(spawnNextX,spawnNextY);
			nextPair.ItemB.center = CGPointMake(spawnNextX + rightPix,spawnNextY + upPix);
			
			checkLock.center = CGPointMake(181,21);
			
			checkLock.transform = CGAffineTransformIdentity;
			checkLock.transform = CGAffineTransformRotate(checkLock.transform, rotate_xDegrees(90));
			
			menuView.transform = CGAffineTransformIdentity;
			menuView.transform = CGAffineTransformRotate(menuView.transform, rotate_xDegrees(90));
			
			SpawnedPair.ItemA.transform = CGAffineTransformIdentity;
			spawnedShapeRotateTransformA = CGAffineTransformRotate(SpawnedPair.ShaddowA.transform, rotate_xDegrees(90));
			SpawnedPair.ItemA.transform = spawnedShapeRotateTransformA;
			
			SpawnedPair.ItemB.transform = CGAffineTransformIdentity;
			SpawnedPair.ItemB.transform = spawnedShapeRotateTransformA;
			
			SpawnedPair.ShaddowA.transform = CGAffineTransformIdentity;
			SpawnedPair.ShaddowA.transform = spawnedShapeRotateTransformA;
			
			SpawnedPair.ShaddowB.transform = CGAffineTransformIdentity;
			SpawnedPair.ShaddowB.transform = spawnedShapeRotateTransformA;
			
			menuView.center = menuViewCenter;
			menuView.center = CGPointMake(menuView.center.x + 130, menuView.center.y - 105);
			
            break;
        case UIInterfaceOrientationLandscapeLeft:
            spawnX = 56;
			spawnY = 98;
			
			spawnNextX = 167;
			spawnNextY = 49;
			
			rightPix = 0;
			upPix = 30;
			
			[itemCollection SetGravity:right];
			
			[backGround.image release];
			backGround.image = [[UIImage imageNamed:@"rotatedSide.png"] retain];
			[self.view addSubview:backGround];
			[self.view sendSubviewToBack:backGround];
			[self.view sendSubviewToBack:buttonMenu];
			
			SpawnedPair.ItemA.center = CGPointMake(spawnX,spawnY);
			SpawnedPair.ItemB.center = CGPointMake(spawnX + 30,spawnY);
			SpawnedPair.ItemC.center = CGPointMake(spawnX + 15,spawnY);
			
			nextPair.ItemA.center = CGPointMake(spawnNextX,spawnNextY);
			nextPair.ItemB.center = CGPointMake(spawnNextX + rightPix,spawnNextY + upPix);
			
			checkLock.center = CGPointMake(141,21);
			
			menuView.transform = CGAffineTransformIdentity;
			menuView.transform = CGAffineTransformRotate(menuView.transform, rotate_xDegrees(270));
			
			checkLock.transform = CGAffineTransformIdentity;
			checkLock.transform = CGAffineTransformRotate(checkLock.transform, rotate_xDegrees(270));
			
			SpawnedPair.ItemA.transform = CGAffineTransformIdentity;
			spawnedShapeRotateTransformA = CGAffineTransformRotate(SpawnedPair.ShaddowA.transform, rotate_xDegrees(270));
			SpawnedPair.ItemA.transform = spawnedShapeRotateTransformA;
			
			SpawnedPair.ItemB.transform = CGAffineTransformIdentity;
			SpawnedPair.ItemB.transform = spawnedShapeRotateTransformA;
			
			SpawnedPair.ShaddowA.transform = CGAffineTransformIdentity;
			SpawnedPair.ShaddowA.transform = spawnedShapeRotateTransformA;
			
			SpawnedPair.ShaddowB.transform = CGAffineTransformIdentity;
			SpawnedPair.ShaddowB.transform = spawnedShapeRotateTransformA;
			
			menuView.center = menuViewCenter;
			menuView.center = CGPointMake(menuView.center.x + 80, menuView.center.y - 105);
            break;
        case UIInterfaceOrientationPortrait:
            spawnX = SPAWN_LOCATION_X;
			spawnY = SPAWN_LOCATION_Y;
			
			spawnNextX = SPAWN_LOCATION_X;
			spawnNextY = SPAWN_LOCATION_Y - 78;
			
			rightPix = 30;
			upPix = 0;
			
			[itemCollection SetGravity:down];
			
			[backGround.image release];
			backGround.image = [[UIImage imageNamed:@"gameBoardGrid.png"] retain];
			
			[self.view addSubview:backGround];
			[self.view sendSubviewToBack:backGround];
			[self.view sendSubviewToBack:buttonMenu];
			
			SpawnedPair.ItemA.center = CGPointMake(SPAWN_LOCATION_X,SPAWN_LOCATION_Y);
			SpawnedPair.ItemB.center = CGPointMake(SPAWN_LOCATION_X + 30,SPAWN_LOCATION_Y);
			SpawnedPair.ItemC.center = CGPointMake(SPAWN_LOCATION_X + 15,SPAWN_LOCATION_Y);
			
			nextPair.ItemA.center = CGPointMake(spawnNextX,spawnNextY);
			nextPair.ItemB.center = CGPointMake(spawnNextX + rightPix,spawnNextY + upPix);
			
			checkLock.center = CGPointMake(284,83);
			checkLock.transform = CGAffineTransformIdentity;
			menuView.transform = CGAffineTransformIdentity;
			SpawnedPair.ItemA.transform = CGAffineTransformIdentity;
			SpawnedPair.ItemB.transform = CGAffineTransformIdentity;
			SpawnedPair.ShaddowA.transform = CGAffineTransformIdentity;
			SpawnedPair.ShaddowB.transform = CGAffineTransformIdentity;
			menuView.center = menuViewCenter;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            
			spawnX = 145;
			spawnY = 372;
			
			spawnNextX = 145;
			spawnNextY = 450;
			
			rightPix = 30;
			upPix = 0;
			
			[itemCollection SetGravity:up];
			
			[backGround.image release];
			backGround.image = [[UIImage imageNamed:@"upsideDownBack.png"] retain];
			[self.view addSubview:backGround];
			[self.view sendSubviewToBack:backGround];
			[self.view sendSubviewToBack:buttonMenu];
			
			SpawnedPair.ItemA.center = CGPointMake(spawnX,spawnY);
			SpawnedPair.ItemB.center = CGPointMake(spawnX + 30,spawnY);
			SpawnedPair.ItemC.center = CGPointMake(spawnX + 15,spawnY);
			
			nextPair.ItemA.center = CGPointMake(spawnNextX,spawnNextY);
			nextPair.ItemB.center = CGPointMake(spawnNextX + rightPix,spawnNextY + upPix);
			
			checkLock.center = CGPointMake(284,401);
			
			checkLock.transform = CGAffineTransformIdentity;
			checkLock.transform = CGAffineTransformRotate(checkLock.transform, rotate_xDegrees(180));
			
			menuView.transform = CGAffineTransformIdentity;
			menuView.transform = CGAffineTransformRotate(menuView.transform, rotate_xDegrees(180));
			
			SpawnedPair.ItemA.transform = CGAffineTransformIdentity;
			spawnedShapeRotateTransformA = CGAffineTransformRotate(SpawnedPair.ShaddowA.transform, rotate_xDegrees(180));
			SpawnedPair.ItemA.transform = spawnedShapeRotateTransformA;
			
			SpawnedPair.ItemB.transform = CGAffineTransformIdentity;
			SpawnedPair.ItemB.transform = spawnedShapeRotateTransformA;
			
			SpawnedPair.ShaddowA.transform = CGAffineTransformIdentity;
			SpawnedPair.ShaddowA.transform = spawnedShapeRotateTransformA;
			
			SpawnedPair.ShaddowB.transform = CGAffineTransformIdentity;
			SpawnedPair.ShaddowB.transform = spawnedShapeRotateTransformA;
			
			menuView.center = menuViewCenter;
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
	[SpawnedPair.ItemA removeFromSuperview];
	[SpawnedPair.ItemB removeFromSuperview];
	[SpawnedPair.ItemC removeFromSuperview];
	[nextPair.ItemA removeFromSuperview];
	[nextPair.ItemB removeFromSuperview];
	[SpawnedPair.ShaddowA removeFromSuperview];
	[SpawnedPair.ShaddowB removeFromSuperview];
	[SpawnedPair release];
	[nextPair release];
	[itemCollection cleanBoard];
	[itemCollection dealloc];
	[powerItem dealloc];
	SpawnedPair = nil;
	nextPair = nil;
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
    
    
}
-(IBAction)ClickButtonOptions{
    [self presentModalViewController:[[Options alloc] initWithNibName:@"Options" bundle:nil] animated:YES];
}
-(IBAction)ClickButtonMainMenu{
	gameState.currentBoard.Active = [NSNumber numberWithBool:NO];
    [self dismissModalViewControllerAnimated:YES];
	
}

-(IBAction)ClickButtonLockTab{
    lockMode = TRUE;
    
    [UIView beginAnimations:nil context:nil]; 
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:self];
    
    [self.view bringSubviewToFront:lockSet];
    lockSet.center = CGPointMake(lockSet.center.x, lockSet.center.y + 180);
    
    [self.view bringSubviewToFront:closeLock];
    closeLock.center = CGPointMake(closeLock.center.x, closeLock.center.y + 180);
    
    [self.view bringSubviewToFront:lockFeedBackA];
	[self.view bringSubviewToFront:lockFeedBackB];
	[self.view bringSubviewToFront:lockFeedBackC];
    lockFeedBackA.center = CGPointMake(lockFeedBackA.center.x, lockFeedBackA.center.y + 180);
	lockFeedBackB.center = CGPointMake(lockFeedBackB.center.x, lockFeedBackB.center.y + 180);
	lockFeedBackC.center = CGPointMake(lockFeedBackC.center.x, lockFeedBackC.center.y + 180);
    
    [UIView commitAnimations];
}

-(IBAction)ClickButtonCloseLockTab{
    lockMode = FALSE;
    
    [UIView beginAnimations:nil context:nil]; 
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:self];
    
    lockSet.center = CGPointMake(lockSet.center.x, lockSet.center.y - 180);
    closeLock.center = CGPointMake(closeLock.center.x, closeLock.center.y - 180);
    lockFeedBackA.center = CGPointMake(lockFeedBackA.center.x, lockFeedBackA.center.y - 180);
	lockFeedBackB.center = CGPointMake(lockFeedBackB.center.x, lockFeedBackB.center.y - 180);
	lockFeedBackC.center = CGPointMake(lockFeedBackC.center.x, lockFeedBackC.center.y - 180);
    
    
    
    [UIView commitAnimations];
}

-(IBAction)discardPiece{
	if(transformCount >= 10){
		transformCount = 0;
		discardCount = 0;
	}
	
	if(discardCount <= 3){
		[SpawnedPair.ItemA removeFromSuperview];
		[SpawnedPair.ItemB removeFromSuperview];
		[SpawnedPair.ItemC removeFromSuperview];
		[SpawnedPair.ShaddowA removeFromSuperview];
		[SpawnedPair.ShaddowB removeFromSuperview];
		
		[self SpawnShapes];
		[self ResetShapePair:SpawnedPair];
		
		discardCount++;
		
	}
}

/*****************************************************
 Touches
 *****************************************************/

-(CGFloat)isTouchWithinRange:(CGPoint)touch from:(CGPoint)center{
	
	float x = center.x - touch.x;
	float y = center.y - touch.y;
	
	return sqrt(x * x + y * y);
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	startTouchPosition = [touch locationInView:self.view];
	Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.isMoving = YES;
    GameItem * touchedGuessItem;
    if (lockMode == FALSE) {
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
                if(powerTouchItem.colorType == Yellow){
                    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
                    [powerItem makeCollection:itemCollection];
                    [powerItem stopGravity:powerTouchItem];
                }
                if(powerTouchItem.colorType == Green){
                    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
                    [powerItem makeCollection:itemCollection];
                    [powerItem placeFilter:powerTouchItem];
                    
                }
                /*
                 if(powerTouchItem.colorType == Blue){
                 [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
                 [powerItem makeCollection:itemCollection];
                 [powerItem placeUpgrader:powerTouchItem];
                 }
                 */
                if(powerTouchItem.colorType == Blue){
                    [powerItem makeCollection:itemCollection];
                    [powerItem shuffleBoard:powerTouchItem];
                    [self SaveState];
                    [SpawnedPair.ItemA removeFromSuperview];
                    [SpawnedPair.ItemB removeFromSuperview];
                    [SpawnedPair.ItemC removeFromSuperview];
                    [SpawnedPair.ShaddowA removeFromSuperview];
                    [SpawnedPair.ShaddowB removeFromSuperview];
                    [self viewDidLoad];
                    [itemCollection ApplyGravity];
                    
                }
                
            }
            
            touchedItem.tapped++;
            TouchTimer = [NSTimer scheduledTimerWithTimeInterval:TAP_WAIT_TIME target:self selector:@selector(resetTap:) userInfo:touchedItem repeats:NO];
            
        }
        
        if([[touch view] isKindOfClass: [Shape class]]){
            if(appDelegate.isAttaching == YES){
                appDelegate.isAttaching = NO;
                [powerItem makeAnchor:(Shape *)[touch view]];
                
            }
            if(appDelegate.isFiltering == YES){
                appDelegate.isFiltering = NO;
                [powerItem makeFilter:(Shape *)[touch view]];
                
            }
            if(appDelegate.isUpgrading == YES){
                appDelegate.isUpgrading = NO;
                [powerItem makeUpgrader:(Shape *)[touch view]];
                
                
            }
            
        }
        
        
        
    }
    
    else {
        
        if([[touch view] isKindOfClass: [Shape class]]){
            touchedGuessItem = (GameItem *)[touch view];
            guessView.image = touchedGuessItem.ItemView.image;
            guessView.center = CGPointMake([touch locationInView:self.view].x - 55, [touch locationInView:self.view].y - 55);
            [self.view addSubview:guessView];
            appDelegate.isMoving = TRUE;
            
        }
        
    }
	
    
    
}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
	currentTouchPosition = [touch locationInView:self.view];
    
    if (lockMode == FALSE) {
		
        if(![[touch view] isKindOfClass: [LockShape class]] && appDelegate.isAttaching == NO)
        {
            GameItem * highlightItem = [itemCollection GetItemFromCoordinate:[touch locationInView:backGround]]; 
            if([highlightItem isKindOfClass:[Shape class]] && ! highlightItem.IsPaired && SpawnedPair.ItemC.alpha != 1)
            {
                Shape * shape = (Shape *) highlightItem;
                [itemCollection AddShapeToSolution:shape];
                shape.tapped = 0;
            }
        }
        if([[touch view] isMemberOfClass:[DrawingView class]] && [touch view] != backGround && touchDistanceToItemC < 55.0f)
        {
            
            [SpawnedPair airMove:[touch locationInView:[self view]]];
            SpawnedPair.ItemC.alpha = 1;
            [itemCollection DrawShadowForItemPair:SpawnedPair];
            
        }
		
		
    }
    if (lockMode == TRUE && appDelegate.isMoving == TRUE) {
        GameItem * touchedGuessItem;
        touchedGuessItem = (GameItem *)[touch view];
        guessView.center = CGPointMake([touch locationInView:self.view].x - 55, [touch locationInView:self.view].y - 55);
    }
	
}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
    Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
	SpawnedPair.ItemC.center = CGPointMake((SpawnedPair.ItemA.center.x + SpawnedPair.ItemB.center.x)/2, (SpawnedPair.ItemA.center.y + SpawnedPair.ItemB.center.y)/2);
	SpawnedPair.ItemC.alpha = 0.25f;
	
	
	/* Shape was touched */
	
    if (lockMode == FALSE) {
        
        if([SpawnedPair IsInGrid] && [touch view] != backGround)
        {
            if([itemCollection AddItemPair:SpawnedPair])
            {
                [SpawnedPair.ItemC release];
                [SpawnedPair.ItemC removeFromSuperview];
                SpawnedPair.ItemC = nil;
                [self SpawnShapes];
                return;
                
                
            }else
            {
                [self ResetShapePair:SpawnedPair];
                return;
            }
        }
        
        if([[touch view] isKindOfClass: [GameItem class]] && ![[touch view] isKindOfClass: [LockShape class]]){
			GameItem * item = (GameItem *)[touch view];
            
            if(SpawnedPair.ItemA.IsPaired && [self isTouchWithinRange: startTouchPosition from: SpawnedPair.ItemC.center] < 50.0f && ![[touch view] isKindOfClass: [LockShape class]] && [[touch view] isKindOfClass: [GameItem class]]){
                
				
                if (item.tapped == 1) 
                {
                    item.tapped = 0;
                    
                    [SpawnedPair rotate:SpawnedPair.ItemA];
                    SpawnedPair.ItemC.center = [drawingView makeCirclePoint:SpawnedPair.ItemA.center :SpawnedPair.ItemB.center];
                    return;
                    
                    
                    
                }
            }else
            {
                if(item.tapped > 0)
                {
                    item.tapped = 0;
                    if([itemCollection TransformItem:item])
                    {	
                        return;
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
                    
                    //attemptsString.text = [[NSString alloc] initWithFormat:@" %d\n", currentLevel.attempts];
                }
            }
			
        }
    }
    if (lockMode == TRUE && appDelegate.isMoving == TRUE) {
        appDelegate.isMoving = FALSE;
        [guessView removeFromSuperview];
		
    }
	
    [itemCollection ClearSolution];
	[NSTimer release];
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

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
@synthesize score, scoreLabel, drawingView, startTouchPosition, currentTouchPosition, touchDistanceToItemC;
@synthesize discardCount, transformCount, spawnedShapeRotateTransform, checkLock, closeLock, checkRecipe, reshuffleCount, upgradeCount;
@synthesize discardButton, bombButton, reshuffleButton, upgradeButton;


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
	checkRecipe.center = CGPointMake(checkRecipe.center.x, checkRecipe.center.y - 180);
    lockFeedBackA = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lockFeedBack.png"]];
    lockFeedBackA.center = CGPointMake(lockSet.center.x, lockSet.center.y);
	lockFeedBackB = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lockFeedBack.png"]];
    lockFeedBackB.center = CGPointMake(lockSet.center.x + 100, lockSet.center.y);
	lockFeedBackC = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lockFeedBack.png"]];
    lockFeedBackC.center = CGPointMake(lockSet.center.x - 100, lockSet.center.y);
    guessView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lockFeedBack.png"]];
	
	scoreLabel.text = [NSString stringWithFormat:@"%d" , score];
	scoreLabel.center = CGPointMake(64,31);
	
	upgradeButton.center = CGPointMake(18,99);
	discardButton.center = CGPointMake(38,99);
	bombButton.center = CGPointMake(58,99);
	reshuffleButton.center = CGPointMake(78,99);
	
	upgradeCountImage.center = upgradeButton.center;
	discardCountImage.center = discardButton.center;
	bombCountImage.center = bombButton.center;
	reshuffleCountImage.center = reshuffleButton.center;
	
	[self.view addSubview:backGround];
	[self.view sendSubviewToBack:backGround];
	[self.view addSubview:buttonMenu];
    [self.view addSubview:buttonMenu];
	[self.view addSubview:checkLock];
    [self.view addSubview:lockSet];
    [self.view addSubview:closeLock];
	[self.view addSubview:checkRecipe];
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
        
        Shape * spawnA = [[[Shape alloc] initWithInfo:[itemA.colorType intValue] :[itemA.shapeType intValue] : CGPointMake(spawnX,spawnY)]retain];
        Shape * spawnB = [[[Shape alloc] initWithInfo:[itemB.colorType intValue] :[itemB.shapeType intValue] : CGPointMake(spawnX,spawnY)]retain];
		[self SpawnShapes:spawnA : spawnB];
		
		
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
	
	
	
	[self setButtons];
}

-(void)setButtons{
	NSString *discardString = [NSString stringWithFormat:@"%dDiscard.png", discardCount]; 
	UIImage *discardImage = [UIImage imageNamed:discardString];
	discardCountImage.image = discardImage;
	
	NSString *bombString = [NSString stringWithFormat:@"%dbomb.png", bombCount]; 
	UIImage *bombImage = [UIImage imageNamed:bombString];
	bombCountImage.image = bombImage;
	
	NSString *shuffleString = [NSString stringWithFormat:@"%dshuffle.png", reshuffleCount]; 
	UIImage *shuffleImage = [UIImage imageNamed:shuffleString];
	reshuffleCountImage.image = shuffleImage;
	
	NSString *upgradeString = [NSString stringWithFormat:@"%dupgrade.png", upgradeCount]; 
	UIImage *upgradeImage = [UIImage imageNamed:upgradeString];
	upgradeCountImage.image = upgradeImage;
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
			spawnedShapeRotateTransform = CGAffineTransformRotate(CGAffineTransformIdentity, rotate_xDegrees(90));
			
			
			SpawnedPair.ItemA.center = CGPointMake(spawnX,spawnY);
			SpawnedPair.ItemB.center = CGPointMake(spawnX + 30,spawnY);
			SpawnedPair.ItemC.center = CGPointMake(spawnX + 15,spawnY);
			
			nextPair.ItemA.center = CGPointMake(spawnNextX,spawnNextY);
			nextPair.ItemB.center = CGPointMake(spawnNextX + rightPix,spawnNextY + upPix);
			
			menuView.center = menuViewCenter;
			menuView.center = CGPointMake(menuView.center.x + 130, menuView.center.y - 105);
			
			checkLock.center = CGPointMake(181,21);
			
			scoreLabel.center = CGPointMake(38,87);
			
			upgradeButton.center = CGPointMake(276,13);
			discardButton.center = CGPointMake(253,13);
			bombButton.center = CGPointMake(230,13);
			reshuffleButton.center = CGPointMake(207,13);
			
			upgradeCountImage.center = upgradeButton.center;
			discardCountImage.center = discardButton.center;
			bombCountImage.center = bombButton.center;
			reshuffleCountImage.center = reshuffleButton.center;
			
			
			upgradeCountImage.transform = spawnedShapeRotateTransform;
			discardCountImage.transform = spawnedShapeRotateTransform;
			bombCountImage.transform = spawnedShapeRotateTransform;
			reshuffleCountImage.transform = spawnedShapeRotateTransform;
			checkLock.transform = spawnedShapeRotateTransform;
			scoreLabel.transform = spawnedShapeRotateTransform;
			menuView.transform = spawnedShapeRotateTransform;
			SpawnedPair.ItemA.transform = spawnedShapeRotateTransform;
			SpawnedPair.ItemB.transform = spawnedShapeRotateTransform;
			SpawnedPair.ShaddowA.transform = spawnedShapeRotateTransform;
			SpawnedPair.ShaddowB.transform = spawnedShapeRotateTransform;
			nextPair.ItemA.transform = spawnedShapeRotateTransform;
			nextPair.ItemB.transform = spawnedShapeRotateTransform;
			
			
			
			
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
			spawnedShapeRotateTransform = CGAffineTransformRotate(CGAffineTransformIdentity, rotate_xDegrees(270));
			
			SpawnedPair.ItemA.center = CGPointMake(spawnX,spawnY);
			SpawnedPair.ItemB.center = CGPointMake(spawnX + 30,spawnY);
			SpawnedPair.ItemC.center = CGPointMake(spawnX + 15,spawnY);
			
			nextPair.ItemA.center = CGPointMake(spawnNextX,spawnNextY);
			nextPair.ItemB.center = CGPointMake(spawnNextX + rightPix,spawnNextY + upPix);
			
			menuView.center = menuViewCenter;
			menuView.center = CGPointMake(menuView.center.x + 80, menuView.center.y - 105);
			
			checkLock.center = CGPointMake(141,21);
			
			scoreLabel.center = CGPointMake(282,52);
			
			upgradeButton.center = CGPointMake(43,13);
			discardButton.center = CGPointMake(66,13);
			bombButton.center = CGPointMake(89,13);
			reshuffleButton.center = CGPointMake(112,13);
			
			upgradeCountImage.center = upgradeButton.center;
			discardCountImage.center = discardButton.center;
			bombCountImage.center = bombButton.center;
			reshuffleCountImage.center = reshuffleButton.center;
			
			upgradeCountImage.transform = spawnedShapeRotateTransform;
			discardCountImage.transform = spawnedShapeRotateTransform;
			bombCountImage.transform = spawnedShapeRotateTransform;
			reshuffleCountImage.transform = spawnedShapeRotateTransform;
			checkLock.transform = spawnedShapeRotateTransform;
			scoreLabel.transform = spawnedShapeRotateTransform;
			menuView.transform = spawnedShapeRotateTransform;
			SpawnedPair.ItemA.transform = spawnedShapeRotateTransform;
			SpawnedPair.ItemB.transform = spawnedShapeRotateTransform;
			SpawnedPair.ShaddowA.transform = spawnedShapeRotateTransform;
			SpawnedPair.ShaddowB.transform = spawnedShapeRotateTransform;
			nextPair.ItemA.transform = spawnedShapeRotateTransform;
			nextPair.ItemB.transform = spawnedShapeRotateTransform;
			
			
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
			scoreLabel.center = CGPointMake(64,31);
			menuView.center = menuViewCenter;
			
			upgradeButton.center = CGPointMake(18,99);
			discardButton.center = CGPointMake(38,99);
			bombButton.center = CGPointMake(58,99);
			reshuffleButton.center = CGPointMake(78,99);
			
			upgradeCountImage.center = upgradeButton.center;
			discardCountImage.center = discardButton.center;
			bombCountImage.center = bombButton.center;
			reshuffleCountImage.center = reshuffleButton.center;
			
			scoreLabel.transform = CGAffineTransformIdentity;
			upgradeCountImage.transform = CGAffineTransformIdentity;
			discardCountImage.transform = CGAffineTransformIdentity;
			bombCountImage.transform = CGAffineTransformIdentity;
			reshuffleCountImage.transform = CGAffineTransformIdentity;
			checkLock.transform = CGAffineTransformIdentity;
			menuView.transform = CGAffineTransformIdentity;
			SpawnedPair.ItemA.transform = CGAffineTransformIdentity;
			SpawnedPair.ItemB.transform = CGAffineTransformIdentity;
			SpawnedPair.ShaddowA.transform = CGAffineTransformIdentity;
			SpawnedPair.ShaddowB.transform = CGAffineTransformIdentity;
			nextPair.ItemA.transform = CGAffineTransformIdentity;
			nextPair.ItemB.transform = CGAffineTransformIdentity;
			
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            
			spawnX = SPAWN_LOCATION_X;
			spawnY = SPAWN_LOCATION_Y;
			
			spawnNextX = SPAWN_LOCATION_X;
			spawnNextY = SPAWN_LOCATION_Y - 78;
			
			rightPix = 30;
			upPix = 0;
			
			[itemCollection SetGravity:up];
			
			[backGround.image release];
			backGround.image = [[UIImage imageNamed:@"upsideDownBack.png"] retain];
			[self.view addSubview:backGround];
			[self.view sendSubviewToBack:backGround];
			[self.view sendSubviewToBack:buttonMenu];
			
			SpawnedPair.ItemA.center = CGPointMake(SPAWN_LOCATION_X,SPAWN_LOCATION_Y);
			SpawnedPair.ItemB.center = CGPointMake(SPAWN_LOCATION_X + 30,SPAWN_LOCATION_Y);
			SpawnedPair.ItemC.center = CGPointMake(SPAWN_LOCATION_X + 15,SPAWN_LOCATION_Y);
			spawnedShapeRotateTransform = CGAffineTransformRotate(CGAffineTransformIdentity, rotate_xDegrees(180));
			
			nextPair.ItemA.center = CGPointMake(spawnNextX,spawnNextY);
			nextPair.ItemB.center = CGPointMake(spawnNextX + rightPix,spawnNextY + upPix);
			
			checkLock.center = CGPointMake(284,83);
			scoreLabel.center = CGPointMake(64,31);
			menuView.center = menuViewCenter;
			
			upgradeButton.center = CGPointMake(78,99);
			discardButton.center = CGPointMake(58,99);
			bombButton.center = CGPointMake(38,99);
			reshuffleButton.center = CGPointMake(18,99);
			
			upgradeCountImage.center = upgradeButton.center;
			discardCountImage.center = discardButton.center;
			bombCountImage.center = bombButton.center;
			reshuffleCountImage.center = reshuffleButton.center;
			
			upgradeCountImage.transform = spawnedShapeRotateTransform;
			discardCountImage.transform = spawnedShapeRotateTransform;
			bombCountImage.transform = spawnedShapeRotateTransform;
			reshuffleCountImage.transform = spawnedShapeRotateTransform;
			checkLock.transform = spawnedShapeRotateTransform;
			scoreLabel.transform = spawnedShapeRotateTransform;
			menuView.transform = spawnedShapeRotateTransform;
			SpawnedPair.ItemA.transform = spawnedShapeRotateTransform;
			SpawnedPair.ItemB.transform = spawnedShapeRotateTransform;
			SpawnedPair.ShaddowA.transform = spawnedShapeRotateTransform;
			SpawnedPair.ShaddowB.transform = spawnedShapeRotateTransform;
			nextPair.ItemA.transform = spawnedShapeRotateTransform;
			nextPair.ItemB.transform = spawnedShapeRotateTransform;
			
			
            break;            
        default:
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
			scoreLabel.center = CGPointMake(64,31);
			
			upgradeButton.center = CGPointMake(18,99);
			discardButton.center = CGPointMake(38,99);
			bombButton.center = CGPointMake(58,99);
			reshuffleButton.center = CGPointMake(78,99);
			
			upgradeCountImage.center = upgradeButton.center;
			discardCountImage.center = discardButton.center;
			bombCountImage.center = bombButton.center;
			reshuffleCountImage.center = reshuffleButton.center;
			
			scoreLabel.transform = CGAffineTransformIdentity;
			upgradeCountImage.transform = CGAffineTransformIdentity;
			discardCountImage.transform = CGAffineTransformIdentity;
			bombCountImage.transform = CGAffineTransformIdentity;
			reshuffleCountImage.transform = CGAffineTransformIdentity;
			checkLock.transform = CGAffineTransformIdentity;
			menuView.transform = CGAffineTransformIdentity;
			SpawnedPair.ItemA.transform = CGAffineTransformIdentity;
			SpawnedPair.ItemB.transform = CGAffineTransformIdentity;
			SpawnedPair.ShaddowA.transform = CGAffineTransformIdentity;
			SpawnedPair.ShaddowB.transform = CGAffineTransformIdentity;
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
	
	[self.view bringSubviewToFront:checkRecipe];
    checkRecipe.center = CGPointMake(checkRecipe.center.x, checkRecipe.center.y + 180);
    
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
	checkRecipe.center = CGPointMake(checkRecipe.center.x, checkRecipe.center.y - 180);
    lockFeedBackA.center = CGPointMake(lockFeedBackA.center.x, lockFeedBackA.center.y - 180);
	lockFeedBackB.center = CGPointMake(lockFeedBackB.center.x, lockFeedBackB.center.y - 180);
	lockFeedBackC.center = CGPointMake(lockFeedBackC.center.x, lockFeedBackC.center.y - 180);
    
    
    
    [UIView commitAnimations];
}
-(IBAction)ClickButtonDiscard{
	if(discardCount > 0){
		[SpawnedPair.ItemA removeFromSuperview];
		[SpawnedPair.ItemB removeFromSuperview];
		[SpawnedPair.ItemC removeFromSuperview];
		[SpawnedPair.ShaddowA removeFromSuperview];
		[SpawnedPair.ShaddowB removeFromSuperview];
		
		[self SpawnShapes];
		[self ResetShapePair:SpawnedPair];
		
		discardCount = discardCount - 1;
		[self setButtons];
	}
		
}

-(IBAction)ClickButtonUpgrade{
	if(upgradeCount > 0){
		Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
		[powerItem makeCollection:itemCollection];
		appDelegate.isUpgrading = YES;
		
		upgradeCount = upgradeCount - 1;
		[self setButtons];
	}
}
-(IBAction)ClickButtonBomb{
	if(bombCount > 0){
		Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
		appDelegate.isBombing = YES;
	}
}

-(IBAction)ClickButtonShuffle{
	Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
	if(reshuffleCount > 0){	
		int row = 0;
		int column = 0;
		
		NSMutableArray * shuffleArray = [[NSMutableArray alloc] initWithCapacity:100];
		
		for (row = 0; row < NUMBER_OF_ROWS; row++) {
			for (column =0; column < NUMBER_OF_COLUMNS; column++) {
				
				Cell *removeCell = [itemCollection GetCell:row :column];

				if(removeCell.ItemInCell != nil){
					[shuffleArray addObject:removeCell.ItemInCell];
				}
			}
		}
		
		int i,j;
		int numberOfShapes = [shuffleArray count];
		
		for( i = 0; i < numberOfShapes; i++ ){
			j = rand() % numberOfShapes;
			[shuffleArray exchangeObjectAtIndex:i withObjectAtIndex:j];
		}
		
		[itemCollection cleanBoard];
		[itemCollection setShuffledArray:shuffleArray];
		[shuffleArray release];

		
		[self SaveState];
		
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
	}

}


-(IBAction)ClickButtonCheckRecipe{
	if(shapeA.shapeType == shapeB.shapeType && shapeB.shapeType == shapeC.shapeType){
		if(shapeA.colorType == shapeB.colorType && shapeB.colorType == shapeC.colorType){	
			if(shapeA.shapeType == Square){
				discardCount++;
				//all squares same color
				NSLog(@"1 extra discard");
			}
			if(shapeA.shapeType == Pentagon){
				bombCount++;
				//all pentagons same color
				NSLog(@"1 extra bomb");
			}
			if(shapeA.shapeType == Hexagon){
				discardCount = discardCount + 2;
				NSLog(@"3 extra discards");
				//all hexs same color
			}
			if(shapeA.shapeType == Circle){
				NSLog(@"destroy all of that color on the board");
				//all circle same color
			}
		}
		if(shapeA.colorType != shapeB.colorType && shapeA.colorType != shapeC.colorType && shapeB.colorType != shapeC.colorType){
			if(shapeA.shapeType == Square){
				NSLog(@"1 piece instant upgrade");
				//all squares dif color
			}
			if(shapeA.shapeType == Pentagon){
				NSLog(@"3 piece instant upgrade");
				//all pentagons dif color
			}
			if(shapeA.shapeType == Hexagon){
				reshuffleCount++;
				NSLog(@"1 reshuffle");
				//all hexs dif color
			}
			if(shapeA.shapeType == Circle){
				bombCount = bombCount + 5;
				NSLog(@"5 extra bombs");
				//all circles dif color
			}	
		}
	}
	if(shapeA.colorType == shapeB.colorType && shapeB.shapeType == shapeC.colorType){
		if(shapeA.shapeType == Square || shapeB.shapeType == Square || shapeC.shapeType == Square){
			if(shapeA.shapeType == Pentagon || shapeB.shapeType == Pentagon || shapeC.shapeType == Pentagon){
				if(shapeA.shapeType == Hexagon || shapeB.shapeType == Hexagon || shapeC.shapeType == Hexagon){
					//Square, pentagon, hexagon of same color
					NSLog(@"5 piece instant upgrade");
				}
			}
		}
		if(shapeA.shapeType == Triangle || shapeB.shapeType == Triangle || shapeC.shapeType == Triangle){
			if(shapeA.shapeType == Square || shapeB.shapeType == Square || shapeC.shapeType == Square){
				if(shapeA.shapeType == Pentagon || shapeB.shapeType == Pentagon || shapeC.shapeType == Pentagon){
					bombCount = bombCount + 2;
					//Triangle, square, pentagon of same color
					NSLog(@"2 bombs");
				}
			}
		}
		if(shapeA.shapeType == Pentagon || shapeB.shapeType == Pentagon || shapeC.shapeType == Pentagon){
			if(shapeA.shapeType == Hexagon || shapeB.shapeType == Hexagon || shapeC.shapeType == Hexagon){
				if(shapeA.shapeType == Circle || shapeB.shapeType == Circle || shapeC.shapeType == Circle){
					bombCount = bombCount + 2;
					//Pentagon, Hexagon, Circle of same color
					//30 seconds no-gravity
					NSLog(@"30 seconds no gravity ");
				}
			}
		}
	}
	if(shapeA.colorType != shapeB.colorType && shapeA.colorType != shapeC.colorType && shapeB.colorType != shapeC.colorType){
		if(shapeA.shapeType == Square || shapeB.shapeType == Square || shapeC.shapeType == Square){
			if(shapeA.shapeType == Pentagon || shapeB.shapeType == Pentagon || shapeC.shapeType == Pentagon){
				if(shapeA.shapeType == Hexagon || shapeB.shapeType == Hexagon || shapeC.shapeType == Hexagon){
					reshuffleCount++;
					//Square, pentagon, hexagon dif color
					NSLog(@"1 reshuffle");
				}
			}
		}
		if(shapeA.shapeType == Triangle || shapeB.shapeType == Triangle || shapeC.shapeType == Triangle){
			if(shapeA.shapeType == Square || shapeB.shapeType == Square || shapeC.shapeType == Square){
				if(shapeA.shapeType == Pentagon || shapeB.shapeType == Pentagon || shapeC.shapeType == Pentagon){
					discardCount = discardCount + 3;
					//Triangle, square, pentagon dif color
					NSLog(@"3 discards");
				}
			}
		}
		if(shapeA.shapeType == Pentagon || shapeB.shapeType == Pentagon || shapeC.shapeType == Pentagon){
			if(shapeA.shapeType == Hexagon || shapeB.shapeType == Hexagon || shapeC.shapeType == Hexagon){
				if(shapeA.shapeType == Circle || shapeB.shapeType == Circle || shapeC.shapeType == Circle){
					bombCount = bombCount + 3;
					//Pentagon, hexagon, circle dif color
					//30 seconds no-gravity
					NSLog(@"3 extra bombs");
				}
			}
		}
	}
	shapeA = nil;
	shapeB = nil;
	shapeC = nil;
	
	lockFeedBackA.image = [UIImage imageNamed:@"lockFeedBack.png"];
	lockFeedBackB.image = [UIImage imageNamed:@"lockFeedBack.png"];
	lockFeedBackC.image = [UIImage imageNamed:@"lockFeedBack.png"];
	
	if(discardCount > 5){
		discardCount = 5;
	}
	if(bombCount > 5){
		bombCount = 5;
	}
	if(reshuffleCount > 5){
		reshuffleCount = 5;
	}
	if(upgradeCount > 5){
		upgradeCount = 5;
	}
	[self setButtons];
	
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
		
		if([[touch view] isKindOfClass: [GameItem class]] && appDelegate.isBombing == NO && appDelegate.isUpgrading == NO){
            GameItem * touchedItem = (GameItem *)[touch view];
           
            touchedItem.tapped++;
            TouchTimer = [NSTimer scheduledTimerWithTimeInterval:TAP_WAIT_TIME target:self selector:@selector(resetTap:) userInfo:touchedItem repeats:NO];
            
        }
        
        if([[touch view] isKindOfClass: [Shape class]]){
			GameItem * touchedItem = (GameItem *)[touch view];
            Shape * powerTouchItem = (Shape *)touchedItem;
            if(appDelegate.isBombing == YES){
                appDelegate.isBombing = NO;
				[powerItem makeCollection:itemCollection];
                [powerItem useBombItem:powerTouchItem];
                
            }
            if(appDelegate.isFiltering == YES){
                appDelegate.isFiltering = NO;
                [powerItem makeFilter:(Shape *)[touch view]];
                
            }
            if(appDelegate.isUpgrading == YES){
                Cell * cell = [itemCollection GetCell:touchedItem.Row :touchedItem.Column];
				[itemCollection TransformItem:cell.ItemInCell];
				appDelegate.isUpgrading = NO;
				                
                
            }
            
        }
        
        
        
    }
    
    else {
        
        if([[touch view] isKindOfClass: [Shape class]]){
            touchedGuessItem = (GameItem *)[touch view];
			touchedGuessItemShape = (Shape *)touchedGuessItem;
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
		
        if(![[touch view] isKindOfClass: [LockShape class]] && appDelegate.isBombing == NO)
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
	Shape * itemShape = (Shape *)[touch view];
	
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
						if(itemShape.shapeType == Square){
							score = score + 50;
							scoreLabel.text = [NSString stringWithFormat:@"%d" , score];
							return;
						}
						if(itemShape.shapeType == Pentagon){
							score = score + 250;
							scoreLabel.text = [NSString stringWithFormat:@"%d" , score];
							return;
						}
						if(itemShape.shapeType == Hexagon){
							score = score + 1500;
							scoreLabel.text = [NSString stringWithFormat:@"%d" , score];
							return;
						}
						if(itemShape.shapeType == Circle){
							score = score + 7000;
							return;
							scoreLabel.text = [NSString stringWithFormat:@"%d" , score];
						}
						if(itemShape.shapeType == Vortex){
							score = score + 40000;
							return;
							scoreLabel.text = [NSString stringWithFormat:@"%d" , score];
						}
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
    if (lockMode == TRUE && guessView.center.y < 133 ) {
        
		if(guessView.center.x < 105 - 55){
			lockFeedBackC.image = guessView.image;
			shapeB = touchedGuessItemShape;
		}
		if(guessView.center.x > 108 - 55 && guessView.center.x < 210 - 55){
			lockFeedBackA.image = guessView.image;
			shapeA = touchedGuessItemShape;
		}
		if(guessView.center.x > 211 - 55){
			lockFeedBackB.image = guessView.image;
			shapeC = touchedGuessItemShape;
		}
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

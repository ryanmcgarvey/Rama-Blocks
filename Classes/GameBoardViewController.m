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

@synthesize score, drawingView;
@synthesize discardCount, transformCount, spawnedShapeRotateTransform, reshuffleCount, upgradeCount;



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
		gameState.currentBoard.numberOfAttempts = [NSNumber numberWithInt:score];
        
        gameState.currentBoard.discardCount = [NSNumber numberWithInt:discardCount];
		gameState.currentBoard.bombCount = [NSNumber numberWithInt:bombCount];
        gameState.currentBoard.reshuffleCount = [NSNumber numberWithInt:reshuffleCount];
		gameState.currentBoard.upgradeCount = [NSNumber numberWithInt:upgradeCount];
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
	if(SpawnedPair==nil){
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
		nextPair.ItemB = [[Shape alloc] initWithInfo:[currentLevel createRandomColor]: [currentLevel createShapeFromCollection] : CGPointMake(spawnNextX + 30,spawnNextY + 0)];
		
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
	
	nextPair.ItemA.transform = spawnedShapeRotateTransform;
	nextPair.ItemB.transform = spawnedShapeRotateTransform;
	
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

- (void)resetTap:(NSTimer *)tapTimer {
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
-(void)viewDidLoad {   
    Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
	gameState = [appDelegate FetchGameState];
	score = [gameState.currentBoard.numberOfAttempts intValue];
	
    powerItem = [[PowerItem alloc]init];
	backGroundToLoad = @"gameBoardGrid.png";
	
	discardCount = 0;
	transformCount = 0;
	didShuffle = FALSE;
	gravity = down;
	
	spawnX = SPAWN_LOCATION_X;
	spawnY = SPAWN_LOCATION_Y;
	spawnNextX = SPAWN_LOCATION_X;
	spawnNextY = SPAWN_LOCATION_Y - 78;
	
	bombCount = 2;
	scorePopUp.bounds = CGRectMake(0, 0, 30, 30);
	
	scorePopUp.hidden = TRUE;
	
    spawnedShapeRotateTransform = CGAffineTransformIdentity;
	
    CurrentDevice = [UIDevice currentDevice];
	[CurrentDevice beginGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didRotate:)
												 name:@"UIDeviceOrientationDidChangeNotification" object:nil];
	
	currentLevel = [[Level alloc] init:[gameState.currentLevel intValue]];
    
    [self SetupBackground: currentLevel.difficulty];
    [self SetupUI];
    
    [self moveCloudsOne];
	
	[self.view addSubview:backGroundCloudsA];
	[self.view sendSubviewToBack:backGroundCloudsA];
	[self.view addSubview:backGroundCloudsB];
	[self.view sendSubviewToBack:backGroundCloudsB];
	[self.view addSubview:backGroundStars];
	[self.view sendSubviewToBack:backGroundStars];
	[self.view addSubview:powerBack];
	[self.view addSubview:buttonMenu];
	[self.view addSubview:checkLock];
    [self.view addSubview:lockSet];
    [self.view addSubview:closeLock];
	[self.view addSubview:checkRecipe];
    [self.view addSubview:lockFeedBackA];
	[self.view addSubview:lockFeedBackB];
	[self.view addSubview:lockFeedBackC];
    [self.view sendSubviewToBack:buttonMenu];
	[self.view addSubview:backGround];
	[self.view bringSubviewToFront:backGround];
	[self.view addSubview:backGroundTransition];
	[self.view addSubview:backGroundGrid];
	[self.view bringSubviewToFront:backGroundGrid];
	[self.view bringSubviewToFront:powerBack];
    
	menuView.center = CGPointMake(160,240);
	statsView.center = CGPointMake(160,240);
	statsView.hidden = TRUE;
	recipeLabel.hidden = TRUE;
	
	itemCollection = [[ItemCollection alloc] init:NUMBER_OF_ROWS :NUMBER_OF_COLUMNS :SHAPE_WIDTH :SHAPE_WIDTH: currentLevel];
	
    SpawnedPair = [ItemPair new];
    
	nextPair = [ItemPair new];
	
	nextPair.ItemA = [[Shape alloc] initWithInfo:[currentLevel createRandomColor]: [currentLevel createShapeFromCollection] : CGPointMake(20,20)];
	nextPair.ItemB = [[Shape alloc] initWithInfo:[currentLevel createRandomColor]: [currentLevel createShapeFromCollection] : CGPointMake(20,20)];
	
	if([gameState.currentBoard.Active boolValue]){
		
        NSArray * spawnedItems = [appDelegate FetchSpawnedItems];
        ItemState * itemA = [spawnedItems objectAtIndex:0];
        ItemState * itemB = [spawnedItems objectAtIndex:1];
        
        Shape * spawnA = [[[Shape alloc] initWithInfo:[itemA.colorType intValue] :[itemA.shapeType intValue] : CGPointMake(spawnX,spawnY)]retain];
        Shape * spawnB = [[[Shape alloc] initWithInfo:[itemB.colorType intValue] :[itemB.shapeType intValue] : CGPointMake(spawnX,spawnY)]retain];
		[self SpawnShapes:spawnA : spawnB];
		
		for(ItemState * item in [appDelegate FetchCollectionItemStates]){
			if([item.shapeType intValue] != -1 && [item.colorType intValue] != -1){
				
				Shape * shape = [[[Shape alloc] initWithInfo:[item.colorType intValue] :[item.shapeType intValue] : CGPointMake(spawnX,spawnY)]retain];
				
				Cell * cell = [itemCollection GetCell:[item.Row intValue] : [item.Column intValue]];
				[itemCollection SetItemToCell:shape : cell];
				[self.view addSubview:shape];
			}
		}
		[itemCollection UpdateState];
		
        discardCount = [gameState.currentBoard.discardCount intValue];
        bombCount = [gameState.currentBoard.bombCount intValue];
        reshuffleCount = [gameState.currentBoard.reshuffleCount intValue];
        upgradeCount = [gameState.currentBoard.upgradeCount intValue];
        
		[SpawnedPair Reset];
		
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
	
	[self didRotate:nil];
	
	[itemCollection ApplyGravity];
	[self setButtons];
    [super viewDidLoad];
	
	startTime = CFAbsoluteTimeGetCurrent();
	spawnedShapeRotateTransform = CGAffineTransformIdentity;
	
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

-(void)moveCloudsOne{
	[movingTimer invalidate];
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationDuration:60.0f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animateBoard)];
	backGroundCloudsA.center = CGPointMake(backGroundCloudsA.center.x - 640,backGroundCloudsA.center.y - 160);
	backGroundCloudsB.center = CGPointMake(backGroundCloudsB.center.x + 640,backGroundCloudsB.center.y + 160);
	[UIView commitAnimations];
	movingTimer = [NSTimer scheduledTimerWithTimeInterval: 60.1f target:self selector:@selector(moveCloudsTwo) userInfo:nil repeats: NO];
}

-(void)moveCloudsTwo{
	[movingTimer invalidate];
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationDuration:60.0f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animateBoard)];
	backGroundCloudsA.center = CGPointMake(backGroundCloudsA.center.x + 640,backGroundCloudsA.center.y);
	backGroundCloudsB.center = CGPointMake(backGroundCloudsB.center.x - 640,backGroundCloudsB.center.y);
	[UIView commitAnimations];
	movingTimer = [NSTimer scheduledTimerWithTimeInterval: 60.1f target:self selector:@selector(moveCloudsThree) userInfo:nil repeats: NO];
}

-(void)moveCloudsThree{
	[movingTimer invalidate];
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationDuration:60.0f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animateBoard)];
	backGroundCloudsA.center = CGPointMake(backGroundCloudsA.center.x - 640,backGroundCloudsA.center.y + 160);
	backGroundCloudsB.center = CGPointMake(backGroundCloudsB.center.x + 640,backGroundCloudsB.center.y - 160);
	[UIView commitAnimations];
	movingTimer = [NSTimer scheduledTimerWithTimeInterval: 60.1f target:self selector:@selector(moveCloudsFour) userInfo:nil repeats: NO];
}

-(void)moveCloudsFour{
	[movingTimer invalidate];
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationDuration:60.0f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animateBoard)];
	backGroundCloudsA.center = CGPointMake(backGroundCloudsA.center.x + 640,backGroundCloudsA.center.y);
	backGroundCloudsB.center = CGPointMake(backGroundCloudsB.center.x - 640,backGroundCloudsB.center.y);
	[UIView commitAnimations];
	movingTimer = [NSTimer scheduledTimerWithTimeInterval: 60.1f target:self selector:@selector(moveCloudsOne) userInfo:nil repeats: NO];
}

-(void)didRotate:(NSNotification *)notification{
	
    int degrees = 0;
    
    switch (CurrentDevice.orientation) {
        case UIInterfaceOrientationLandscapeRight:
            spawnX = 235;
			spawnY = 103;
			spawnNextX = 234;
			spawnNextY = 18;
			gravity = left;
            backGroundToLoad = @"rotatedsideright.png";
			checkLock.center = CGPointMake(106,13 - 30);
			buttonMenu.center = CGPointMake(35,24);
			scoreLabel.center = CGPointMake(153,52);
			
			upgradeCountImage.center = CGPointMake(20,155);
			discardCountImage.center = CGPointMake(20,91);
			bombCountImage.center = CGPointMake(80,155);
			reshuffleCountImage.center = CGPointMake(80,91);
			
			upgradeButton.center = CGPointMake(47,120);
			discardButton.center = CGPointMake(47,51);
			bombButton.center = CGPointMake(106,120);
			reshuffleButton.center = CGPointMake(106,51);
			degrees = 90;
			spawnedShapeRotateTransform = CGAffineTransformIdentity;
			spawnedShapeRotateTransform = CGAffineTransformRotate(CGAffineTransformIdentity, rotate_xDegrees(90));
			backGroundGrid.transform = CGAffineTransformMakeScale(-1.0, 1.0);
			backGroundTransition.transform = CGAffineTransformMakeScale(-1.0, 1.0);
			
			backGroundTransition.image = [UIImage imageNamed:@"whitesidegrid.png"];
			
			if (currentLevel.difficulty == 1){
				backGroundGrid.image = [UIImage imageNamed:@"orangesidegrid.png"];
			}
            if (currentLevel.difficulty == 2){
				backGroundGrid.image = [UIImage imageNamed:@"greensidegrid.png"];
			}
			if (currentLevel.difficulty == 3){
				backGroundGrid.image = [UIImage imageNamed:@"violetsidegrid.png"];
			}
			if (currentLevel.difficulty == 4){
				backGroundGrid.image = [UIImage imageNamed:@"cyansidegrid.png"];
			}
			if (currentLevel.difficulty == 5){
				backGroundGrid.image = [UIImage imageNamed:@"purplesidegrid.png"];
			}
			if (currentLevel.difficulty == 6){
				backGroundGrid.image = [UIImage imageNamed:@"bluesidegrid.png"];
			}
			if (currentLevel.difficulty == 7){ 
				backGroundGrid.image = [UIImage imageNamed:@"cyansidegrid.png"];
			}
			if (currentLevel.difficulty == 8){
				backGroundGrid.image = [UIImage imageNamed:@"redsidegrid.png"];
			}
			if (currentLevel.difficulty == 9){
				backGroundGrid.image = [UIImage imageNamed:@"pinksidegrid.png"];
			}
			if (currentLevel.difficulty == 10){
				backGroundGrid.image = [UIImage imageNamed:@"greensidegrid.png"];
			}
			if (currentLevel.difficulty == 11){
				backGroundGrid.image = [UIImage imageNamed:@"greensidegrid.png"];
			}
            break;
        case UIInterfaceOrientationLandscapeLeft:
            spawnX = 53;
			spawnY = 103;
			spawnNextX = 56;
			spawnNextY = 18;
			gravity = right;
			backGroundToLoad = @"rotatedside.png";
			checkLock.center = CGPointMake(210,13 - 30);
			buttonMenu.center = CGPointMake(305,24);
			scoreLabel.center = CGPointMake(153,52);
			
			upgradeCountImage.center = CGPointMake(300,153);
			discardCountImage.center = CGPointMake(300,87);
			bombCountImage.center = CGPointMake(241,153);
			reshuffleCountImage.center = CGPointMake(241,87);
			
			upgradeButton.center = CGPointMake(272,120);
			discardButton.center = CGPointMake(273,51);
			bombButton.center = CGPointMake(213,120);
			reshuffleButton.center = CGPointMake(213,51);
            
			spawnedShapeRotateTransform = CGAffineTransformIdentity;
			spawnedShapeRotateTransform = CGAffineTransformRotate(CGAffineTransformIdentity, rotate_xDegrees(270));
			backGroundGrid.transform = CGAffineTransformIdentity;
			backGroundTransition.transform = CGAffineTransformIdentity;
			
			backGroundTransition.image = [UIImage imageNamed:@"whitesidegrid.png"];
			
			if (currentLevel.difficulty == 1){
				backGroundGrid.image = [UIImage imageNamed:@"orangesidegrid.png"];
			}
            if (currentLevel.difficulty == 2){
				backGroundGrid.image = [UIImage imageNamed:@"greensidegrid.png"];
			}
			if (currentLevel.difficulty == 3){
				backGroundGrid.image = [UIImage imageNamed:@"violetsidegrid.png"];
			}
			if (currentLevel.difficulty == 4){
				backGroundGrid.image = [UIImage imageNamed:@"cyansidegrid.png"];
			}
			if (currentLevel.difficulty == 5){
				backGroundGrid.image = [UIImage imageNamed:@"purplesidegrid.png"];
			}
			if (currentLevel.difficulty == 6){
				backGroundGrid.image = [UIImage imageNamed:@"bluesidegrid.png"];
			}
			if (currentLevel.difficulty == 7){ 
				backGroundGrid.image = [UIImage imageNamed:@"cyansidegrid.png"];
			}
			if (currentLevel.difficulty == 8){
				backGroundGrid.image = [UIImage imageNamed:@"redsidegrid.png"];
			}
			if (currentLevel.difficulty == 9){
				backGroundGrid.image = [UIImage imageNamed:@"pinksidegrid.png"];
			}
			if (currentLevel.difficulty == 10){
				backGroundGrid.image = [UIImage imageNamed:@"greensidegrid.png"];
			}
			if (currentLevel.difficulty == 11){
				backGroundGrid.image = [UIImage imageNamed:@"greensidegrid.png"];
			}
            break;
        case UIInterfaceOrientationPortrait:
            spawnX = SPAWN_LOCATION_X;
			spawnY = SPAWN_LOCATION_Y;
			spawnNextX = SPAWN_LOCATION_X;
			spawnNextY = SPAWN_LOCATION_Y - 78;
			gravity = down;
            backGroundToLoad = @"gameBoardGrid.png";
			upgradeCountImage.center = CGPointMake(26,76);
			discardCountImage.center = CGPointMake(293,76);
			bombCountImage.center = CGPointMake(76,76);
			reshuffleCountImage.center = CGPointMake(244,76);
			upgradeButton.center = CGPointMake(26,116);
			discardButton.center = CGPointMake(293,116);
			bombButton.center = CGPointMake(76,116);
			reshuffleButton.center = CGPointMake(244,116);
			buttonMenu.center = CGPointMake(305,24);
			checkLock.center = CGPointMake(252, 25 - 20);
			scoreLabel.center = CGPointMake(64,31);
            degrees = 0;
			spawnedShapeRotateTransform = CGAffineTransformIdentity;
			spawnedShapeRotateTransform = CGAffineTransformRotate(CGAffineTransformIdentity, rotate_xDegrees(0));
            backGroundGrid.transform = CGAffineTransformIdentity;
			backGroundTransition.transform = CGAffineTransformIdentity;
			backGroundTransition.image = [UIImage imageNamed:@"whitegrid.png"];
			
			if (currentLevel.difficulty == 1){
				backGroundGrid.image = [UIImage imageNamed:@"OrangeGrid.png"];
			}
            if (currentLevel.difficulty == 2){
				backGroundGrid.image = [UIImage imageNamed:@"greengrid.png"];
			}
			if (currentLevel.difficulty == 3){
				backGroundGrid.image = [UIImage imageNamed:@"violetgrid.png"];
			}
			if (currentLevel.difficulty == 4){
				backGroundGrid.image = [UIImage imageNamed:@"cyangrid.png"];
			}
			if (currentLevel.difficulty == 5){
				backGroundGrid.image = [UIImage imageNamed:@"purplegrid.png"];
			}
			if (currentLevel.difficulty == 6){
				backGroundGrid.image = [UIImage imageNamed:@"bluegrid.png"];
			}
			if (currentLevel.difficulty == 7){
				backGroundGrid.image = [UIImage imageNamed:@"cyangrid.png"];
			}
			if (currentLevel.difficulty == 8){
				backGroundGrid.image = [UIImage imageNamed:@"redgrid.png"];
			}
			if (currentLevel.difficulty == 9){
				backGroundGrid.image = [UIImage imageNamed:@"pinkgrid.png"];
			}
			if (currentLevel.difficulty == 10){
				backGroundGrid.image = [UIImage imageNamed:@"greengrid.png"];
			}
			if (currentLevel.difficulty == 11){
				backGroundGrid.image = [UIImage imageNamed:@"greengrid.png"];
			}
			break;
        case UIInterfaceOrientationPortraitUpsideDown:
			spawnX = SPAWN_LOCATION_X;
			spawnY = SPAWN_LOCATION_Y;
			spawnNextX = SPAWN_LOCATION_X;
			spawnNextY = SPAWN_LOCATION_Y - 78;
			gravity = up;
            backGroundToLoad = @"upsideDownBack.png";
			checkLock.center = CGPointMake(252, 25 - 20);
			scoreLabel.center = CGPointMake(64,31);
			buttonMenu.center = CGPointMake(305,24);
			upgradeCountImage.center = CGPointMake(26,76);
			discardCountImage.center = CGPointMake(293,76);
			bombCountImage.center = CGPointMake(76,76);
			reshuffleCountImage.center = CGPointMake(244,76);
			upgradeButton.center = CGPointMake(26,116);
			discardButton.center = CGPointMake(293,116);
			bombButton.center = CGPointMake(76,116);
			reshuffleButton.center = CGPointMake(244,116);
            degrees = 180;
			spawnedShapeRotateTransform = CGAffineTransformIdentity;
			spawnedShapeRotateTransform = CGAffineTransformRotate(CGAffineTransformIdentity, rotate_xDegrees(180));
            backGroundGrid.transform = CGAffineTransformIdentity;
			backGroundTransition.transform = CGAffineTransformIdentity;
			backGroundTransition.image = [UIImage imageNamed:@"whitegrid.png"];
			
			if (currentLevel.difficulty == 1){
				backGroundGrid.image = [UIImage imageNamed:@"OrangeGrid.png"];
			}
            if (currentLevel.difficulty == 2){
				backGroundGrid.image = [UIImage imageNamed:@"greengrid.png"];
			}
			if (currentLevel.difficulty == 3){
				backGroundGrid.image = [UIImage imageNamed:@"violetgrid.png"];
			}
			if (currentLevel.difficulty == 4){
				backGroundGrid.image = [UIImage imageNamed:@"cyangrid.png"];
			}
			if (currentLevel.difficulty == 5){
				backGroundGrid.image = [UIImage imageNamed:@"purplegrid.png"];
			}
			if (currentLevel.difficulty == 6){
				backGroundGrid.image = [UIImage imageNamed:@"bluegrid.png"];
			}
			if (currentLevel.difficulty == 7){
				backGroundGrid.image = [UIImage imageNamed:@"cyangrid.png"];
			}
			if (currentLevel.difficulty == 8){
				backGroundGrid.image = [UIImage imageNamed:@"redgrid.png"];
			}
			if (currentLevel.difficulty == 9){
				backGroundGrid.image = [UIImage imageNamed:@"pinkgrid.png"];
			}
			if (currentLevel.difficulty == 10){
				backGroundGrid.image = [UIImage imageNamed:@"greengrid.png"];
			}
			if (currentLevel.difficulty == 11){
				backGroundGrid.image = [UIImage imageNamed:@"greengrid.png"];
			}
			break;            
        default:
			backGroundToLoad = @"gameBoardGrid.png";
            upgradeCountImage.transform = spawnedShapeRotateTransform;
            discardCountImage.transform = spawnedShapeRotateTransform;
            bombCountImage.transform = spawnedShapeRotateTransform;
            reshuffleCountImage.transform = spawnedShapeRotateTransform;
            scoreLabel.transform = spawnedShapeRotateTransform;
            menuView.transform = spawnedShapeRotateTransform;
            SpawnedPair.ItemA.transform = spawnedShapeRotateTransform;
            SpawnedPair.ItemB.transform = spawnedShapeRotateTransform;
            SpawnedPair.ShaddowA.transform = spawnedShapeRotateTransform;
            SpawnedPair.ShaddowB.transform = spawnedShapeRotateTransform;
            nextPair.ItemA.transform = spawnedShapeRotateTransform;
            nextPair.ItemB.transform = spawnedShapeRotateTransform;
			statsView.transform = spawnedShapeRotateTransform;
			backGroundGrid.transform = CGAffineTransformIdentity;
            backGroundTransition.transform = CGAffineTransformIdentity;
			if (currentLevel.difficulty == 1){
				backGroundGrid.image = [UIImage imageNamed:@"OrangeGrid.png"];
			}
            if (currentLevel.difficulty == 2){
				backGroundGrid.image = [UIImage imageNamed:@"greengrid.png"];
			}
			if (currentLevel.difficulty == 3){
				backGroundGrid.image = [UIImage imageNamed:@"violetgrid.png"];
			}
			if (currentLevel.difficulty == 4){
				backGroundGrid.image = [UIImage imageNamed:@"cyangrid.png"];
			}
			if (currentLevel.difficulty == 5){
				backGroundGrid.image = [UIImage imageNamed:@"purplegrid.png"];
			}
			if (currentLevel.difficulty == 6){
				backGroundGrid.image = [UIImage imageNamed:@"bluegrid.png"];
			}
			if (currentLevel.difficulty == 7){
				backGroundGrid.image = [UIImage imageNamed:@"cyangrid.png"];
			}
			if (currentLevel.difficulty == 8){
				backGroundGrid.image = [UIImage imageNamed:@"redgrid.png"];
			}
			if (currentLevel.difficulty == 9){
				backGroundGrid.image = [UIImage imageNamed:@"pinkgrid.png"];
			}
			if (currentLevel.difficulty == 10){
				backGroundGrid.image = [UIImage imageNamed:@"greengrid.png"];
			}
			if (currentLevel.difficulty == 11){
				backGroundGrid.image = [UIImage imageNamed:@"greengrid.png"];
			}
			break;
    }
    SpawnedPair.ItemA.center = CGPointMake(spawnX,spawnY);
    SpawnedPair.ItemB.center = CGPointMake(spawnX + 30,spawnY);
    SpawnedPair.ItemC.center = CGPointMake(spawnX + 15,spawnY);
    
    nextPair.ItemA.center = CGPointMake(spawnNextX,spawnNextY);
    nextPair.ItemB.center = CGPointMake(spawnNextX + 30,spawnNextY + 0);
    
    [itemCollection SetGravity:gravity];
	
    //[backGround.image release];
    
    backGround.image = [UIImage imageNamed:backGroundToLoad];
	
    [backGroundToLoad release];
    [self.view addSubview:backGround];
    //[self.view sendSubviewToBack:backGround];
    [self.view sendSubviewToBack:backGroundCloudsA];
    [self.view sendSubviewToBack:backGroundCloudsB];
    [self.view sendSubviewToBack:backGroundStars];
    [self.view sendSubviewToBack:buttonMenu];
    
    spawnedShapeRotateTransform = spawnedShapeRotateTransform;
    upgradeCountImage.transform = spawnedShapeRotateTransform;
    discardCountImage.transform = spawnedShapeRotateTransform;
    bombCountImage.transform = spawnedShapeRotateTransform;
    reshuffleCountImage.transform = spawnedShapeRotateTransform;
    scoreLabel.transform = spawnedShapeRotateTransform;
    menuView.transform = spawnedShapeRotateTransform;
    SpawnedPair.ItemA.transform = spawnedShapeRotateTransform;
    SpawnedPair.ItemB.transform = spawnedShapeRotateTransform;
    SpawnedPair.ShaddowA.transform = spawnedShapeRotateTransform;
    SpawnedPair.ShaddowB.transform = spawnedShapeRotateTransform;
    nextPair.ItemA.transform = spawnedShapeRotateTransform;
    nextPair.ItemB.transform = spawnedShapeRotateTransform;
	statsView.transform = spawnedShapeRotateTransform;
}

/*****************************************************
 Helpers
 *****************************************************/
-(void) SetupBackground :(int) difficulty{
	
	backGroundTransition = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	backGroundTransition.image = [UIImage imageNamed:@"whitegrid.png"];
	backGroundTransition.alpha = 0;
	
	backGroundGrid = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	backGroundGrid.image = [UIImage imageNamed:@"orangegrid.png"];
	
    if(backGround != nil){
        [backGround removeFromSuperview];
        [backGround release];
    }
    backGround = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    backGround.image = [UIImage imageNamed:@"gameBoardGrid.png"];
    self.view.backgroundColor = [UIColor blackColor];
    
    if(backGroundStars != nil){
        [backGroundStars removeFromSuperview];
        [backGroundStars release];
    }
    backGroundStars = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 960, 640)];
    backGroundStars.clipsToBounds = YES;
    backGroundStars.autoresizesSubviews = NO;
    backGroundStars.contentMode = UIViewContentModeTopLeft;
    backGroundStars.image = [UIImage imageNamed:@"BigBackground.png"];
    backGroundStars.userInteractionEnabled = FALSE;
    
	if(backGroundCloudsA != nil){
        [backGroundCloudsA removeFromSuperview];
        [backGroundCloudsA release];
    }
    backGroundCloudsA = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 960, 640)];
    backGroundCloudsA.clipsToBounds = YES;
    backGroundCloudsA.autoresizesSubviews = NO;
    backGroundCloudsA.contentMode = UIViewContentModeTopLeft;
    backGroundCloudsA.image = [UIImage imageNamed:@"magentaClouds.png"];
    backGroundCloudsA.userInteractionEnabled = FALSE;
	
    if(backGroundCloudsB != nil){
        [backGroundCloudsB removeFromSuperview];
        [backGroundCloudsB release];
    }
    backGroundCloudsB = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 960, 640)];
    backGroundCloudsB.clipsToBounds = YES;
    backGroundCloudsB.autoresizesSubviews = NO;
    backGroundCloudsB.image = [UIImage imageNamed:@"orangeClouds.png"];
    backGroundCloudsB.userInteractionEnabled = FALSE;
    backGroundCloudsB.center = CGPointMake(backGroundCloudsB.center.x - 640,backGroundCloudsB.center.y - 160);
	
    switch (difficulty) {
        case 1:
            backGroundCloudsA.image = [UIImage imageNamed:@"magentaClouds.png"];
            backGroundCloudsB.image = [UIImage imageNamed:@"orangeClouds.png"];
            break;
        case 2:
			backGroundCloudsA.image = [UIImage imageNamed:@"redClouds.png"];
			backGroundCloudsB.image = [UIImage imageNamed:@"blueClouds.png"];
            break;
        case 3:
			backGroundCloudsA.image = [UIImage imageNamed:@"cyanClouds.png"];
			backGroundCloudsB.image = [UIImage imageNamed:@"yellowClouds.png"];
            break;
        case 4:
			backGroundCloudsA.image = [UIImage imageNamed:@"greenClouds.png"];
			backGroundCloudsB.image = [UIImage imageNamed:@"violetClouds.png"];
            break;
        case 5:
			backGroundCloudsA.image = [UIImage imageNamed:@"cyanBlueClouds.png"];
			backGroundCloudsB.image = [UIImage imageNamed:@"orangeClouds.png"];
            break;
        case 6:
			backGroundCloudsA.image = [UIImage imageNamed:@"yellowClouds.png"];
			backGroundCloudsB.image = [UIImage imageNamed:@"magentaClouds.png"];
            break;
        case 7:
			backGroundCloudsA.image = [UIImage imageNamed:@"redClouds.png"];
			backGroundCloudsB.image = [UIImage imageNamed:@"greenClouds.png"];
            break;
        case 8:
			backGroundCloudsA.image = [UIImage imageNamed:@"blueClouds.png"];
			backGroundCloudsB.image = [UIImage imageNamed:@"violetClouds.png"];
            break;
        case 9:
			backGroundCloudsA.image = [UIImage imageNamed:@"cyanBlueClouds.png"];
			backGroundCloudsB.image = [UIImage imageNamed:@"greenClouds.png"];
            break;
        case 10:
			backGroundCloudsA.image = [UIImage imageNamed:@"cyanClouds.png"];
			backGroundCloudsB.image = [UIImage imageNamed:@"yellowClouds.png"];
            break;
        default:
            break;
    }
}

-(void) SetupUI{
    powerBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    powerBack.center = CGPointMake(spawnX + 15,spawnY);
    powerBack.userInteractionEnabled = FALSE;
	
    lockSet = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lockTab.png"]];
    lockSet.center = CGPointMake(lockSet.center.x, lockSet.center.y - 180);
    closeLock.center = CGPointMake(closeLock.center.x, closeLock.center.y - 180);
    checkRecipe.center = CGPointMake(checkRecipe.center.x, checkRecipe.center.y - 180);
    checkLock.center = CGPointMake(252, 25);
	
	recipeLabel.center = CGPointMake(160, 155);
	recipeLabel.backgroundColor = [UIColor clearColor];
	recipeLabel.textColor = [UIColor yellowColor];
	
    lockFeedBackA = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    lockFeedBackA.image = [UIImage imageNamed:@"lockFeedBack.png"];
    lockFeedBackA.center = CGPointMake(lockSet.center.x, lockSet.center.y);
	
    lockFeedBackB = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    lockFeedBackB.image = [UIImage imageNamed:@"lockFeedBack.png"];
    lockFeedBackB.center = CGPointMake(lockSet.center.x + 100, lockSet.center.y);
	
    lockFeedBackC = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    lockFeedBackC.image = [UIImage imageNamed:@"lockFeedBack.png"];
    lockFeedBackC.center = CGPointMake(lockSet.center.x - 100, lockSet.center.y);
	
    guessView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lockFeedBack.png"]];
    
	scoreLabel.text = [NSString stringWithFormat:@"%d" , score];
	scoreLabel.center = CGPointMake(64,31);
	
	buttonMenu.center = CGPointMake(305,24);
	buttonMenu.backgroundColor = [UIColor clearColor];
	
	upgradeButton.frame = CGRectMake(0, 0, 40, 40);
	discardButton.frame = CGRectMake(0, 0, 40, 40);
	bombButton.frame = CGRectMake(0, 0, 40, 40);
	reshuffleButton.frame = CGRectMake(0, 0, 40, 40);
	
	upgradeCountImage.center = CGPointMake(26,76);
	discardCountImage.center = CGPointMake(293,76);
	bombCountImage.center = CGPointMake(76,76);
	reshuffleCountImage.center = CGPointMake(244,76);
	
	upgradeButton.center = CGPointMake(26,116);
	discardButton.center = CGPointMake(294,116);
	bombButton.center = CGPointMake(76,116);
	reshuffleButton.center = CGPointMake(245,116);
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
	statsView.hidden = TRUE;
	recipeLabel.hidden = TRUE;
	scorePopUp.hidden = TRUE;
	scorePopUp.bounds = CGRectMake(0, 0, 30, 30);
	scorePopUp.alpha = 1;
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
				SpawnedPair.ItemA.hidden = FALSE;
				SpawnedPair.ItemB.hidden = FALSE;
				SpawnedPair.ItemC.hidden = FALSE;
				powerBack.image = nil;
				[self setButtons];
                
            }
            if(appDelegate.isFiltering == YES){
                appDelegate.isFiltering = NO;
                [powerItem makeFilter:(Shape *)[touch view]];
				SpawnedPair.ItemA.hidden = FALSE;
				SpawnedPair.ItemB.hidden = FALSE;
				SpawnedPair.ItemC.hidden = FALSE;
				powerBack.image = nil;
				[self setButtons];
                
            }
            if(appDelegate.isUpgrading == YES){
                Cell * cell = [itemCollection GetCell:touchedItem.Row :touchedItem.Column];
				[itemCollection TransformItem:cell.ItemInCell];
				appDelegate.isUpgrading = NO;
				SpawnedPair.ItemA.hidden = FALSE;
				SpawnedPair.ItemB.hidden = FALSE;
				SpawnedPair.ItemC.hidden = FALSE;
				powerBack.image = nil;
				[self setButtons];
            }
        }
    }
    
    else {
        if([[touch view] isKindOfClass: [Shape class]]){
            touchedGuessItem = (GameItem *)[touch view];
			touchedGuessItemShape = (Shape *)touchedGuessItem;
            
			guessView.image = touchedGuessItem.ItemView.image;
			guessView.center = CGPointMake([touch locationInView:self.view].x - 25, [touch locationInView:self.view].y - 25);
			[self.view addSubview:guessView];
			appDelegate.isMoving = TRUE;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if([[touch view] isMemberOfClass:[DrawingView class]] && lockMode == FALSE
	   && appDelegate.isBombing == NO && menuView.hidden == TRUE){
		[SpawnedPair airMove:[touch locationInView:[self view]]];
		SpawnedPair.ItemC.alpha = 1;
		[itemCollection DrawShadowForItemPair:SpawnedPair];
    }
    if (lockMode == TRUE && appDelegate.isMoving == TRUE){
        GameItem * touchedGuessItem;
        touchedGuessItem = (GameItem *)[touch view];
        guessView.center = CGPointMake([touch locationInView:self.view].x - 55, [touch locationInView:self.view].y - 55);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
    Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
	SpawnedPair.ItemC.alpha = 0.25f;
	/* Shape was touched */
    if (lockMode == FALSE){
        if([SpawnedPair IsInGrid] && [touch view] != backGround){
            if([itemCollection AddItemPair:SpawnedPair]){
                [SpawnedPair.ItemC release];
                [SpawnedPair.ItemC removeFromSuperview];
                SpawnedPair.ItemC = nil;
                [self SpawnShapes];
				[self checkLevel];
                return;
			}else{
				[self ResetShapePair:SpawnedPair];
				return;
			}
		}
		if([[touch view] isKindOfClass: [GameItem class]]){
			GameItem * item = (GameItem *)[touch view];
			Shape * itemShape = (Shape *)[touch view];
			if(SpawnedPair.ItemA.IsPaired && [self isTouchWithinRange: startTouchPosition from: SpawnedPair.ItemC.center] < 50.0f && [[touch view] isKindOfClass: [GameItem class]]){
                if (item.tapped == 1){
                    item.tapped = 0;
                    [SpawnedPair rotate:SpawnedPair.ItemA];
                    SpawnedPair.ItemC.center = [drawingView makeCirclePoint:SpawnedPair.ItemA.center :SpawnedPair.ItemB.center];
                    return;
                }
            }else{
                if(item.tapped > 0 && menuView.hidden == TRUE){
                    item.tapped = 0;
                    if([itemCollection TransformItem:item]){
                        [self changeScore:itemShape];
						scorePopUp.center = [touch locationInView:self.view];
						scorePopUp.hidden = FALSE;
						[self.view addSubview:scorePopUp];
						[self.view bringSubviewToFront:scorePopUp];
                    }
					
					[UIView beginAnimations:nil context:nil]; 
					[UIView setAnimationDuration:2.5f];
					[UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
					[UIView setAnimationTransition:110 forView: backGroundGrid cache:YES];
					[UIView commitAnimations];
					/*
					[UIView beginAnimations:nil context:nil]; 
					[UIView setAnimationDuration:2.0f];
					[UIView setAnimationTransition:110 forView: scorePopUp cache:YES];
					[UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
					scorePopUp.bounds = CGRectMake(0, 0, 100, 100);
					scorePopUp.center = CGPointMake(160, 240);
					scorePopUp.alpha = 0;
					
					[UIView commitAnimations];
					 */
                }
            }
        }
    }
    if (lockMode == TRUE) {
		if(guessView.center.x < 105 - 55 && guessView.center.y < 133 && guessView.image != nil){
			cellB.ItemInCell.userInteractionEnabled = TRUE;
			cellB.ItemInCell.alpha = 1;
			shapeB = touchedGuessItemShape;
			cellB = [itemCollection GetCell:shapeB.Row :shapeB.Column];
			cellB.ItemInCell.userInteractionEnabled = FALSE;
			cellB.ItemInCell.alpha = 0.3f;
			lockFeedBackC.image = guessView.image;
			guessView.image = nil;
		}
		if(guessView.center.x > 108 - 55 && guessView.center.x < 210 - 55 && guessView.center.y < 133 && guessView.image != nil){
			cellA.ItemInCell.userInteractionEnabled = TRUE;
			cellA.ItemInCell.alpha = 1;
			shapeA = touchedGuessItemShape;
			cellA = [itemCollection GetCell:shapeA.Row :shapeA.Column];
			cellA.ItemInCell.userInteractionEnabled = FALSE;
			cellA.ItemInCell.alpha = 0.3f;
			lockFeedBackA.image = guessView.image;
			guessView.image = nil;
		}
		if(guessView.center.x > 211 - 55 && guessView.center.y < 133 && guessView.image != nil){
			cellC.ItemInCell.userInteractionEnabled = TRUE;
			cellC.ItemInCell.alpha = 1;
			shapeC = touchedGuessItemShape;
			cellC = [itemCollection GetCell:shapeC.Row :shapeC.Column];
			cellC.ItemInCell.userInteractionEnabled = FALSE;
			cellC.ItemInCell.alpha = 0.3f;
			lockFeedBackB.image = guessView.image;
			guessView.image = nil;
		}
		appDelegate.isMoving = FALSE;
        [guessView removeFromSuperview];
    }
	[NSTimer release];
	
}

-(void)changeScore:(Shape *) itemShape {
	
	if(itemShape.shapeType == Square){
		score = score + 50 + (50 * (itemCollection.multiplier * .10));
		int multiplier = 50 + (50 * (itemCollection.multiplier * .10));
		scoreLabel.text = [NSString stringWithFormat:@"%d" , score];
		scorePopUp.text = [NSString stringWithFormat:@"+%d" , multiplier];
		[self checkLevel];
		return;
	}
	if(itemShape.shapeType == Pentagon){
		score = score + 250 + (250 * (itemCollection.multiplier * .10));
		int multiplier = 250 + (250 * (itemCollection.multiplier * .10));
		scoreLabel.text = [NSString stringWithFormat:@"%d" , score];
		scorePopUp.text = [NSString stringWithFormat:@"+%d" , multiplier];
		[self checkLevel];
		return;
	}
	if(itemShape.shapeType == Hexagon){
		score = score + 1500 + (1500 * (itemCollection.multiplier * .10));
		int multiplier = 1500 + (1500 * (itemCollection.multiplier * .10));
		scoreLabel.text = [NSString stringWithFormat:@"%d" , score];
		scorePopUp.text = [NSString stringWithFormat:@"+%d" , multiplier];
		[self checkLevel];
		return;
	}
	if(itemShape.shapeType == Circle){
		score = score + 7000 + (7000 * (itemCollection.multiplier * .10));
		int multiplier = 7000 + (7000 * (itemCollection.multiplier * .10));
		scoreLabel.text = [NSString stringWithFormat:@"%d" , score];
		scorePopUp.text = [NSString stringWithFormat:@"+%d" , multiplier];
		[self checkLevel];
		return;
	}
	if(itemShape.shapeType == Vortex){
		score = score + 40000 + (40000 * (itemCollection.multiplier * .10));
		int multiplier = 40000 + (40000 * (itemCollection.multiplier * .10));
		scoreLabel.text = [NSString stringWithFormat:@"%d" , score];
		scorePopUp.text = [NSString stringWithFormat:@"+%d" , multiplier];
		[self checkLevel];
		return;
	}
	return;
}   

-(void)checkLevel{
	if ([itemCollection checkPiece:currentLevel.difficulty] == TRUE){
		[UIView beginAnimations:nil context:nil]; 
		[UIView setAnimationDuration:2.0f];
		[UIView setAnimationDelegate:self];
		
		[self changeLevel];
		
		backGroundCloudsA.alpha = 0;
		backGroundCloudsB.alpha = 0;
		backGroundGrid.alpha = 0;
		backGroundTransition.alpha = 1;
		
		[UIView commitAnimations];
		
		[NSTimer scheduledTimerWithTimeInterval:2.1f target:self selector:@selector(animateLevelChange) userInfo:nil repeats:NO];
	}
	
}
-(void)changeLevel{
	//[audio playVictory];
	[currentLevel setDifficulty:currentLevel.difficulty + 1];
	Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
	if([gameState.currentLevel intValue] == [gameState.highestLevel intValue] && [gameState.highestLevel intValue] < 10){
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
    LevelStatistics * stat = [appDelegate CreatePlayedLevel];
	stat.Level = [NSNumber numberWithInt:[gameState.currentLevel intValue]];
	stat.numberOfMoves = gameState.currentBoard.numberOfMovies;
	stat.numberOfTransforms = gameState.currentBoard.numberOfTransforms;
	stat.numerOfAttempts = gameState.currentBoard.numberOfAttempts;
	stat.timeToComplete = gameState.currentBoard.timePlayed;
	gameState.currentLevel = [NSNumber numberWithInt:currentLevel.difficulty]; 
	[gameState addPlayedLevelsObject:stat];
    
	[self SaveState];
	
	currentLevelLabel.text = [NSString stringWithFormat:@"%@" , gameState.currentLevel ];
	movesLabel.text = [NSString stringWithFormat:@"%@" , gameState.currentBoard.numberOfMovies ];
	transformsLabel.text = [NSString stringWithFormat:@"%@" , gameState.currentBoard.numberOfTransforms];
	//timeLabel.text = [NSString stringWithFormat:@"%@" , gameState.currentBoard.timePlayed ];
	[self.view bringSubviewToFront:statsView];
	statsView.hidden = FALSE;
	[NSTimer scheduledTimerWithTimeInterval:5.1f target:self selector:@selector(removeStats) userInfo:nil repeats:NO];
}

-(void)animateLevelChange{
	[backGroundCloudsA.image release];
	[backGroundCloudsB.image release];
	
	switch (CurrentDevice.orientation) {
        case UIInterfaceOrientationLandscapeRight:
            if (currentLevel.difficulty == 1){
				backGroundCloudsA.image = [UIImage imageNamed:@"redClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"blueClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"orangesidegrid.png"];
			}
            if (currentLevel.difficulty == 2){
				backGroundCloudsA.image = [UIImage imageNamed:@"redClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"blueClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"greensidegrid.png"];
			}
			if (currentLevel.difficulty == 3){
				backGroundCloudsA.image = [UIImage imageNamed:@"cyanClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"yellowClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"violetsidegrid.png"];
			}
			if (currentLevel.difficulty == 4){
				backGroundCloudsA.image = [UIImage imageNamed:@"greenClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"violetClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"cyansidegrid.png"];
			}
			if (currentLevel.difficulty == 5){
				backGroundCloudsA.image = [UIImage imageNamed:@"cyanBlueClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"orangeClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"purplesidegrid.png"];
			}
			if (currentLevel.difficulty == 6){
				backGroundCloudsA.image = [UIImage imageNamed:@"yellowClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"magentaClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"bluesidegrid.png"];
			}
			if (currentLevel.difficulty == 7){
				backGroundCloudsA.image = [UIImage imageNamed:@"redClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"greenClouds.png"];    
				backGroundGrid.image = [UIImage imageNamed:@"cyansidegrid.png"];
			}
			if (currentLevel.difficulty == 8){
				backGroundCloudsA.image = [UIImage imageNamed:@"blueClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"violetClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"redsidegrid.png"];
			}
			if (currentLevel.difficulty == 9){
				backGroundCloudsA.image = [UIImage imageNamed:@"cyanBlueClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"greenClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"pinksidegrid.png"];
			}
			if (currentLevel.difficulty == 10){
				backGroundCloudsA.image = [UIImage imageNamed:@"cyanClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"yellowClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"greensidegrid.png"];
			}
			if (currentLevel.difficulty == 11){
				backGroundCloudsA.image = [UIImage imageNamed:@"magentaClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"orangeClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"greensidegrid.png"];
			}
			break;
        case UIInterfaceOrientationLandscapeLeft:
			backGroundTransition.transform = CGAffineTransformIdentity;
			if (currentLevel.difficulty == 1){
				backGroundCloudsA.image = [UIImage imageNamed:@"redClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"blueClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"orangesidegrid.png"];
			}
            if (currentLevel.difficulty == 2){
				backGroundCloudsA.image = [UIImage imageNamed:@"redClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"blueClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"greensidegrid.png"];
			}
			if (currentLevel.difficulty == 3){
				backGroundCloudsA.image = [UIImage imageNamed:@"cyanClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"yellowClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"violetsidegrid.png"];
			}
			if (currentLevel.difficulty == 4){
				backGroundCloudsA.image = [UIImage imageNamed:@"greenClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"violetClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"cyansidegrid.png"];
			}
			if (currentLevel.difficulty == 5){
				backGroundCloudsA.image = [UIImage imageNamed:@"cyanBlueClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"orangeClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"purplesidegrid.png"];
			}
			if (currentLevel.difficulty == 6){
				backGroundCloudsA.image = [UIImage imageNamed:@"yellowClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"magentaClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"bluesidegrid.png"];
			}
			if (currentLevel.difficulty == 7){
				backGroundCloudsA.image = [UIImage imageNamed:@"redClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"greenClouds.png"];    
				backGroundGrid.image = [UIImage imageNamed:@"cyansidegrid.png"];
			}
			if (currentLevel.difficulty == 8){
				backGroundCloudsA.image = [UIImage imageNamed:@"blueClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"violetClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"redsidegrid.png"];
			}
			if (currentLevel.difficulty == 9){
				backGroundCloudsA.image = [UIImage imageNamed:@"cyanBlueClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"greenClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"pinksidegrid.png"];
			}
			if (currentLevel.difficulty == 10){
				backGroundCloudsA.image = [UIImage imageNamed:@"cyanClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"yellowClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"greensidegrid.png"];
			}
			if (currentLevel.difficulty == 11){
				backGroundCloudsA.image = [UIImage imageNamed:@"magentaClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"orangeClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"greensidegrid.png"];
			}
			break; 
        case UIInterfaceOrientationPortrait:
			backGroundTransition.transform = CGAffineTransformIdentity;
			if (currentLevel.difficulty == 1){
				backGroundCloudsA.image = [UIImage imageNamed:@"redClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"blueClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"orangegrid.png"];
			}
            if (currentLevel.difficulty == 2){
				backGroundCloudsA.image = [UIImage imageNamed:@"redClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"blueClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"greengrid.png"];
			}
			if (currentLevel.difficulty == 3){
				backGroundCloudsA.image = [UIImage imageNamed:@"cyanClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"yellowClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"violetgrid.png"];
			}
			if (currentLevel.difficulty == 4){
				backGroundCloudsA.image = [UIImage imageNamed:@"greenClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"violetClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"cyangrid.png"];
			}
			if (currentLevel.difficulty == 5){
				backGroundCloudsA.image = [UIImage imageNamed:@"cyanBlueClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"orangeClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"purplegrid.png"];
			}
			if (currentLevel.difficulty == 6){
				backGroundCloudsA.image = [UIImage imageNamed:@"yellowClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"magentaClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"bluegrid.png"];
			}
			if (currentLevel.difficulty == 7){
				backGroundCloudsA.image = [UIImage imageNamed:@"redClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"greenClouds.png"];    
				backGroundGrid.image = [UIImage imageNamed:@"cyangrid.png"];
			}
			if (currentLevel.difficulty == 8){
				backGroundCloudsA.image = [UIImage imageNamed:@"blueClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"violetClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"redgrid.png"];
			}
			if (currentLevel.difficulty == 9){
				backGroundCloudsA.image = [UIImage imageNamed:@"cyanBlueClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"greenClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"pinkgrid.png"];
			}
			if (currentLevel.difficulty == 10){
				backGroundCloudsA.image = [UIImage imageNamed:@"cyanClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"yellowClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"greengrid.png"];
			}
			if (currentLevel.difficulty == 11){
				backGroundCloudsA.image = [UIImage imageNamed:@"magentaClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"orangeClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"greengrid.png"];
			}
			break; 
        case UIInterfaceOrientationPortraitUpsideDown:
			backGroundTransition.transform = CGAffineTransformIdentity;
			if (currentLevel.difficulty == 1){
				backGroundCloudsA.image = [UIImage imageNamed:@"redClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"blueClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"orangegrid.png"];
			}
            if (currentLevel.difficulty == 2){
				backGroundCloudsA.image = [UIImage imageNamed:@"redClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"blueClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"greengrid.png"];
			}
			if (currentLevel.difficulty == 3){
				backGroundCloudsA.image = [UIImage imageNamed:@"cyanClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"yellowClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"violetgrid.png"];
			}
			if (currentLevel.difficulty == 4){
				backGroundCloudsA.image = [UIImage imageNamed:@"greenClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"violetClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"cyangrid.png"];
			}
			if (currentLevel.difficulty == 5){
				backGroundCloudsA.image = [UIImage imageNamed:@"cyanBlueClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"orangeClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"purplegrid.png"];
			}
			if (currentLevel.difficulty == 6){
				backGroundCloudsA.image = [UIImage imageNamed:@"yellowClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"magentaClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"bluegrid.png"];
			}
			if (currentLevel.difficulty == 7){
				backGroundCloudsA.image = [UIImage imageNamed:@"redClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"greenClouds.png"];    
				backGroundGrid.image = [UIImage imageNamed:@"cyangrid.png"];
			}
			if (currentLevel.difficulty == 8){
				backGroundCloudsA.image = [UIImage imageNamed:@"blueClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"violetClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"redgrid.png"];
			}
			if (currentLevel.difficulty == 9){
				backGroundCloudsA.image = [UIImage imageNamed:@"cyanBlueClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"greenClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"pinkgrid.png"];
			}
			if (currentLevel.difficulty == 10){
				backGroundCloudsA.image = [UIImage imageNamed:@"cyanClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"yellowClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"greengrid.png"];
			}
			if (currentLevel.difficulty == 11){
				backGroundCloudsA.image = [UIImage imageNamed:@"magentaClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"orangeClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"greengrid.png"];
			}
            break;            
        default:
			backGroundTransition.transform = CGAffineTransformIdentity;
			if (currentLevel.difficulty == 1){
				backGroundCloudsA.image = [UIImage imageNamed:@"redClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"blueClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"orangegrid.png"];
			}
            if (currentLevel.difficulty == 2){
				backGroundCloudsA.image = [UIImage imageNamed:@"redClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"blueClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"greengrid.png"];
			}
			if (currentLevel.difficulty == 3){
				backGroundCloudsA.image = [UIImage imageNamed:@"cyanClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"yellowClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"violetgrid.png"];
			}
			if (currentLevel.difficulty == 4){
				backGroundCloudsA.image = [UIImage imageNamed:@"greenClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"violetClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"cyangrid.png"];
			}
			if (currentLevel.difficulty == 5){
				backGroundCloudsA.image = [UIImage imageNamed:@"cyanBlueClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"orangeClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"purplegrid.png"];
			}
			if (currentLevel.difficulty == 6){
				backGroundCloudsA.image = [UIImage imageNamed:@"yellowClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"magentaClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"bluegrid.png"];
			}
			if (currentLevel.difficulty == 7){
				backGroundCloudsA.image = [UIImage imageNamed:@"redClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"greenClouds.png"];    
				backGroundGrid.image = [UIImage imageNamed:@"cyangrid.png"];
			}
			if (currentLevel.difficulty == 8){
				backGroundCloudsA.image = [UIImage imageNamed:@"blueClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"violetClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"redgrid.png"];
			}
			if (currentLevel.difficulty == 9){
				backGroundCloudsA.image = [UIImage imageNamed:@"cyanBlueClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"greenClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"pinkgrid.png"];
			}
			if (currentLevel.difficulty == 10){
				backGroundCloudsA.image = [UIImage imageNamed:@"cyanClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"yellowClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"greengrid.png"];
			}
			if (currentLevel.difficulty == 11){
				backGroundCloudsA.image = [UIImage imageNamed:@"magentaClouds.png"];
				backGroundCloudsB.image = [UIImage imageNamed:@"orangeClouds.png"];
				backGroundGrid.image = [UIImage imageNamed:@"greengrid.png"];
			}
            break;
			
    }
	
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationDuration:2.0f];
	[UIView setAnimationDelegate:self];
	
	backGroundCloudsA.alpha = 1;
	backGroundCloudsB.alpha = 1;
	backGroundGrid.alpha = 1;
	backGroundTransition.alpha = 0;
	
	[UIView commitAnimations];
}

-(void)removeStats{
	statsView.hidden = TRUE;
}
-(BOOL)subtractScoreForRecipe{
	if (score >= 0 && currentLevel.difficulty == 1){
		scoreLabel.text = [NSString stringWithFormat:@"%d" , score];
		return TRUE;
	}
	if (score > 300 && currentLevel.difficulty == 2){
		scoreLabel.text = [NSString stringWithFormat:@"%d" , score];
		return TRUE;
	}
	if (score > 600 && currentLevel.difficulty == 3){
		scoreLabel.text = [NSString stringWithFormat:@"%d" , score];
		return TRUE;
	}
	if (score > 1000 && currentLevel.difficulty == 4){
		scoreLabel.text = [NSString stringWithFormat:@"%d" , score];
		return TRUE;
	}
	if (score > 1500 && currentLevel.difficulty == 5){
		scoreLabel.text = [NSString stringWithFormat:@"%d" , score];
		return TRUE;
	}
	if (score > 2500 && currentLevel.difficulty == 6){  
		scoreLabel.text = [NSString stringWithFormat:@"%d" , score];
		return TRUE;
		
	}
	if (score > 3750 && currentLevel.difficulty == 7){
		scoreLabel.text = [NSString stringWithFormat:@"%d" , score];
		return TRUE;
	}
	if (score > 5000 && currentLevel.difficulty == 8){
		scoreLabel.text = [NSString stringWithFormat:@"%d" , score];
		return TRUE;
	}
	if (score > 7000 && currentLevel.difficulty == 9){
		scoreLabel.text = [NSString stringWithFormat:@"%d" , score];
		return TRUE;
	}
	if (score > 10000 && currentLevel.difficulty == 10){
		scoreLabel.text = [NSString stringWithFormat:@"%d" , score];
		return TRUE;
	}
	return FALSE;
}

-(IBAction)ClickReset{
	score = 0;
	scoreLabel.text = [NSString stringWithFormat:@"%@" , score ];
	[self SaveState];
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
	//[powerItem dealloc];
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
	//gameState.currentBoard.Active = [NSNumber numberWithBool:NO];
    [self dismissModalViewControllerAnimated:NO];
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
    
    lockFeedBackA.image = [UIImage imageNamed:@"lockFeedBack.png"];
	lockFeedBackB.image = [UIImage imageNamed:@"lockFeedBack.png"];
	lockFeedBackC.image = [UIImage imageNamed:@"lockFeedBack.png"];
	
	cellA.ItemInCell.userInteractionEnabled = TRUE;
	cellB.ItemInCell.userInteractionEnabled = TRUE;
	cellC.ItemInCell.userInteractionEnabled = TRUE;
	
	cellA.ItemInCell.alpha = 1;
	cellB.ItemInCell.alpha = 1;
	cellC.ItemInCell.alpha = 1;
    
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
		powerBack.image = [UIImage imageNamed:@"upgradeIcon.png"];
		SpawnedPair.ItemA.hidden = TRUE;
		SpawnedPair.ItemB.hidden = TRUE;
		SpawnedPair.ItemC.hidden = TRUE;
		[self setButtons];
	}
}
-(IBAction)ClickButtonBomb{
	Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
	if(appDelegate.isBombing == YES){
		appDelegate.isBombing = NO;
		SpawnedPair.ItemA.hidden = FALSE;
		SpawnedPair.ItemB.hidden = FALSE;
		SpawnedPair.ItemC.hidden = FALSE;
		powerBack.image = nil;
		[self setButtons];
		return;
	}
	if(bombCount > 0){
		appDelegate.isBombing = YES;
		powerBack.image = [UIImage imageNamed:@"bombIcon.png"];
		SpawnedPair.ItemA.hidden = TRUE;
		SpawnedPair.ItemB.hidden = TRUE;
		SpawnedPair.ItemC.hidden = TRUE;
		return;
	}
}
-(IBAction)ClickButtonShuffle{
	Rama_BlocksAppDelegate * appDelegate =  (Rama_BlocksAppDelegate *)[[UIApplication sharedApplication] delegate];
	if(didShuffle == TRUE){
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
			
			for(ItemState * item in [appDelegate FetchCollectionItemStates]){
				if([item.shapeType intValue] != -1 && [item.colorType intValue] != -1){
					Shape * shape = [[[Shape alloc] initWithInfo:[item.colorType intValue] :[item.shapeType intValue] : CGPointMake(spawnX,spawnY)]retain];
					Cell * cell = [itemCollection GetCell:[item.Row intValue] : [item.Column intValue]];
					[itemCollection SetItemToCell:shape : cell];
					[self.view addSubview:shape];
				}
			}
			didShuffle = FALSE;
			SpawnedPair.ItemA.hidden = FALSE;
			SpawnedPair.ItemB.hidden = FALSE;
			SpawnedPair.ItemC.hidden = FALSE;
			powerBack.image = nil;
            return;
		}
		if(didShuffle == FALSE){
			didShuffle = TRUE;
			powerBack.image = [UIImage imageNamed:@"shuffleIcon.png"];
			SpawnedPair.ItemA.hidden = TRUE;
			SpawnedPair.ItemB.hidden = TRUE;
			SpawnedPair.ItemC.hidden = TRUE;
        }
	}
}
-(IBAction)ClickButtonCheckRecipe{
	NSMutableArray * correctRecipe = [[NSMutableArray alloc] initWithCapacity:3];
	BOOL scoreCheck = [self subtractScoreForRecipe];
	recipeLabel.text = [NSString stringWithFormat:@"incorrect"];
	if(scoreCheck == TRUE){
		if(shapeA.shapeType == shapeB.shapeType && shapeB.shapeType == shapeC.shapeType){
			if(shapeA.colorType == shapeB.colorType && shapeB.colorType == shapeC.colorType){	
				if(shapeA.shapeType == Square){
					discardCount++;
					//all squares same color
					NSLog(@"1 extra discard");
					recipeLabel.text = [NSString stringWithFormat:@"You built 1 extra discard"];
					recipeLabel.hidden = FALSE;
					[correctRecipe addObject:cellA];
					[correctRecipe addObject:cellB];
					[correctRecipe addObject:cellC];
					[itemCollection RemoveFromCellsAndRefactor: correctRecipe];
					//[self ClickButtonCloseLockTab];
					
				}
				if(shapeA.shapeType == Pentagon){
					bombCount++;
					//all pentagons same color
					NSLog(@"1 extra bomb");
					recipeLabel.text = [NSString stringWithFormat:@"You built 1 extra bomb"];
					recipeLabel.hidden = FALSE;
					[correctRecipe addObject:cellA];
					[correctRecipe addObject:cellB];
					[correctRecipe addObject:cellC];
					[itemCollection RemoveFromCellsAndRefactor: correctRecipe];
					//[self ClickButtonCloseLockTab];
				}
				if(shapeA.shapeType == Hexagon){
					discardCount = discardCount + 2;
					NSLog(@"2 extra discards");
					recipeLabel.text = [NSString stringWithFormat:@"You built 2 extra discards"];
					recipeLabel.hidden = FALSE;
					[correctRecipe addObject:cellA];
					[correctRecipe addObject:cellB];
					[correctRecipe addObject:cellC];
					[itemCollection RemoveFromCellsAndRefactor: correctRecipe];
					//[self ClickButtonCloseLockTab];
					//all hexs same color
				}
				if(shapeA.shapeType == Circle){
					NSLog(@"destroy all of that color on the board");
					recipeLabel.text = [NSString stringWithFormat:@"You destroyed all of that color on the board"];
					recipeLabel.hidden = FALSE;
					[correctRecipe addObject:cellA];
					[correctRecipe addObject:cellB];
					[correctRecipe addObject:cellC];
					[itemCollection RemoveFromCellsAndRefactor: correctRecipe];
					[powerItem makeCollection: itemCollection];
					[powerItem makeFilter: shapeA];
					//[self ClickButtonCloseLockTab];
					//all circle same color
				}
			}
			if(shapeA.colorType != shapeB.colorType && shapeA.colorType != shapeC.colorType && shapeB.colorType != shapeC.colorType){
				if(shapeA.shapeType == Square){
					upgradeCount++;
					NSLog(@"1 piece instant upgrade");
					recipeLabel.text = [NSString stringWithFormat:@"You built 1 piece instant upgrade"];
					recipeLabel.hidden = FALSE;
					[correctRecipe addObject:cellA];
					[correctRecipe addObject:cellB];
					[correctRecipe addObject:cellC];
					[itemCollection RemoveFromCellsAndRefactor: correctRecipe];
					//[self ClickButtonCloseLockTab];
					//all squares dif color
				}
				if(shapeA.shapeType == Pentagon){
					NSLog(@"2 piece instant upgrade");
					recipeLabel.text = [NSString stringWithFormat:@"You built 2 piece instant upgrades"];
					recipeLabel.hidden = FALSE;
					[correctRecipe addObject:cellA];
					[correctRecipe addObject:cellB];
					[correctRecipe addObject:cellC];
					upgradeCount = upgradeCount + 2;
					[itemCollection RemoveFromCellsAndRefactor: correctRecipe];
					//[self ClickButtonCloseLockTab];
					//all pentagons dif color
				}
				if(shapeA.shapeType == Hexagon){
					reshuffleCount++;
					NSLog(@"1 reshuffle");
					recipeLabel.text = [NSString stringWithFormat:@"You built 1 reshuffle"];
					recipeLabel.hidden = FALSE;
					[correctRecipe addObject:cellA];
					[correctRecipe addObject:cellB];
					[correctRecipe addObject:cellC];
					[itemCollection RemoveFromCellsAndRefactor: correctRecipe];
					//[self ClickButtonCloseLockTab];
					//all hexs dif color
				}
				if(shapeA.shapeType == Circle){
					bombCount = bombCount + 4;
					NSLog(@"4 extra bombs");
					recipeLabel.text = [NSString stringWithFormat:@"You built 4 extra bombs"];
					recipeLabel.hidden = FALSE;
					[correctRecipe addObject:cellA];
					[correctRecipe addObject:cellB];
					[correctRecipe addObject:cellC];
					[itemCollection RemoveFromCellsAndRefactor: correctRecipe];
					//[self ClickButtonCloseLockTab];
					//all circles dif color
				}	
			}
		}
		if(shapeA.colorType == shapeB.colorType && shapeB.shapeType == shapeC.colorType){
			if(shapeA.shapeType == Square || shapeB.shapeType == Square || shapeC.shapeType == Square){
				if(shapeA.shapeType == Pentagon || shapeB.shapeType == Pentagon || shapeC.shapeType == Pentagon){
					if(shapeA.shapeType == Hexagon || shapeB.shapeType == Hexagon || shapeC.shapeType == Hexagon){
						//Square, pentagon, hexagon of same color
						NSLog(@"3 piece instant upgrade");
						recipeLabel.text = [NSString stringWithFormat:@"You built 3 instant upgrades"];
						recipeLabel.hidden = FALSE;
						upgradeCount = upgradeCount + 3;
						[correctRecipe addObject:cellA];
						[correctRecipe addObject:cellB];
						[correctRecipe addObject:cellC];
						[itemCollection RemoveFromCellsAndRefactor: correctRecipe];
						//[self ClickButtonCloseLockTab];
					}
				}
			}
			if(shapeA.shapeType == Triangle || shapeB.shapeType == Triangle || shapeC.shapeType == Triangle){
				if(shapeA.shapeType == Square || shapeB.shapeType == Square || shapeC.shapeType == Square){
					if(shapeA.shapeType == Pentagon || shapeB.shapeType == Pentagon || shapeC.shapeType == Pentagon){
						bombCount = bombCount + 2;
						//Triangle, square, pentagon of same color
						NSLog(@"2 bombs");
						recipeLabel.text = [NSString stringWithFormat:@"You built 2 bombs"];
						recipeLabel.hidden = FALSE;
						[correctRecipe addObject:cellA];
						[correctRecipe addObject:cellB];
						[correctRecipe addObject:cellC];
						[itemCollection RemoveFromCellsAndRefactor: correctRecipe];
						//[self ClickButtonCloseLockTab];
					}
				}
			}
			if(shapeA.shapeType == Pentagon || shapeB.shapeType == Pentagon || shapeC.shapeType == Pentagon){
				if(shapeA.shapeType == Hexagon || shapeB.shapeType == Hexagon || shapeC.shapeType == Hexagon){
					if(shapeA.shapeType == Circle || shapeB.shapeType == Circle || shapeC.shapeType == Circle){
						[powerItem makeCollection: itemCollection];
						[powerItem stopGravity:nil];
						//Pentagon, Hexagon, Circle of same color
						//30 seconds no-gravity
						NSLog(@"30 seconds no gravity ");
						recipeLabel.text = [NSString stringWithFormat:@"You stopped gravity for 30 seconds, HURRY!"];
						recipeLabel.hidden = FALSE;
						[correctRecipe addObject:cellA];
						[correctRecipe addObject:cellB];
						[correctRecipe addObject:cellC];
						[itemCollection RemoveFromCellsAndRefactor: correctRecipe];
						//[self ClickButtonCloseLockTab];
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
						recipeLabel.text = [NSString stringWithFormat:@"You built 1 reshuffle"];
						recipeLabel.hidden = FALSE;
						[correctRecipe addObject:cellA];
						[correctRecipe addObject:cellB];
						[correctRecipe addObject:cellC];
						[itemCollection RemoveFromCellsAndRefactor: correctRecipe];
						//[self ClickButtonCloseLockTab];
					}
				}
			}
			if(shapeA.shapeType == Triangle || shapeB.shapeType == Triangle || shapeC.shapeType == Triangle){
				if(shapeA.shapeType == Square || shapeB.shapeType == Square || shapeC.shapeType == Square){
					if(shapeA.shapeType == Pentagon || shapeB.shapeType == Pentagon || shapeC.shapeType == Pentagon){
						discardCount = discardCount + 2;
						//Triangle, square, pentagon dif color
						NSLog(@"2 discards");
						recipeLabel.text = [NSString stringWithFormat:@"You built 3 discards"];
						recipeLabel.hidden = FALSE;
						[correctRecipe addObject:cellA];
						[correctRecipe addObject:cellB];
						[correctRecipe addObject:cellC];
						[itemCollection RemoveFromCellsAndRefactor: correctRecipe];
						//[self ClickButtonCloseLockTab];
					}
				}
			}
			if(shapeA.shapeType == Pentagon || shapeB.shapeType == Pentagon || shapeC.shapeType == Pentagon){
				if(shapeA.shapeType == Hexagon || shapeB.shapeType == Hexagon || shapeC.shapeType == Hexagon){
					if(shapeA.shapeType == Circle || shapeB.shapeType == Circle || shapeC.shapeType == Circle){
						bombCount = bombCount + 2;
						//Pentagon, hexagon, circle dif color
						//30 seconds no-gravity
						NSLog(@"2 extra bombs");
						recipeLabel.text = [NSString stringWithFormat:@"You built 2 extra bombs"];
						recipeLabel.hidden = FALSE;
						[correctRecipe addObject:cellA];
						[correctRecipe addObject:cellB];
						[correctRecipe addObject:cellC];
						[itemCollection RemoveFromCellsAndRefactor: correctRecipe];
						//[self ClickButtonCloseLockTab];
						
					}
				}
			}
		}
	}
	recipeLabel.hidden = FALSE;
	
	shapeA = nil;
	shapeB = nil;
	shapeC = nil;
	
	lockFeedBackA.image = [UIImage imageNamed:@"lockFeedBack.png"];
	lockFeedBackB.image = [UIImage imageNamed:@"lockFeedBack.png"];
	lockFeedBackC.image = [UIImage imageNamed:@"lockFeedBack.png"];
	
	cellA.ItemInCell.alpha = 1;
	cellB.ItemInCell.alpha = 1;
	cellC.ItemInCell.alpha = 1;
	
	cellA.ItemInCell.userInteractionEnabled = TRUE;
	cellB.ItemInCell.userInteractionEnabled = TRUE;
	cellC.ItemInCell.userInteractionEnabled = TRUE;
	
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
	[correctRecipe autorelease];
	[self ClickButtonCloseLockTab];
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
    [backGroundCloudsA release];
    [backGroundStars release];
	[backGroundCloudsB release];
    [lockFeedBackA  release];
	[lockFeedBackB  release];
	[lockFeedBackC release];
    [guessView release];
	[powerBack release];
	[SpawnedPair release];
	[itemCollection release];
	[TouchTimer release];
    [super dealloc];
}



@end

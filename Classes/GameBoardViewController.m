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




/*****************************************************
GameBoard Behavior
*****************************************************/
-(void)SpawnShapes{
	if(SpawnedPair==nil)
		SpawnedPair = [ItemPair new];
	
    [SpawnedPair.ItemA release];
    SpawnedPair.ItemA = [[Shape alloc] initWithInfo:[currentLevel createRandomColor]: [currentLevel createShapeFromCollection] : CGPointMake(SPAWN_LOCATION_X,SPAWN_LOCATION_Y)];
    [ self.view addSubview:SpawnedPair.ItemA];
    
    [SpawnedPair.ItemB release];
    SpawnedPair.ItemB = [[Shape alloc] initWithInfo:[currentLevel createRandomColor]: [currentLevel createShapeFromCollection] : CGPointMake(SPAWN_LOCATION_X + SHAPE_WIDTH ,SPAWN_LOCATION_Y)];
    [ self.view addSubview:SpawnedPair.ItemB];
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
    audio = appDelegate.gameState.audio;
    Difficulty diff = appDelegate.gameState.currentDifficulty;
    
	// Create background
	backGround = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	backGround.clipsToBounds = YES;
	backGround.autoresizesSubviews = NO;
	 backGround.contentMode = UIViewContentModeTopLeft;
	 backGround.image = [[UIImage imageNamed:@"BackGround.png"] retain];
    
    self.view.backgroundColor = [UIColor blackColor];
	[self.view addSubview:backGround];
    
    
    //add solution to view
    currentLevel = [[Level alloc] init:diff];
    [currentLevel addSolutionToView:self.view];
    itemCollection = [[ItemCollection alloc] init:NUMBER_OF_ROWS :NUMBER_OF_COLUMNS :SHAPE_WIDTH :SHAPE_WIDTH: currentLevel];
	SpawnedPair = [[ItemPair new]retain];

	CurrentDevice = [UIDevice currentDevice];
    [CurrentDevice beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRotate:)
                                                 name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    
    
    
    [self didRotate:nil];
	[self SpawnShapes];
    [super viewDidLoad];
}


-(void)didRotate:(NSNotification *)notification
{
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
        if(highlightItem != nil && ! highlightItem.IsPaired && [highlightItem isKindOfClass:[Shape class]])
        {
            Shape * shape = (Shape *) highlightItem;
            [itemCollection AddShapeToSolution:shape];
            shape.tapped = 0;
        }
    }
    
    
	if([[touch view] isKindOfClass: [GameItem class]] && ![[touch view] isKindOfClass: [LockShape class]])
	{
		GameItem * item = (GameItem *)[touch view];
		if(item.IsPaired)
        {
			[SpawnedPair move:[touch locationInView: self.view] :item];
            item.tapped = 0;
        }
        
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
				[SpawnedPair rotate:[touch locationInView: self.view] : item];
			}
			if(item.center.y > GRID_Y)
            {
				if([itemCollection AddItemPair:SpawnedPair])
                {
					[self SpawnShapes];
				}else{
					[self ResetShapePair:SpawnedPair];
				}
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
                }
            }
        }
        
	}
}

/*****************************************************
Tear down and maintenance
*****************************************************/
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];	
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g.  myOutlet = nil;
}

- (void)dealloc {
	[backGround release];
	[SpawnedPair release];
	[itemCollection release];
	[TouchTimer release];
    [super dealloc];
}



@end

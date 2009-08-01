//
//  GameBoardViewController.m
//  RumbaBlocks
//
//  Created by Johnny Moralez on 6/23/09.
//  Copyright 2009 Simplical, LLC. All rights reserved.
//

#import "GameBoardViewController.h"

@implementation GameBoardViewController




/*****************************************************
GameBoard Behavior
*****************************************************/
-(void)SpawnShapes{
	if(SpawnedPair==nil)
		SpawnedPair = [ItemPair new];
	
	int currentComplex = [itemCollection getComplexity];
	if(complexity < currentComplex){
		complexity = currentComplex;
	}
		
    [SpawnedPair->ItemA release];
    SpawnedPair->ItemA = [[Shape alloc] initWithInfo:CGRectMake(SPAWN_LOCATION_X, SPAWN_LOCATION_Y, 30.0f, 30.0f)  : (uint)arc4random() % NUMBER_OF_COLORS :(uint)arc4random() % NUMBER_OF_SHAPES];
    [ self.view addSubview:SpawnedPair->ItemA];
    
    
    [SpawnedPair->ItemB release];
    SpawnedPair->ItemB = [[Shape alloc] initWithInfo:CGRectMake((SPAWN_LOCATION_X + SHAPE_WIDTH), SPAWN_LOCATION_Y, 30.0f, 30.0f)  : (uint)arc4random() % NUMBER_OF_COLORS :(uint)arc4random() % NUMBER_OF_SHAPES];
    [ self.view addSubview:SpawnedPair->ItemB];		
	
}


- (void)resetTap:(NSTimer *)tapTimer {
	GameItem *tappedShape = (GameItem *)[tapTimer userInfo];
	tappedShape->tapped = 0;
}

-(void)ResetShapePair:(ItemPair *)pair{
	pair->ItemA.center = CGPointMake((SPAWN_LOCATION_X), SPAWN_LOCATION_Y);
	pair->ItemB.center = CGPointMake((SPAWN_LOCATION_X + SHAPE_WIDTH), SPAWN_LOCATION_Y);
}

/*****************************************************
UIController Delegates
*****************************************************/
- (void)viewDidLoad {
	
	// Create grid
	grid = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	grid.clipsToBounds = YES;
	grid.autoresizesSubviews = NO;
	 grid.contentMode = UIViewContentModeTopLeft;
	 grid.image = [[UIImage imageNamed:@"BackGround.png"] retain];
     self.view.backgroundColor = [UIColor blackColor];
	[self.view addSubview:grid];
    
    itemCollection = [[ItemCollection alloc] init:NUMBER_OF_ROWS :NUMBER_OF_COLUMNS :SHAPE_WIDTH :SHAPE_WIDTH];
	SpawnedPair = [[ItemPair new]retain];
	complexity = 0;
	CurrentDevice = [UIDevice currentDevice];
    [CurrentDevice beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRotate:)
                                                 name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    
	//[ view addObject:flip]; 
    [self didRotate:nil];
	
	[self SpawnShapes];
    [super viewDidLoad];

	
	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	
	if([[touch view] isKindOfClass: [GameItem class]])
	{
		GameItem * touchedItem = (GameItem *)[touch view];
		if(touchedItem->IsPaired)
		{
			[TouchTimer invalidate];
			touchedItem->tapped++;
			TouchTimer = [[NSTimer scheduledTimerWithTimeInterval:TAP_WAIT_TIME target:self selector:@selector(resetTap:) userInfo:touchedItem repeats:NO] retain];
		}
		else{
			[itemCollection TransformItem:touchedItem];
		}
			
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	/* Shape was touched */
	if([[touch view] isKindOfClass: [GameItem class]])
	{
		GameItem * item = (GameItem *)[touch view];
		
		if(item->IsPaired)
		{
			if (item->tapped == 1) {
				item->tapped = 0;
				[SpawnedPair rotate:[touch locationInView: self.view] : item];
			}
			if(item.center.y > GRID_Y){
				
				if([itemCollection AddItemPair:SpawnedPair]){
					[self SpawnShapes];
				}else{
					[self ResetShapePair:SpawnedPair];
				}
			}
		}
		

	}


}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	if([[touch view] isKindOfClass: [GameItem class]])
	{
		GameItem * item = (GameItem *)[touch view];
		
		if(item->IsPaired)
			[SpawnedPair moveShape:[touch locationInView: self.view] :item];
	}
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
	[grid release];
	[SpawnedPair release];
	[itemCollection release];
	[TouchTimer release];
    [super dealloc];
}



@end

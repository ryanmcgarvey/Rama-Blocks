//
//  Rama_BlocksAppDelegate.m
//  Rama Blocks
//
//  Created by Ryan McGarvey on 7/29/09.
//  Copyright Simplical 2009. All rights reserved.
//


#import "Rama_BlocksAppDelegate.h"
#import "GameItem.h"

@implementation Rama_BlocksAppDelegate

@synthesize window;
@synthesize isMoving, isAttaching, isFiltering, isUpgrading, allowGravity, level, isBombing;



- (void)applicationDidFinishLaunching:(UIApplication *)application{
	
	animatedSimplical = [[UIImageView alloc] initWithFrame:window.frame];
	
	animatedSimplical.animationImages = [NSArray arrayWithObjects:    
										 [UIImage imageNamed:@"simp1.png"],
										 [UIImage imageNamed:@"simp2.png"],
										 [UIImage imageNamed:@"simp3.png"],
										 [UIImage imageNamed:@"simp4.png"],
										 [UIImage imageNamed:@"simp5.png"],
										 [UIImage imageNamed:@"simp6.png"],
										 [UIImage imageNamed:@"simp7.png"],
										 [UIImage imageNamed:@"simp8.png"],
										 [UIImage imageNamed:@"simp9.png"],
										 [UIImage imageNamed:@"simp10.png"],
										 [UIImage imageNamed:@"simp9.png"], 
										 [UIImage imageNamed:@"simp8.png"],
										 [UIImage imageNamed:@"simp7.png"],
										 [UIImage imageNamed:@"simp6.png"],
										 [UIImage imageNamed:@"simp5.png"],
										 [UIImage imageNamed:@"simp4.png"],
										 [UIImage imageNamed:@"simp3.png"],
										 [UIImage imageNamed:@"simp2.png"],
										 [UIImage imageNamed:@"simp1.png"],nil];
	
	animatedSimplical.animationDuration = 1.0;
	
	animatedSimplical.animationRepeatCount = -1;
	
	[animatedSimplical startAnimating];
	
	[window addSubview:animatedSimplical];
	[window makeKeyAndVisible];
	
	[self performSelector:@selector(stopAnimation) withObject:nil afterDelay:2];
	
}

- (void)stopAnimation{
	[animatedSimplical stopAnimating];
	[self beginRamaBlocks];
}

-(void)beginRamaBlocks{
	gameState = [self FetchGameState];
	
    mainMenu = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
	
    [window addSubview:mainMenu.view];
	[window makeKeyAndVisible];
	
	//isMoving = NO;
	isAttaching = NO;
	isFiltering = NO;
	isUpgrading = NO;
	isBombing = NO;
	allowGravity = YES;
	
	level = [[Level alloc] init:[gameState.currentLevel intValue]];
}


-(SoundEffects *)FetchAudio{
    if(audio == nil){
        audio = [SoundEffects new];
    }
    return audio;
}

-(GameState *)FetchGameState{
    
    if(gameState == nil)
    {
        
        [self managedObjectContext];
		
        NSError *fetchError = nil;
        NSArray *fetchResults;
        
        NSEntityDescription *entityDescription = [NSEntityDescription
                                                  entityForName:@"GameState" 
                                                  inManagedObjectContext:managedObjectContext];
        
        NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
        
        [request setEntity:entityDescription];
        
        fetchResults = [managedObjectContext 
                        executeFetchRequest:request 
                        error:&fetchError];
        
        if ((fetchResults != nil) && ([fetchResults count] == 1) && (fetchError == nil)) 
        {
            gameState = [fetchResults objectAtIndex:0];
        }
        else
        {
            gameState =  [NSEntityDescription
                          insertNewObjectForEntityForName:@"GameState" 
                          inManagedObjectContext:managedObjectContext];
            gameState.currentLevel = [NSNumber numberWithInt:0];
            gameState.highestLevel = [NSNumber numberWithInt:1];
            gameState.currentBoard = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"BoardState" 
                                      inManagedObjectContext:managedObjectContext];
            
            for(int i = 0; i < NUMBER_OF_ROWS * NUMBER_OF_COLUMNS; i++)
            {
				
                ItemState * item = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"ItemState" 
                                    inManagedObjectContext:managedObjectContext];
                
                item.index = [NSNumber numberWithInt:i];
                item.ItemType = [NSNumber numberWithInt: ShapeItem];
                [gameState.currentBoard addItemsObject:item];
                
            }
            for(int i = 0; i <= 6; i++)
            {
                
                ItemState * item = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"ItemState" 
                                    inManagedObjectContext:managedObjectContext];
                
                item.index = [NSNumber numberWithInt:i];
                item.ItemType = [NSNumber numberWithInt:LockShapeItem];
                [gameState.currentBoard addItemsObject:item];
            }
            
            ItemState * item = [NSEntityDescription
                                insertNewObjectForEntityForName:@"ItemState" 
                                inManagedObjectContext:managedObjectContext];
            
            item.index = [NSNumber numberWithInt:0];
            item.ItemType = [NSNumber numberWithInt:SpawnItem];
            [gameState.currentBoard addItemsObject:item];
            
            item = [NSEntityDescription
					insertNewObjectForEntityForName:@"ItemState" 
					inManagedObjectContext:managedObjectContext];
            item.index = [NSNumber numberWithInt:1];
            item.ItemType = [NSNumber numberWithInt:SpawnItem];
            [gameState.currentBoard addItemsObject:item];
            
        }
        [managedObjectContext processPendingChanges];
    }
    return gameState;
}

-(NSArray *)FetchCollectionItemStates{
    
    [self managedObjectContext];
    NSError *fetchError = nil;
    NSArray *fetchResults;
    
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"ItemState" 
                                              inManagedObjectContext:managedObjectContext];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"index" ascending:YES];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(owningBoardState == %@) and (ItemType == %d) ", gameState.currentBoard, ShapeItem ];
    
	
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    
	
    
    [request setEntity:entityDescription];
    [request setPredicate:predicate];
    [request setSortDescriptors: [NSArray arrayWithObject:sortDescriptor]];
	
    
    fetchResults = [managedObjectContext 
                    executeFetchRequest:request 
                    error:&fetchError];
    
    [sortDescriptor release];
	return fetchResults;
}

-(NSArray *)FetchLockItems{
    
    [self managedObjectContext];
    NSError *fetchError = nil;
    NSArray *fetchResults;
    
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"ItemState" 
                                              inManagedObjectContext:managedObjectContext];
	
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"index" ascending:YES];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @" (owningBoardState == %@) and (ItemType == %d) ", gameState.currentBoard, LockShapeItem ];
    
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    
    [request setEntity:entityDescription];
    [request setPredicate:predicate];
    [request setSortDescriptors: [NSArray arrayWithObject:sortDescriptor]];
    
    
    fetchResults = [managedObjectContext 
                    executeFetchRequest:request 
                    error:&fetchError];
    [sortDescriptor release];
	return fetchResults;
	
	
}

-(NSArray *)FetchSpawnedItems{
    
    [self managedObjectContext];
    NSError *fetchError = nil;
    NSArray *fetchResults;
    
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"ItemState" 
                                              inManagedObjectContext:managedObjectContext];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"index" ascending:YES];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @" (owningBoardState == %@) and (ItemType == %d) ", gameState.currentBoard, SpawnItem ];
    
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    
    [request setEntity:entityDescription];
    [request setPredicate:predicate];
    [request setSortDescriptors: [NSArray arrayWithObject:sortDescriptor]];
    
    
    fetchResults = [managedObjectContext 
                    executeFetchRequest:request 
                    error:&fetchError];
    [sortDescriptor release];
	return fetchResults;
}

-(LevelStatistics *)CreatePlayedLevel{
    [self managedObjectContext];
    LevelStatistics * stat = [NSEntityDescription
							  insertNewObjectForEntityForName:@"LevelStatistics" 
							  inManagedObjectContext:managedObjectContext];
    
    return stat;
}


-(NSArray *)FetchPlayedLevels{
    [self managedObjectContext];
    NSError *fetchError = nil;
    NSArray * fetchResults;
    
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"LevelStatistics" 
                                              inManagedObjectContext:managedObjectContext];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"Level" ascending:YES];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(owningGameState == %@)", gameState];
    
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    
    [request setEntity:entityDescription];
    [request setPredicate:predicate];
    [request setSortDescriptors: [NSArray arrayWithObject:sortDescriptor]];
    
    
    fetchResults = [managedObjectContext 
                    executeFetchRequest:request 
                    error:&fetchError];
    return fetchResults;
	[sortDescriptor release];
	return fetchResults;
}



////////////////////////////////////////////////////////////////


- (void)applicationWillTerminate:(UIApplication *)application {
    NSError *error = nil;
    if (managedObjectContext != nil) 
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) 
        {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. 
             You should not use this function in a shipping application, although 
             it may be useful during development. If it is not possible to recover 
             from the error, display an alert panel that instructs the user to quit 
             the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			//abort();
        } 
    }
	[self dealloc];
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"persistenTest.sqlite"]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. 
         You should not use this function in a shipping application, although 
         it may be useful during development. If it is not possible to recover 
         from the error, display an alert panel that instructs the user to quit 
         the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
	[window release];
	[super dealloc];
    
}
@end
//
//  Rama_BlocksAppDelegate.m
//  Rama Blocks
//
//  Created by Ryan McGarvey on 7/29/09.
//  Copyright Simplical 2009. All rights reserved.
//

#import "Rama_BlocksAppDelegate.h"


@implementation Rama_BlocksAppDelegate

@synthesize window;
@synthesize gameState;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    //gameState = [GameState new];
    
    [self loadEncodedGameState];
    
    //gameState.audio.volume = newGameState.volume;
    //gameState.currentDifficulty = newGameState.currentDifficulty;
    /*
     if(gameState == nil){
     gameState = [GameState new];
     gameState.audio.volume = 0.5f;
     }
     */
    
    mainMenu = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
    [window addSubview:mainMenu.view];
    
	[window makeKeyAndVisible];
}


-(void)saveEncodedGameState
{
	NSUserDefaults *persistentStorage = [NSUserDefaults standardUserDefaults];
    NSData *encodedGameState = [NSKeyedArchiver archivedDataWithRootObject:gameState];
	[persistentStorage setObject:encodedGameState forKey:@"encodedGameState"];
}

-(GameState*)loadEncodedGameState
{
    if (gameState == nil)
    {
        NSUserDefaults *persistentStorage = [NSUserDefaults standardUserDefaults];
        NSData *encodedGameState = [persistentStorage objectForKey: @"encodedGameState"];
        gameState = (GameState*)[[NSKeyedUnarchiver unarchiveObjectWithData: encodedGameState] retain];
    }
    return gameState;
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }
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
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Rama_Blocks.sqlite"]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
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

-(void)makePersistentStore{
    NSUserDefaults *gamestate = [NSUserDefaults standardUserDefaults];
	[gamestate setObject:gameState forKey:@"gamestate"];
	[gamestate synchronize];    
	
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


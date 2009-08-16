//
//  Rama_BlocksAppDelegate.h
//  Rama Blocks
//
//  Created by Ryan McGarvey on 7/29/09.
//  Copyright Simplical 2009. All rights reserved.
//

@class MainMenuViewController;


#import "MainMenuViewController.h"
#import "GameState.h"
#import "SoundEffects.h"
#import "GameItem.h"
#import "LevelStatistics.h"

@interface Rama_BlocksAppDelegate : NSObject <UIApplicationDelegate> {
    
    
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    
    SoundEffects * audio;
    
    
    MainMenuViewController * mainMenu;
    GameState * gameState;
    UIWindow *window;
	int gameType;
	BOOL isMoving;
	BOOL isAttaching;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (readwrite, assign) int gameType;
@property (readwrite, assign) BOOL isMoving;
@property (readwrite, assign) BOOL isAttaching;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;


-(GameState *)FetchGameState;
-(SoundEffects *)FetchAudio;

-(NSArray *)FetchCollectionItemStates;
-(NSArray *)FetchSpawnedItems;
-(NSArray *)FetchLockItems;
-(NSArray *)FetchPlayedLevels;

-(LevelStatistics *)CreatePlayedLevel;

@end


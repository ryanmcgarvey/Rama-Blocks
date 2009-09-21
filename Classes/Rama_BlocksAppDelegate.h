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
#import "Level.h"


@interface Rama_BlocksAppDelegate : NSObject <UIApplicationDelegate> {
    
    
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    
    SoundEffects * audio;
	
	Level * level;
    
    MainMenuViewController * mainMenu;
    GameState * gameState;
    UIWindow *window;

	BOOL isMoving;
	BOOL isBombing;
	BOOL isFiltering;
	BOOL isUpgrading;
	BOOL allowGravity;
	BOOL yShift;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (readwrite, assign) Level * level;
@property (readwrite, assign) BOOL isMoving;
@property (readwrite, assign) BOOL allowGravity;
@property (readwrite, assign) BOOL isFiltering;
@property (readwrite, assign) BOOL isBombing;
@property (readwrite, assign) BOOL isUpgrading;
@property (readwrite, assign) BOOL yShift;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;



- (NSString *)applicationDocumentsDirectory;


-(GameState *)FetchGameState;
-(SoundEffects *)FetchAudio;

-(NSArray *)FetchCollectionItemStates;
-(NSArray *)FetchSpawnedItems;
-(NSArray *)FetchPlayedLevels;

-(LevelStatistics *)CreatePlayedLevel;

@end


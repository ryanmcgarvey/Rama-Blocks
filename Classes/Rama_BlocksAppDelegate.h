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

@interface Rama_BlocksAppDelegate : NSObject <UIApplicationDelegate> {

    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    MainMenuViewController * mainMenu;
    GameState * gameState;
    Difficulty difficulty;
    UIWindow *window;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) GameState * gameState;

@property (nonatomic, retain) IBOutlet UIWindow *window;

- (NSString *)applicationDocumentsDirectory;
-(GameState*)loadEncodedGameState;
-(void)saveEncodedGameState;

@end


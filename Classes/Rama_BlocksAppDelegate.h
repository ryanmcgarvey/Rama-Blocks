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
    
    NSMutableArray * boardState;
    MainMenuViewController * mainMenu;
    GameState * gameState;
    Difficulty difficulty;
    UIWindow *window;
}


@property (nonatomic, retain) NSMutableArray * boardState;
@property (nonatomic, retain, readonly) GameState * gameState;
@property (nonatomic, retain) IBOutlet UIWindow *window;


//- (void) setNewBoardState: (NSArray *)newBoardState;

-(GameState*)loadEncodedGameState;
-(void)saveEncodedGameState;

- (void)loadEncodedBoardState;
-(void)saveEncodedBoardState;

- (id)initWithCoder:(NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)encoder;

- (NSString *) pathForDataFile;

@end


//
//  MainMenuViewController.h
//  MainMenu
//
//  Created by Johnny Moralez on 6/23/09.
//  Copyright 2009 Simplical, LLC. All rights reserved.
//

@class Options;


#import <UIKit/UIKit.h>
#import "Options.h"
#import "Tutorial.h"
#import "GameBoardViewController.h"
#import "GameState.h"
#import "LevelSelect.h"

@interface MainMenuViewController : UIViewController {
	Options * options;
	Tutorial * tutorial;
    GameState * gameState;
    LevelSelect * levelSelect;
    
    IBOutlet UIButton * GameBoardButton;
	IBOutlet UIButton * GameTimeButton;
    IBOutlet UIButton * OptionsButton;
    IBOutlet UIButton * TutorialButton;
    IBOutlet UIButton * LevelSelectButton;
	IBOutlet UIImageView *testAnimation;
	NSMutableArray *testImages;

}

@property(nonatomic, retain)IBOutlet UIImageView *testAnimation;
@property(nonatomic, retain)NSMutableArray *testImages;

- (IBAction)loadGameBoard:(id)sender;
- (IBAction)loadTimeBoard:(id)sender;
- (IBAction)loadTutorial:(id)sender;
- (IBAction)loadOptions:(id)sender;
-(IBAction)loadLevelSelect:(id)sender;


@end


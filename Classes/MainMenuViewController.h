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
	
	IBOutlet UIImageView *buttonGraphic;
	IBOutlet UIImageView *titleGraphic;
	IBOutlet UIImageView *behindButtonGraphic;
	UIImageView *zoomBack;
	
	CGPoint buttonCenter;
	CGPoint titleCenter;
	CGPoint behindButtonCenter;
	

}

@property (nonatomic, retain) UIImageView *zoomBack;


- (IBAction)loadGameBoard:(id)sender;
- (IBAction)loadTimeBoard:(id)sender;
- (IBAction)loadTutorial:(id)sender;
- (IBAction)loadOptions:(id)sender;
-(IBAction)loadLevelSelect:(id)sender;

-(void)animateButtons;
-(void)restoreCenters;
-(void)animateBoard;


@end


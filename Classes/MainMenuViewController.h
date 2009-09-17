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
	IBOutlet UIImageView *backGroundMenu;
	IBOutlet UIImageView *backGround;
	
	UIImageView *zoomBack;
	UIImageView *levelNumbers;
	UIImageView *levelSelectText;
	UIImageView *levelSelectGrayBox;
	
	UIImageView *level1;
	UIImageView *level2;
	UIImageView *level3;
	UIImageView *level4;
	UIImageView *level5;
	UIImageView *level6;
	UIImageView *level7;
	UIImageView *level8;
	UIImageView *level9;
	UIImageView *level10;
	UIImageView *level11;
	UIImageView *level12;
	UIImageView *level13;
	UIImageView *level14;
	UIImageView *level15;
	UIImageView *level16;
	UIImageView *level17;
	UIImageView *level18;
	UIImageView *level19;
	UIImageView *level20;
	UIImageView *level21;
	UIImageView *level22;
	UIImageView *level23;
	UIImageView *level24;
	UIImageView *level25;
	UIImageView *level26;
	UIImageView *level27;
	UIImageView *level28;
	UIImageView *level29;
	UIImageView *level30;
	
	
	CGPoint buttonCenter;
	CGPoint titleCenter;
	CGPoint behindButtonCenter;
	CGPoint backGroundCenter;
	
	
}

@property (nonatomic, retain) UIImageView *zoomBack;
@property (nonatomic, retain) UIImageView *backGroundMenu;
@property (nonatomic, retain) UIImageView *backGround;


- (IBAction)loadGameBoard:(id)sender;
- (IBAction)loadTutorial:(id)sender;
- (IBAction)loadOptions:(id)sender;
-(IBAction)loadLevelSelect:(id)sender;

-(void)animateButtons;
-(void)restoreCenters;
-(void)animateBoard;
-(void)actualLoadGameBoard;


@end


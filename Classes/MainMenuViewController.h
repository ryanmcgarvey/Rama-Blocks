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
#import "Profile.h"
#import "Tutorial.h"
#import "Purchase.h"
#import "GameBoardViewController.h"
#import "GameState.h"


@interface MainMenuViewController : UIViewController {
	Options * options;
	Profile * profile;
	Tutorial * tutorial;
	Purchase * purchase;
    GameState * gameState;
    
    IBOutlet UIButton * GameBoardButton;
    IBOutlet UIButton * OptionsButton;
    IBOutlet UIButton * PurchaseButton;
    IBOutlet UIButton * ProfileButton;
    IBOutlet UIButton * TutorialButton;
}

@property (readwrite, assign) Options * options;
@property (readwrite, assign) Profile * profile;
@property (readwrite, assign) Tutorial * tutorial;
@property (readwrite, assign) Purchase * purchase;


- (IBAction)loadGameBoard:(id)sender;
- (IBAction)loadOptions:(id)sender;
- (IBAction)loadProfile:(id)sender;
- (IBAction)loadTutorial:(id)sender;
- (IBAction)loadPurchase:(id)sender;



@end


//
//  LevelSelect.h
//  Rama Blocks
//
//  Created by Ryan McGarvey on 8/9/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameState.h"
#import "GameBoardViewController.h"


@interface LevelSelect : UIViewController {
    
    
    
    IBOutlet UISlider * levelSelect;
    IBOutlet UILabel * levelLabel;
    IBOutlet UIButton * PlayLevelButton;
    IBOutlet UIButton * returnButton;
    IBOutlet UITextView * recapText;
    GameState * gameState;
}


- (IBAction)returnToMenu;
-(IBAction)ChangeLevel;
-(IBAction)PlayLevel;
@end

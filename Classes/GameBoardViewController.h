//
//  GameBoardViewController.h
//  RumbaBlocks
//
//  Created by Johnny Moralez on 6/23/09.
//  Copyright 2009 Simplical, LLC. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/NSTimer.h>
#import "Shape.h"
#import "ItemPair.h"
#import "ItemCollection.h"
#import "GlobalDefines.h"
#import "Cell.h"
#import "Level.h"
#import "GameState.h"
#import "Options.h"



@interface GameBoardViewController : UIViewController{
	IBOutlet UIImageView *backGround;
    IBOutlet UIButton * buttonMenu;
    IBOutlet UIView * menuView;
    IBOutlet UIButton * buttonResume;
    IBOutlet UIButton * buttonOptions;
    IBOutlet UIButton * buttonMainMenu;
    IBOutlet UILabel * attemptsString;
    
	ItemPair * SpawnedPair;
	ItemCollection * itemCollection;
	NSTimer *TouchTimer;
    UIDevice * CurrentDevice;
    Level * currentLevel;
    SoundEffects * audio;
    GameState * gameState;
}
@property (nonatomic, retain) UIButton * buttonMenu;
@property (nonatomic, retain) UIButton * buttonResume;
@property (nonatomic, retain) UIButton * buttonOptions;
@property (nonatomic, retain) UIButton * buttonMainMenu;
@property (nonatomic, retain) UIView * menuView;
@property (nonatomic, retain) UILabel * attemptsString;

-(void)resetTap:(NSTimer *)timer;
-(void)SpawnShapes;
-(void)ResetShapePair:(ItemPair *)pair;
-(void)didRotate:(NSNotification *)notification;

-(IBAction)ClickButtonMenu;
-(IBAction)ClickButtonResume;
-(IBAction)ClickButtonOptions;
-(IBAction)ClickButtonMainMenu;





@end

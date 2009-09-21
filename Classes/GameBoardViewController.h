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
#import "BoardState.h"
#import "Options.h"
#import "SoundEffects.h"
#import "LevelStatistics.h"
#import "PowerItem.h"



@interface GameBoardViewController : UIViewController{
	
    IBOutlet UIView * menuView;
    IBOutlet UIImageView *backGround;
	IBOutlet UIImageView *lockSet;
    UIImageView *lockFeedBackA;
	UIImageView *lockFeedBackB;
	UIImageView *lockFeedBackC;
    UIImageView * guessView;
    IBOutlet UIImageView *discardCountImage;
	IBOutlet UIImageView *bombCountImage;
	IBOutlet UIImageView *reshuffleCountImage;
	IBOutlet UIImageView *upgradeCountImage;
	
	
    IBOutlet UILabel * attemptsString;
	IBOutlet UILabel * scoreLabel;
    
    IBOutlet UIButton * buttonResume;
    IBOutlet UIButton * buttonOptions;
    IBOutlet UIButton * buttonMainMenu;
    IBOutlet UIButton * buttonMenu;
    IBOutlet UIButton * checkLock;
    IBOutlet UIButton * closeLock;
	IBOutlet UIButton * checkRecipe;
	
    IBOutlet UIButton * discardButton;
	IBOutlet UIButton * bombButton;
	IBOutlet UIButton * reshuffleButton;
	IBOutlet UIButton * upgradeButton;
	
    UIDevice * CurrentDevice;
    
    NSMutableArray * experimentArray;
	
	Shape * touchedGuessItemShape;
	
	Shape * shapeA;
	Shape * shapeB;
	Shape * shapeC;
	
	Cell * cellA;
	Cell * cellB;
	Cell * cellC;
	
	ItemPair * SpawnedPair;
	ItemPair * nextPair;
	ItemCollection * itemCollection;
    Level * currentLevel;
    SoundEffects * audio;
    GameState * gameState;
	DrawingView *drawingView; 
	PowerItem *powerItem;

	
	CGFloat touchDistanceToItemC;
	
	CGPoint startTouchPosition;
	CGPoint currentTouchPosition;
	CGPoint menuViewCenter;
    
    CFTimeInterval startTime;
    NSTimer *TouchTimer;
	
	CGAffineTransform spawnedShapeRotateTransform;
	
	int discardCount;
	int bombCount;
	int reshuffleCount;
	int upgradeCount;
	
	int transformCount;
	int score;
	
	int spawnX;
	int spawnY;
	int spawnNextX;
	int spawnNextY;
	int rightPix;
	int upPix;
	
    BOOL lockMode;
	
}
//@property (readwrite, assign)int countDown;
@property (readwrite, assign)int discardCount;
@property (readwrite, assign)int transformCount;
@property (readwrite, assign)int reshuffleCount;
@property (readwrite, assign)int upgradeCount;
@property (readwrite, assign)int score;

@property (nonatomic, retain) UIButton * buttonMenu;
@property (nonatomic, retain) UIButton * buttonResume;
@property (nonatomic, retain) UIButton * buttonOptions;
@property (nonatomic, retain) UIButton * buttonMainMenu;
@property (nonatomic, retain) UIButton * checkLock;
@property (nonatomic, retain) UIButton * closeLock;
@property (nonatomic, retain) UIButton * checkRecipe;
@property (nonatomic, retain) UIButton * discardButton;
@property (nonatomic, retain) UIButton * bombButton;
@property (nonatomic, retain) UIButton * reshuffleButton;
@property (nonatomic, retain) UIButton * upgradeButton;

@property (nonatomic, retain) UIView * menuView;
@property (readwrite, retain) DrawingView *drawingView;

@property (nonatomic, retain) UILabel * attemptsString;
@property (nonatomic, retain) UILabel * scoreLabel;

@property (readwrite, assign) CGPoint startTouchPosition;
@property (readwrite, assign) CGPoint currentTouchPosition;
@property (readwrite, assign) CGFloat touchDistanceToItemC;

@property (readwrite, assign)CGAffineTransform spawnedShapeRotateTransform;




-(void)resetTap:(NSTimer *)timer;
-(void)SpawnShapes;
-(void)SpawnShapes:(Shape *)ItemA : (Shape *)ItemB;
-(void)ResetShapePair:(ItemPair *)pair;
-(void)didRotate:(NSNotification *)notification;
-(void)SaveState;

-(void)setButtons;

-(CGFloat)isTouchWithinRange:(CGPoint)touch from:(CGPoint)center;

-(IBAction)ClickReset;
-(IBAction)ClickButtonMenu;
-(IBAction)ClickButtonResume;
-(IBAction)ClickButtonOptions;
-(IBAction)ClickButtonMainMenu;
-(IBAction)ClickButtonLockTab;
-(IBAction)ClickButtonCloseLockTab;
-(IBAction)ClickButtonCheckRecipe;
-(IBAction)ClickButtonDiscard;
-(IBAction)ClickButtonUpgrade;
-(IBAction)ClickButtonBomb;
-(IBAction)ClickButtonShuffle;





@end

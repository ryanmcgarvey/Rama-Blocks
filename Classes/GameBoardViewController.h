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
	IBOutlet UIView * statsView;
    IBOutlet UIImageView *backGround;
	IBOutlet UIImageView *discardCountImage;
	IBOutlet UIImageView *bombCountImage;
	IBOutlet UIImageView *reshuffleCountImage;
	IBOutlet UIImageView *upgradeCountImage;
	IBOutlet UIImageView *lockSet;
	
	UIImageView *backGroundGrid;
	UIImageView *backGroundTransition;
	UIImageView *backGroundStars;
	UIImageView *backGroundCloudsA;
	UIImageView *backGroundCloudsB;
    UIImageView *lockFeedBackA;
	UIImageView *lockFeedBackB;
	UIImageView *lockFeedBackC;
    UIImageView * guessView;
	UIImageView * powerBack;
    
    IBOutlet UILabel * attemptsString;
	IBOutlet UILabel * scoreLabel;
	
	IBOutlet UILabel * currentLevelLabel;
	IBOutlet UILabel * movesLabel;
    IBOutlet UILabel * transformsLabel;
	IBOutlet UILabel * timeLabel;
	IBOutlet UILabel * recipeLabel;
	IBOutlet UILabel * scorePopUp;
	
    IBOutlet UIButton * buttonResume;
    IBOutlet UIButton * buttonOptions;
    IBOutlet UIButton * buttonMainMenu;
    IBOutlet UIButton * buttonMenu;
    IBOutlet UIButton * checkLock;
    IBOutlet UIButton * closeLock;
	IBOutlet UIButton * lockButton;
	IBOutlet UIButton * checkRecipe;
	
    IBOutlet UIButton * discardButton;
	IBOutlet UIButton * bombButton;
	IBOutlet UIButton * reshuffleButton;
	IBOutlet UIButton * upgradeButton;
	
    UIDevice * CurrentDevice;
    NSString * backGroundToLoad;
	
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
	Gravity gravity;
	
	CGPoint startTouchPosition;
    
    CFTimeInterval startTime;
    NSTimer *TouchTimer;
	NSTimer *movingTimer;
	
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
	
    BOOL lockMode;
	
	BOOL didShuffle;
	
}
//@property (readwrite, assign)int countDown;
@property (readwrite, assign)int discardCount;
@property (readwrite, assign)int transformCount;
@property (readwrite, assign)int reshuffleCount;
@property (readwrite, assign)int upgradeCount;
@property (readwrite, assign)int score;

@property (readwrite, retain) DrawingView *drawingView;

@property (readwrite, assign)CGAffineTransform spawnedShapeRotateTransform;




-(void)resetTap:(NSTimer *)timer;
-(void)SpawnShapes;
-(void)SpawnShapes:(Shape *)ItemA : (Shape *)ItemB;
-(void)ResetShapePair:(ItemPair *)pair;
-(void)didRotate:(NSNotification *)notification;
-(void)SaveState;

-(void)setButtons;

-(void)moveCloudsOne;
-(void)moveCloudsTwo;
-(void)moveCloudsThree;
-(void)moveCloudsFour;

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

-(void)checkLevel;
-(void)changeLevel;
-(void)animateLevelChange;

-(void)removeStats;
-(BOOL)subtractScoreForRecipe;
//HELPERS
-(void) SetupBackground:(int)difficulty;
-(void) SetupUI;

-(void)changeScore:(Shape *) item;



@end

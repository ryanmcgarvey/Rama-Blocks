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
    IBOutlet UIImageView *lockFeedBackA;
	IBOutlet UIImageView *lockFeedBackB;
	IBOutlet UIImageView *lockFeedBackC;
    UIImageView * guessView;
    
    IBOutlet UILabel * attemptsString;
	IBOutlet UILabel * timeToDrop;
    
    IBOutlet UIButton * buttonResume;
    IBOutlet UIButton * buttonOptions;
    IBOutlet UIButton * buttonMainMenu;
    IBOutlet UIButton * buttonMenu;
	IBOutlet UIButton * discard;
    IBOutlet UIButton * checkLock;
    IBOutlet UIButton * closeLock;
	
    UIDevice * CurrentDevice;
    
    NSMutableArray * experimentArray;
	
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
	
	CGAffineTransform spawnedShapeRotateTransformA;
	
	int discardCount;
	int transformCount;
	
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

@property (nonatomic, retain) UIButton * buttonMenu;
@property (nonatomic, retain) UIButton * buttonResume;
@property (nonatomic, retain) UIButton * buttonOptions;
@property (nonatomic, retain) UIButton * buttonMainMenu;
@property (nonatomic, retain) UIButton * discard;
@property (nonatomic, retain) UIButton * checkLock;
@property (nonatomic, retain) UIButton * closeLock;

@property (nonatomic, retain) UIView * menuView;
@property (readwrite, retain) DrawingView *drawingView;

@property (nonatomic, retain) UILabel * attemptsString;
@property (nonatomic, retain) UILabel * timeToDrop;

@property (readwrite, assign) CGPoint startTouchPosition;
@property (readwrite, assign) CGPoint currentTouchPosition;
@property (readwrite, assign) CGFloat touchDistanceToItemC;

@property (readwrite, assign)CGAffineTransform spawnedShapeRotateTransformA;




-(void)resetTap:(NSTimer *)timer;
-(void)SpawnShapes;
-(void)SpawnShapes:(Shape *)ItemA : (Shape *)ItemB;
-(void)ResetShapePair:(ItemPair *)pair;
-(void)didRotate:(NSNotification *)notification;
-(void)SaveState;

-(CGFloat)isTouchWithinRange:(CGPoint)touch from:(CGPoint)center;

-(IBAction)ClickReset;
-(IBAction)ClickButtonMenu;
-(IBAction)ClickButtonResume;
-(IBAction)ClickButtonOptions;
-(IBAction)ClickButtonMainMenu;
-(IBAction)ClickButtonLockTab;
-(IBAction)ClickButtonCloseLockTab;
-(IBAction)discardPiece;





@end

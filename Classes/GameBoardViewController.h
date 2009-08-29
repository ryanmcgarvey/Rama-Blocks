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
	IBOutlet UIImageView *backGround;
	IBOutlet UIImageView *lockSet;
    IBOutlet UIButton * buttonMenu;
    IBOutlet UIView * menuView;
    IBOutlet UIButton * buttonResume;
    IBOutlet UIButton * buttonOptions;
    IBOutlet UIButton * buttonMainMenu;
	IBOutlet UIButton * discard;
    IBOutlet UILabel * attemptsString;
	IBOutlet UILabel * timeToDrop;
	
    NSMutableArray * experimentArray;
	
	ItemPair * SpawnedPair;
	ItemCollection * itemCollection;
	NSTimer *TouchTimer;
    UIDevice * CurrentDevice;
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
	
	CGAffineTransform spawnedShapeRotateTransformA;
	
	int discardCount;
	int transformCount;
	
}
//@property (readwrite, assign)int countDown;
@property (readwrite, assign)int discardCount;
@property (readwrite, assign)int transformCount;
@property (nonatomic, retain) UIButton * buttonMenu;
@property (nonatomic, retain) UIButton * buttonResume;
@property (nonatomic, retain) UIButton * buttonOptions;
@property (nonatomic, retain) UIButton * buttonMainMenu;
@property (nonatomic, retain) UIButton * discard;
@property (nonatomic, retain) UIView * menuView;
@property (nonatomic, retain) UILabel * attemptsString;
@property (nonatomic, retain) UILabel * timeToDrop;
@property (readwrite, retain) DrawingView *drawingView;
@property (readwrite, assign) CGPoint startTouchPosition;
@property (readwrite, assign) CGPoint currentTouchPosition;
@property (readwrite, assign) CGFloat touchDistanceToItemC;
@property (readwrite, assign)CGAffineTransform spawnedShapeRotateTransformA;




-(void)resetTap:(NSTimer *)timer;
-(void)SpawnShapes;
-(void)ResetShapePair:(ItemPair *)pair;
-(void)didRotate:(NSNotification *)notification;
-(void)SaveState;

-(CGFloat)isTouchWithinRange:(CGPoint)touch from:(CGPoint)center;

-(IBAction)ClickReset;
-(IBAction)ClickButtonMenu;
-(IBAction)ClickButtonResume;
-(IBAction)ClickButtonOptions;
-(IBAction)ClickButtonMainMenu;
-(IBAction)discardPiece;





@end

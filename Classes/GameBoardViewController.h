//
//  GameBoardViewController.h
//  RumbaBlocks
//
//  Created by Johnny Moralez on 6/23/09.
//  Copyright 2009 Simplical, LLC. All rights reserved.
//

@class ShapeCollection;

#import <UIKit/UIKit.h>
#import <Foundation/NSTimer.h>
#import "Shape.h"
#import "ItemPair.h"
#import "ItemCollection.h"
#import "GlobalDefines.h"
#import "Cell.h"
#import "Level.h"


@interface GameBoardViewController : UIViewController{
	IBOutlet UIImageView *grid;
	ItemPair * SpawnedPair;
	ItemCollection * itemCollection;
	NSTimer *TouchTimer;

    UIDevice * CurrentDevice;
    Level * currentLevel;
}


-(void)resetTap:(NSTimer *)timer;
-(void)SpawnShapes;
-(void)ResetShapePair:(ItemPair *)pair;
-(void)didRotate:(NSNotification *)notification;






@end

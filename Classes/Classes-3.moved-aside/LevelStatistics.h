//
//  LevelStatistics.h
//  Rama Blocks
//
//  Created by Chad Gapac on 8/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class GameState;

@interface LevelStatistics :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * Level;
@property (nonatomic, retain) NSNumber * timeToComplete;
@property (nonatomic, retain) NSNumber * numberOfMoves;
@property (nonatomic, retain) NSNumber * numerOfAttempts;
@property (nonatomic, retain) NSNumber * numberOfTransforms;
@property (nonatomic, retain) GameState * owningGameState;

@end




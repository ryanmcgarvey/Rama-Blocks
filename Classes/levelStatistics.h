//
//  LevelStatistics.h
//  Rama Blocks
//
//  Created by Ryan McGarvey on 10/1/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import <CoreData/CoreData.h>

@class GameState;

@interface LevelStatistics :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * timeToComplete;
@property (nonatomic, retain) NSNumber * numberOfMoves;
@property (nonatomic, retain) NSNumber * numberOfTransforms;
@property (nonatomic, retain) NSNumber * Level;
@property (nonatomic, retain) NSNumber * numerOfAttempts;
@property (nonatomic, retain) GameState * owningGameState;

@end




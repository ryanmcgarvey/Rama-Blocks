//
//  GameState.h
//  Rama Blocks
//
//  Created by Chad Gapac on 9/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class BoardState;
@class LevelStatistics;

@interface GameState :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * sfxVolume;
@property (nonatomic, retain) NSNumber * currentLevel;
@property (nonatomic, retain) NSNumber * highestLevel;
@property (nonatomic, retain) NSNumber * musicVolume;
@property (nonatomic, retain) BoardState * currentBoard;
@property (nonatomic, retain) NSSet* PlayedLevels;

@end


@interface GameState (CoreDataGeneratedAccessors)
- (void)addPlayedLevelsObject:(LevelStatistics *)value;
- (void)removePlayedLevelsObject:(LevelStatistics *)value;
- (void)addPlayedLevels:(NSSet *)value;
- (void)removePlayedLevels:(NSSet *)value;

@end


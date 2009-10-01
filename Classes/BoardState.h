//
//  BoardState.h
//  Rama Blocks
//
//  Created by Ryan McGarvey on 10/1/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import <CoreData/CoreData.h>

@class GameState;
@class ItemState;

@interface BoardState :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * Active;
@property (nonatomic, retain) NSNumber * timePlayed;
@property (nonatomic, retain) NSNumber * discardCount;
@property (nonatomic, retain) NSNumber * numberOfAttempts;
@property (nonatomic, retain) NSNumber * reshuffleCount;
@property (nonatomic, retain) NSNumber * bombCount;
@property (nonatomic, retain) NSNumber * upgradeCount;
@property (nonatomic, retain) NSNumber * numberOfMovies;
@property (nonatomic, retain) NSNumber * numberOfTransforms;
@property (nonatomic, retain) GameState * owningGameState;
@property (nonatomic, retain) NSSet* items;

@end


@interface BoardState (CoreDataGeneratedAccessors)
- (void)addItemsObject:(ItemState *)value;
- (void)removeItemsObject:(ItemState *)value;
- (void)addItems:(NSSet *)value;
- (void)removeItems:(NSSet *)value;

@end


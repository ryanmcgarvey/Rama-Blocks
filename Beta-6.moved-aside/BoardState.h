//
//  BoardState.h
//  Rama Blocks
//
//  Created by Ryan McGarvey on 8/8/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import <CoreData/CoreData.h>

@class ItemState;
@class ItemState;
@class ItemState;
@class ItemState;
@class GameState;

@interface BoardState :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * Active;
@property (nonatomic, retain) NSSet* LockItems;
@property (nonatomic, retain) ItemState * SpawnItemA;
@property (nonatomic, retain) NSSet* items;
@property (nonatomic, retain) ItemState * SpawnItemB;
@property (nonatomic, retain) GameState * owningGameState;

@end


@interface BoardState (CoreDataGeneratedAccessors)
- (void)addLockItemsObject:(ItemState *)value;
- (void)removeLockItemsObject:(ItemState *)value;
- (void)addLockItems:(NSSet *)value;
- (void)removeLockItems:(NSSet *)value;

- (void)addItemsObject:(ItemState *)value;
- (void)removeItemsObject:(ItemState *)value;
- (void)addItems:(NSSet *)value;
- (void)removeItems:(NSSet *)value;

@end


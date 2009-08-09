//
//  BoardState.h
//  Rama Blocks
//
//  Created by Ryan McGarvey on 8/9/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import <CoreData/CoreData.h>

@class ItemState;
@class GameState;

@interface BoardState :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * Active;
@property (nonatomic, retain) NSSet* items;
@property (nonatomic, retain) GameState * owningGameState;

@end


@interface BoardState (CoreDataGeneratedAccessors)
- (void)addItemsObject:(ItemState *)value;
- (void)removeItemsObject:(ItemState *)value;
- (void)addItems:(NSSet *)value;
- (void)removeItems:(NSSet *)value;

@end


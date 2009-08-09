//
//  BoardState.h
//  Rama Blocks
//
//  Created by Ryan McGarvey on 8/8/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import <CoreData/CoreData.h>

@class GameState;

@interface BoardState :  NSManagedObject  
{
}

@property (nonatomic, retain) NSSet* items;
@property (nonatomic, retain) GameState * owningGameState;

@end


@interface BoardState (CoreDataGeneratedAccessors)
- (void)addItemsObject:(NSManagedObject *)value;
- (void)removeItemsObject:(NSManagedObject *)value;
- (void)addItems:(NSSet *)value;
- (void)removeItems:(NSSet *)value;

@end


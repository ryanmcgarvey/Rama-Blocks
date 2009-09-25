//
//  BoardState.h
//  Rama Blocks
//
//  Created by Chad Gapac on 9/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class GameState;
@class ItemState;

@interface BoardState :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * numberOfAttempts;
@property (nonatomic, retain) NSNumber * numberOfMovies;
@property (nonatomic, retain) NSNumber * numberOfTransforms;
@property (nonatomic, retain) NSNumber * Active;
@property (nonatomic, retain) NSNumber * timePlayed;
@property (nonatomic, retain) GameState * owningGameState;
@property (nonatomic, retain) NSSet* items;

@end


@interface BoardState (CoreDataGeneratedAccessors)
- (void)addItemsObject:(ItemState *)value;
- (void)removeItemsObject:(ItemState *)value;
- (void)addItems:(NSSet *)value;
- (void)removeItems:(NSSet *)value;

@end


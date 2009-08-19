//
//  Profile.h
//  Rama Blocks
//
//  Created by Ryan McGarvey on 8/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class GameState;

@interface Profile :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * Default;
@property (nonatomic, retain) NSSet* savedGames;

@end


@interface Profile (CoreDataGeneratedAccessors)
- (void)addSavedGamesObject:(GameState *)value;
- (void)removeSavedGamesObject:(GameState *)value;
- (void)addSavedGames:(NSSet *)value;
- (void)removeSavedGames:(NSSet *)value;

@end


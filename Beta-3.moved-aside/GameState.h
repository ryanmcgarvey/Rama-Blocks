//
//  GameState.h
//  Rama Blocks
//
//  Created by Ryan McGarvey on 8/8/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface GameState :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * sfxVolume;
@property (nonatomic, retain) NSNumber * currentDifficulty;
@property (nonatomic, retain) NSNumber * musicVolume;
@property (nonatomic, retain) NSManagedObject * currentBoard;

@end




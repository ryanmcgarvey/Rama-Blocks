//
//  Phase.h
//  Rama Blocks
//
//  Created by Ryan McGarvey on 10/10/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Level.h"
#import "ItemCollection.h"

@interface Phase : NSObject {
    Level * level;
    ItemCollection * collection;
}

-(BOOL)CheckPhase;

@end

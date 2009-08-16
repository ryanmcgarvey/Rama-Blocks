//
//  PowerItem.h
//  Rama Blocks
//
//  Created by Ryan McGarvey on 7/29/09.
//  Copyright 2009 Simplical. All rights reserved.
//

@class ItemCollection;


#import <UIKit/UIKit.h>
#import "GameItem.h"
#import "Cell.h"
#import "ItemCollection.h"



@interface PowerItem : GameItem {
	ItemCollection *itemCollection;

}


-(void)useBombItem:(GameItem *)item;
- (void)makeCollection:(ItemCollection *)collection;
-(void)placeAnchor:(GameItem *)item;
-(void)makeAnchor:(GameItem *)item;


@end

//
//  ItemState.h
//  Rama Blocks
//
//  Created by Ryan McGarvey on 8/8/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import <CoreData/CoreData.h>

@class BoardState;

@interface ItemState :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * ItemType;
@property (nonatomic, retain) NSNumber * shapeType;
@property (nonatomic, retain) NSNumber * colorType;
@property (nonatomic, retain) NSNumber * canSeeItem;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSNumber * Column;
@property (nonatomic, retain) NSNumber * Row;
@property (nonatomic, retain) NSNumber * canSeeColor;
@property (nonatomic, retain) BoardState * owningBoardState;

@end




//
//  GameItem.h
//  Rama Blocks
//
//  Created by Ryan McGarvey on 7/29/09.
//  Copyright 2009 Simplical. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GameItem : UIView {
@public;
    	UIImageView *ItemView;
    	int tapped;
    	BOOL IsPaired;
    int Row;
	int Column;
}

-(void)SnapShape:(int)newRow : (int)newColumn;
@end

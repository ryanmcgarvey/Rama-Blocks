//
//  DrawingView.h
//  Rama Blocks
//
//  Created by Chad Gapac on 8/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameItem.h"


@interface DrawingView : GameItem {
	CGPoint circleDrawingPoint;
}

-(CGPoint)makeCirclePoint:(CGPoint)itemA :(CGPoint)itemB;

@end

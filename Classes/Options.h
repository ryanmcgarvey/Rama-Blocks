//
//  Options.h
//  RamaMenu
//
//  Created by Chad Gapac on 7/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@class RumbaBlocksViewController;

#import <UIKit/UIKit.h>


@interface Options : UIViewController {
	
	IBOutlet UISlider *sfxVolume;
	IBOutlet UISlider *musicVolume;
}

@property(nonatomic, retain) IBOutlet UISlider *sfxVolume;
@property(nonatomic, retain) IBOutlet UISlider *musicVolume;



- (IBAction)returnToMenu:(id)sender;
- (IBAction)changeShapeColors;






@end

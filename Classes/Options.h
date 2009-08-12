//
//  Options.h
//  RamaMenu
//
//  Created by Chad Gapac on 7/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@class RumbaBlocksViewController;


#import <UIKit/UIKit.h>
#import "GlobalDefines.h"
#import "GameState.h"


@interface Options : UIViewController {
	
	IBOutlet UISlider *sfxVolume;
	IBOutlet UISlider *musicVolume;
    GameState * gameState;
    
}

@property(nonatomic, retain) IBOutlet UISlider *sfxVolume;
@property(nonatomic, retain) IBOutlet UISlider *musicVolume;


- (IBAction)returnToMenu:(id)sender;
-(IBAction)changeMusicVolume;
-(IBAction)changeSfxVolume;







@end

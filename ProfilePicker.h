//
//  ProfilePicker.h
//  Rama Blocks
//
//  Created by Ryan McGarvey on 8/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameState.h"
#import "Profile.h"


@interface ProfilePicker : UIViewController {
    NSArray * savedGames;
    Profile * profile;
    IBOutlet UIPickerView * picker;
}

@end

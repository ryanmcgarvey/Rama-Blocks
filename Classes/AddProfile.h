//
//  AddProfile.h
//  RumbaBlocks
//
//  Created by Chad Gapac on 7/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Profile.h"


@interface AddProfile : UIViewController {
	IBOutlet UITextField *newPlayer;
}



- (IBAction)addProfile;
-(IBAction)editingEnded:(id)sender;
-(IBAction)startGame:(id)sender;

@end

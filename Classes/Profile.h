//
//  Profile.h
//  RamaMenu
//
//  Created by Chad Gapac on 7/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//



#import <UIKit/UIKit.h>


@interface Profile : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>{
	IBOutlet UIPickerView		*profilePicker;
	NSMutableArray				*profiles;
}

@property(readwrite, assign) IBOutlet UIPickerView		*profilePicker;


-(IBAction)addProfile:(id)sender;
- (IBAction)returnToMenu:(id)sender;
- (void)reloadComponents;



@end

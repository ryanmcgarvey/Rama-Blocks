//
//  Profile.m
//  RamaMenu
//
//  Created by Chad Gapac on 7/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Profile.h"


@implementation Profile
@synthesize profilePicker;


- (id)init
{
	return self;
}


- (void)viewDidLoad {
	[super viewDidLoad];
	[profilePicker reloadAllComponents];
	
}

- (void)reloadComponents{
	[self.profilePicker reloadAllComponents];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
	
	return [profiles count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	
	return [profiles objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

}

-(IBAction)returnToMenu:(id)sender 
{
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction)addProfile:(id)sender 
{
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	[super viewDidLoad];
}


- (void)dealloc {
    [super dealloc];
	[profiles release];
}


@end

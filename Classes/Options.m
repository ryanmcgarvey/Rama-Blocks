//
//  Options.m
//  RamaMenu
//
//  Created by Chad Gapac on 7/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Options.h"


@implementation Options

@synthesize sfxVolume, musicVolume;

- (void)viewDidLoad {

    [super viewDidLoad];
	
}


- (IBAction)returnToMenu:(id)sender 
{
	

	[self dismissModalViewControllerAnimated:YES];
	
	
	
}

- (IBAction)changeShapeColors{
}

	




- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

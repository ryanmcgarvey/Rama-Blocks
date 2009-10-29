//
//  Tutorial.m
//  RamaMenu
//
//  Created by Chad Gapac on 7/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Tutorial.h"


@implementation Tutorial

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSBundle *bundle = [NSBundle mainBundle];
	
	NSString *moviePath = [bundle pathForResource:@"test" ofType:@"m4v"];
	NSURL *movieURL = [[NSURL fileURLWithPath:moviePath] retain];
	MPMoviePlayerController *theMovie = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
	theMovie.scalingMode = MPMovieScalingModeAspectFill;
	
	[theMovie play];
	
}


-(IBAction)returnToMenu:(id)sender 
{
	
	[self dismissModalViewControllerAnimated:YES];
	
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

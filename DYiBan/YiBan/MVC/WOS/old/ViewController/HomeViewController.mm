    //
//  HomeViewController.m
//  splitViewTest
//
//Created by zeng tom on 12-10-8
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "RightViewController.h"
//#import "Static.h"
@implementation HomeViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self.view setBackgroundColor:[UIColor whiteColor]];
    
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

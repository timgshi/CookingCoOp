//
//  TSWalkthroughViewController.m
//  CookingCoOp
//
//  Created by Tim Shi on 3/6/13.
//  Copyright (c) 2013 Tim Shi. All rights reserved.
//

#import "TSWalkthroughViewController.h"

@interface TSWalkthroughViewController ()

@end

@implementation TSWalkthroughViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonPressed:(id)sender {
    [self.delegate walkthroughControllerDidFinish:self];
}

@end

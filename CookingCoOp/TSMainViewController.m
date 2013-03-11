//
//  TSViewController.m
//  CookingCoOp
//
//  Created by Tim Shi on 3/3/13.
//  Copyright (c) 2013 Tim Shi. All rights reserved.
//

#import "TSMainViewController.h"

#import "TSWalkthroughViewController.h"

@interface TSMainViewController () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, TSWalkthroughDelegate>

@end

@implementation TSMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.trackedViewName = @"Main View";
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![PFUser currentUser]) {
        PFLogInViewController *logInVC = [[PFLogInViewController alloc] init];
        logInVC.fields = PFLogInFieldsUsernameAndPassword
                        | PFLogInFieldsLogInButton
                        | PFLogInFieldsSignUpButton
                        | PFLogInFieldsPasswordForgotten
                        | PFLogInFieldsDismissButton;
        logInVC.delegate = self;
        logInVC.signUpController.delegate = self;
        [self.navigationController presentViewController:logInVC animated:YES completion:^{
            
        }];
    } else if (![[PFUser currentUser] objectForKey:@"hasSeenTutorial"]) {
        [self performSegueWithIdentifier:@"StartWalkthrough" sender:self];
    }
    if ([PFUser currentUser]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleDone target:self action:@selector(logOutPressed:)];
    }
}

- (void)logOutPressed:(id)sender {
    [PFUser logOut];
    PFLogInViewController *logInVC = [[PFLogInViewController alloc] init];
    logInVC.fields = PFLogInFieldsUsernameAndPassword
    | PFLogInFieldsLogInButton
    | PFLogInFieldsSignUpButton
    | PFLogInFieldsPasswordForgotten
    | PFLogInFieldsDismissButton;
    logInVC.delegate = self;
    logInVC.signUpController.delegate = self;
    [self.navigationController presentViewController:logInVC animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [[segue destinationViewController] setDelegate:self];
}

- (void)walkthroughControllerDidFinish:(TSWalkthroughViewController *)controller {
    [[PFUser currentUser] setObject:[NSNumber numberWithBool:YES] forKey:@"hasSeenTutorial"];
    [[PFUser currentUser] saveInBackground];
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

@end

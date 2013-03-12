//
//  TSCreateMealViewController.m
//  CookingCoOp
//
//  Created by Tim Shi on 3/11/13.
//  Copyright (c) 2013 Tim Shi. All rights reserved.
//

#import "TSCreateMealViewController.h"

@interface TSCreateMealViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *dishTextField;
@property (strong, nonatomic) IBOutlet UITextField *thankfulTextField;

@end

@implementation TSCreateMealViewController

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
	[self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addButtonPressed:(id)sender {
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect frame = self.view.frame;
    CGRect keyboard = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    frame.origin.y -= keyboard.size.height;
    frame.origin.y += 20;
    [UIView animateWithDuration:[[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.frame = frame;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    [UIView animateWithDuration:[[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.frame = frame;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.dishTextField) {
        [self.thankfulTextField becomeFirstResponder];
    } else if (textField == self.thankfulTextField) {
        [self.thankfulTextField resignFirstResponder];
    }
    return YES;
}

- (void)viewTapped {
    [self.dishTextField resignFirstResponder];
    [self.thankfulTextField resignFirstResponder];
}

@end

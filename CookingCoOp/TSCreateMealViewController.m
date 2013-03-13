//
//  TSCreateMealViewController.m
//  CookingCoOp
//
//  Created by Tim Shi on 3/11/13.
//  Copyright (c) 2013 Tim Shi. All rights reserved.
//

#import "TSCreateMealViewController.h"

#import "TSMealDetailViewController.h"

@interface TSCreateMealViewController () <UINavigationControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *dishTextField;
@property (strong, nonatomic) IBOutlet UITextField *thankfulTextField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;

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
    self.addButton.enabled = (self.dishTextField.text.length > 0) && (self.thankfulTextField.text.length > 0);
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
    } else {
        [self saveMeal];
    }
}

- (void)saveMeal {
    NSDictionary *data = @{@"name": self.dishTextField.text,
                           @"thankful": self.thankfulTextField.text,
                           @"chef": [PFUser currentUser]};
    PFObject *obj = [PFObject objectWithClassName:@"Meal"
                                       dictionary:data];
    [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        TSMealDetailViewController *mealDetail = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"MealDetailVC"];
        mealDetail.meal = obj;
        [self.delegate createMealViewController:self didCreateMealVC:mealDetail];
    }];
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

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.addButton.enabled = (self.dishTextField.text.length > 0) && (self.thankfulTextField.text.length > 0);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.addButton.enabled = (self.dishTextField.text.length > 0) && (self.thankfulTextField.text.length > 0);
    return YES;
}

- (void)viewTapped {
    [self.dishTextField resignFirstResponder];
    [self.thankfulTextField resignFirstResponder];
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [self saveMeal];
    }];
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

- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        NSArray *buttonTitles;
        UIActionSheet *actionSheet;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            actionSheet = [[UIActionSheet alloc]
                              initWithTitle:@"Please add a profile picture."
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              destructiveButtonTitle:nil
                              otherButtonTitles:@"From Camera",@"From Photo Library", nil];
        } else {
            actionSheet = [[UIActionSheet alloc]
                           initWithTitle:@"Please add a profile picture."
                           delegate:self
                           cancelButtonTitle:@"Cancel"
                           destructiveButtonTitle:nil
                           otherButtonTitles:@"From Photo Library", nil];
        }
        [actionSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
        [actionSheet showInView:self.view];
    }];
}

- (void)displayImagePickerWithSource:(UIImagePickerControllerSourceType)src;
{
    if(![UIImagePickerController isSourceTypeAvailable:src]) {
        src = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setSourceType:src];
    [picker setDelegate:self];
    [picker setAllowsEditing:YES];
    [self presentViewController:picker animated:YES completion:^{
    }];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;
{
    switch (buttonIndex) {
        case 0:
            [self displayImagePickerWithSource:UIImagePickerControllerSourceTypeCamera];
            break;
        case 1:
            [self displayImagePickerWithSource:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
        case 2:
            break;
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        UIImage *image = info[UIImagePickerControllerEditedImage];
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [[PFUser currentUser] setObject:imageFile forKey:@"profilePicture"];
            [[PFUser currentUser] saveInBackground];
        } progressBlock:^(int percentDone) {
            // Update your progress spinner here. percentDone will be between 0 and 100.
        }];
        [self saveMeal];
    }];
}

//Tells the delegate that the user cancelled the pick operation.
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{
        [self presentViewController:picker animated:YES completion:NULL];
    }];
}

@end

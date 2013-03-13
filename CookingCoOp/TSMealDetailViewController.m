//
//  TSMealDetailViewController.m
//  CookingCoOp
//
//  Created by Tim Shi on 3/11/13.
//  Copyright (c) 2013 Tim Shi. All rights reserved.
//

#import "TSMealDetailViewController.h"

@interface TSMealDetailViewController () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *dishLabel;
@property (strong, nonatomic) IBOutlet UILabel *thankfulLabel;
@property (strong, nonatomic) IBOutlet UITextField *whenTextField;
@property (strong, nonatomic) IBOutlet UITextField *whereTextField;
@property (strong, nonatomic) IBOutlet UITextField *countTextField;
@property (strong, nonatomic) IBOutlet UITextField *whoTextField;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;
@property (strong, nonatomic) UIPickerView *communityPicker;
@property (strong, nonatomic) NSArray *communities;

@end

@implementation TSMealDetailViewController

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
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventAllEvents];
    datePicker.minimumDate = [NSDate date];
    self.whenTextField.inputView = datePicker;
    self.communityPicker = [[UIPickerView alloc] init];
    self.communityPicker.delegate = self;
    self.communityPicker.dataSource = self;
    self.communityPicker.showsSelectionIndicator = YES;
    self.whoTextField.inputView = self.communityPicker;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self updateView];
    PFQuery *query = [PFQuery queryWithClassName:@"Community"];
    [query whereKey:@"members" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.communities = objects;
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.whereTextField.text.length > 0) [self.meal setObject:self.whereTextField.text forKey:@"where"];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    if(self.countTextField.text.length > 0) [self.meal setObject:[formatter numberFromString:self.countTextField.text] forKey:@"maxAttendees"];
    [self.meal saveInBackground];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateView {
    if (self.meal) {
        if ([[PFUser currentUser] objectForKey:@"profilePicture"]) {
            PFFile *profImage = [[PFUser currentUser] objectForKey:@"profilePicture"];
            [profImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                self.profileImageView.image = [UIImage imageWithData:data];
            }];
        }
        self.dishLabel.text = [self.meal objectForKey:@"name"];
        self.thankfulLabel.text = [self.meal objectForKey:@"thankful"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        NSDate *mealDate = ([self.meal objectForKey:@"mealDate"]) ? [self.meal objectForKey:@"mealDate"] : [NSDate date];
        if ([self.meal objectForKey:@"mealDate"]) self.whenTextField.text = [formatter stringFromDate:mealDate];
        ((UIDatePicker *)self.whenTextField.inputView).date = mealDate;
        self.whereTextField.text = [self.meal objectForKey:@"where"];
        if([self.meal objectForKey:@"maxAttendees"]) self.countTextField.text = [NSString stringWithFormat:@"%@", [self.meal objectForKey:@"maxAttendees"]];
        self.whoTextField.text = [[self.meal objectForKey:@"community"] objectForKey:@"name"];
        if ([self.meal objectForKey:@"community"]) {
            NSInteger index = [self.communities indexOfObject:[self.meal objectForKey:@"community"]];
            [self.communityPicker selectRow:index inComponent:0 animated:NO];
        }
        if ([[[self.meal objectForKey:@"chef"] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(trashButtonPressed)];
        } else {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"RSVP" style:UIBarButtonItemStyleBordered target:self action:@selector(rsvpButtonPressed)];
            if ([[self.meal objectForKey:@"attendees"] containsObject:[PFUser currentUser]]) {
                self.navigationItem.rightBarButtonItem.tintColor = [UIColor blueColor];
            } else {
                self.navigationItem.rightBarButtonItem.tintColor = [UIColor grayColor];
            }
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    BOOL editable = ([PFUser currentUser]) && ([[[self.meal objectForKey:@"chef"] objectId] isEqualToString:[[PFUser currentUser] objectId]]);
    return editable;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)trashButtonPressed {
    [self.meal deleteInBackground];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)rsvpButtonPressed {
    NSMutableArray *attendees = [[self.meal objectForKey:@"attendees"] mutableCopy];
    if ([attendees containsObject:[PFUser currentUser]]) {
        [attendees removeObject:[PFUser currentUser]];
        [self.meal setObject:attendees forKey:@"attendees"];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor grayColor];
    } else {
        [attendees addObject:[PFUser currentUser]];
        [self.meal setObject:attendees forKey:@"attendees"];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor blueColor];
    }
    [self.meal saveInBackground];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect frame = self.view.frame;
    CGRect keyboard = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (frame.origin.y == 0) {
        frame.origin.y -= keyboard.size.height;
        frame.origin.y += 45;
    }
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

- (void)viewTapped {
    for (UITextField *field in self.textFields) {
        [field resignFirstResponder];
    }
}

- (void)datePickerValueChanged:(UIDatePicker *)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    self.whenTextField.text = [formatter stringFromDate:[sender date]];
    [self.meal setObject:[sender date] forKey:@"mealDate"];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.communities.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.communities[row] objectForKey:@"name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.whoTextField.text = [self.communities[row] objectForKey:@"name"];
    [self.meal setObject:self.communities[row] forKey:@"community"];
}

@end

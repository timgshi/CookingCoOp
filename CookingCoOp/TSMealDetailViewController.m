//
//  TSMealDetailViewController.m
//  CookingCoOp
//
//  Created by Tim Shi on 3/11/13.
//  Copyright (c) 2013 Tim Shi. All rights reserved.
//

#import "TSMealDetailViewController.h"

@interface TSMealDetailViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *dishLabel;
@property (strong, nonatomic) IBOutlet UILabel *thankfulLabel;
@property (strong, nonatomic) IBOutlet UITextField *whenTextField;
@property (strong, nonatomic) IBOutlet UITextField *whereTextField;
@property (strong, nonatomic) IBOutlet UITextField *countTextField;
@property (strong, nonatomic) IBOutlet UITextField *whoTextField;

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
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.meal) {
        self.dishLabel.text = [self.meal objectForKey:@"name"];
        self.thankfulLabel.text = [self.meal objectForKey:@"thankful"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        self.whenTextField.text = [formatter stringFromDate:[self.meal objectForKey:@"mealDate"]];
        self.whereTextField.text = [self.meal objectForKey:@"where"];
        self.countTextField.text = [NSString stringWithFormat:@"%@", [self.meal objectForKey:@"maxAttendees"]];
        self.whoTextField.text = [[self.meal objectForKey:@"community"] objectForKey:@"name"];
        if ([self.meal objectForKey:@"chef"] == [PFUser currentUser]) {
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    BOOL editable = ([PFUser currentUser]) && ([self.meal objectForKey:@"chef"] == [PFUser currentUser]);
    return editable;
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

@end

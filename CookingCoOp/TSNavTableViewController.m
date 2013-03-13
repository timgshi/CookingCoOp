//
//  TSNavTableViewController.m
//  CookingCoOp
//
//  Created by Tim Shi on 3/11/13.
//  Copyright (c) 2013 Tim Shi. All rights reserved.
//

#import "TSNavTableViewController.h"

@interface TSNavTableViewController ()

@end

@implementation TSNavTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)viewcontrollerIDs {
    return @[@"CommunityNav", @"MealsNav", @"WalkthroughNav"];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        [PFUser logOut];
        [self.revealController resignPresentationModeEntirely:YES
                                                     animated:YES
                                                   completion:NULL];
        return;
    }
    UIViewController *newVC = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:[self viewcontrollerIDs][indexPath.row]];
    [self.revealController setFrontViewController:newVC focusAfterChange:YES completion:NULL];
}

@end

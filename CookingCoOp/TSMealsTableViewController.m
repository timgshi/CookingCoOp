//
//  TSMealsTableViewController.m
//  CookingCoOp
//
//  Created by Tim Shi on 3/11/13.
//  Copyright (c) 2013 Tim Shi. All rights reserved.
//

#import "TSMealsTableViewController.h"

#import "TSCreateMealViewController.h"
#import "TSMealDetailViewController.h"

@interface TSMealsTableViewController () <TSCreateMealDelegate>

@end

@implementation TSMealsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.className = @"Meal";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        self.objectsPerPage = 25;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.className = @"Meal";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        self.objectsPerPage = 25;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Meals";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadObjects];
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.className];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"createdAt"];
    if ([PFUser currentUser]) {
        [query whereKey:@"chef" equalTo:[PFUser currentUser]];
    }
    [query includeKey:@"chef"];
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object
{
    static NSString *cellIdentifier = @"Cell";
    
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell to show todo item with a priority at the bottom
    cell.textLabel.text = [object objectForKey:@"name"];
    cell.detailTextLabel.text = [[object objectForKey:@"chef"] username];
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *meal = [self objectAtIndexPath:indexPath];
    TSMealDetailViewController *mealVC = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"MealDetailVC"];
    mealVC.meal = meal;
    [self.navigationController pushViewController:mealVC animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"addMeal"]) {
        TSCreateMealViewController *vc = (TSCreateMealViewController *)[[segue destinationViewController] topViewController];
        vc.delegate = self;
    }
}

- (void)createMealViewController:(TSCreateMealViewController *)controller didCreateMealVC:(UIViewController *)mealVC {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.navigationController pushViewController:mealVC animated:YES];
    }];
}

- (IBAction)revealButtonPressed:(id)sender {
    [self.parentViewController.revealController showViewController:self.parentViewController.revealController.leftViewController];
}

@end

//
//  TSCommunityTableViewController.m
//  CookingCoOp
//
//  Created by Tim Shi on 3/12/13.
//  Copyright (c) 2013 Tim Shi. All rights reserved.
//

#import "TSCommunityTableViewController.h"

#import "TSCommunityCell.h"

@interface TSCommunityTableViewController ()

@property (nonatomic, strong) PFGeoPoint *curLocation;

@end

@implementation TSCommunityTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.className = @"Community";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        self.objectsPerPage = 25;
//        [self.tableView registerClass:[TSCommunityCell class] forCellReuseIdentifier:@"CommunityCell"];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.className = @"Community";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        self.objectsPerPage = 25;
//        [self.tableView registerClass:[TSCommunityCell class] forCellReuseIdentifier:@"CommunityCell"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Communities";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            self.curLocation = geoPoint;
//            [self loadObjects];
//            NSArray *names = @[@"Escondido Village Foodies", @"Eat Your Vegatables", @"Wine & Diners"];
//            for (NSString *name in names) {
//                PFObject *obj = [PFObject objectWithClassName:self.className];
//                [obj setObject:name forKey:@"name"];
//                [obj setObject:[PFUser currentUser] forKey:@"creator"];
//                [obj setObject:@[[PFUser currentUser]] forKey:@"members"];
//                [obj setObject:geoPoint forKey:@"location"];
//                [obj saveInBackground];
//            }
        }
    }];
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.className];
    if (self.curLocation) {
        [query whereKey:@"location" nearGeoPoint:self.curLocation];
    }
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
//    [query includeKey:@"members"];
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object
{
    static NSString *cellIdentifier = @"CommunityCell";
    
//    TSCommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
//    TSCommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (!cell) {
//        cell = [[TSCommunityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    }
//    cell.community = object;
//    [cell setNeedsLayout];
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }

    return cell;
}

@end

//
//  TSCommunityCell.h
//  CookingCoOp
//
//  Created by Tim Shi on 3/12/13.
//  Copyright (c) 2013 Tim Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSCommunityCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *countLabel;
@property (nonatomic, strong) IBOutletCollection(UIImageView) NSArray *imageViews;

@property (nonatomic, strong) PFObject *community;

@end

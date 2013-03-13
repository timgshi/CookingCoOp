//
//  TSCommunityCell.m
//  CookingCoOp
//
//  Created by Tim Shi on 3/12/13.
//  Copyright (c) 2013 Tim Shi. All rights reserved.
//

#import "TSCommunityCell.h"

@interface TSCommunityCell ()

@end

@implementation TSCommunityCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.community) {
        self.nameLabel.text = [self.community objectForKey:@"name"];
        NSInteger count = ((NSArray *)[self.community objectForKey:@"members"]).count;
        NSString *countString = [NSString stringWithFormat:@"%d member", count];
        if (count > 1) {
            countString = [countString stringByAppendingString:@"s"];
        }
        self.countLabel.text = countString;
        for (int i = 0; i < count && i < self.imageViews.count; i++) {
            UIImageView *imageView = self.imageViews[i];
            PFFile *profImage = [[self.community objectForKey:@"members"][i] objectForKey:@"profilePicture"];
            [profImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                imageView.image = [UIImage imageWithData:data];
            }];
        }
    }
}

@end

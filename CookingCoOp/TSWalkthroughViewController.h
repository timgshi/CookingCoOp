//
//  TSWalkthroughViewController.h
//  CookingCoOp
//
//  Created by Tim Shi on 3/6/13.
//  Copyright (c) 2013 Tim Shi. All rights reserved.
//

#import "GAITrackedViewController.h"

@class TSWalkthroughViewController;

@protocol TSWalkthroughDelegate

- (void)walkthroughControllerDidFinish:(TSWalkthroughViewController *)controller;

@end

@interface TSWalkthroughViewController : GAITrackedViewController

@property (nonatomic, weak) id <TSWalkthroughDelegate> delegate;

@end

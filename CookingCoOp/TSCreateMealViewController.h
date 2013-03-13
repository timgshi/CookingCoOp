//
//  TSCreateMealViewController.h
//  CookingCoOp
//
//  Created by Tim Shi on 3/11/13.
//  Copyright (c) 2013 Tim Shi. All rights reserved.
//

#import "GAITrackedViewController.h"

@class TSCreateMealViewController;

@protocol TSCreateMealDelegate

- (void)createMealViewController:(TSCreateMealViewController *)controller didCreateMealVC:(UIViewController *)mealVC;

@end

@interface TSCreateMealViewController : GAITrackedViewController

@property (nonatomic, weak) id <TSCreateMealDelegate> delegate;

@end

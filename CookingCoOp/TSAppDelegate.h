//
//  TSAppDelegate.h
//  CookingCoOp
//
//  Created by Tim Shi on 3/3/13.
//  Copyright (c) 2013 Tim Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PKRevealController/PKRevealController.h>

@interface TSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PKRevealController *revealController;

@end

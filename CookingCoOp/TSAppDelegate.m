//
//  TSAppDelegate.m
//  CookingCoOp
//
//  Created by Tim Shi on 3/3/13.
//  Copyright (c) 2013 Tim Shi. All rights reserved.
//

#import "TSAppDelegate.h"

#import "TSNavTableViewController.h"

@implementation TSAppDelegate

static NSString * const kCCParseId = @"12MIhHMhshrC2iYfmiGgP8hAPMiwuDg81XfOiEFr";
static NSString * const kCCParseKey = @"NkK06jGJWM4LQEjlb4kOslaX4WStImotIEmeklLP";
static NSString * const kCCTestFlightId = @"0151a3d9-d1cb-45d0-b865-85a91918f482";
static NSString * const kGAIId = @"UA-38985264-1";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:kCCParseId
                  clientKey:kCCParseKey];
    [TestFlight takeOff:kCCTestFlightId];
#ifndef RELEASE
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
#endif
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    [GAI sharedInstance].debug = YES;
    [[GAI sharedInstance] trackerWithTrackingId:kGAIId];
    self.revealController = (PKRevealController *)self.window.rootViewController;
    UINavigationController *frontViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"MealsNav"];
    TSNavTableViewController *leftViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"NavTableVC"];
    [self.revealController setFrontViewController:frontViewController];
    [self.revealController setLeftViewController:leftViewController];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.0 green:0.0 blue:51/255.0 alpha:1.0]];
    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

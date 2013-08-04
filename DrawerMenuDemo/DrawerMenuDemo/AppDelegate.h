//
//  AppDelegate.h
//  DrawerMenuDemo
//
//  Created by Andrew Lister on 8/3/13.
//  Copyright (c) 2013 plasticcube. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ALDrawerViewController.h"

#define DemoAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@property (strong, nonatomic) ALDrawerViewController *containerViewController;


@end

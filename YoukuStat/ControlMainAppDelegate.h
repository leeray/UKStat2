//
//  ControlMainAppDelegate.h
//  YoukuStat
//
//  Created by 李 瑞 on 13-1-26.
//  Copyright (c) 2013年 李 瑞. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NavTabBarController.h"

@class ControlMainViewController;

@interface ControlMainAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ControlMainViewController *viewController;

@property (strong, nonatomic) UINavigationController *navController;

@property (strong, nonatomic) NavTabBarController *tabBarController;

@end

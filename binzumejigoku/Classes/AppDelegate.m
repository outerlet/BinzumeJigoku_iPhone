//
//  AppDelegate.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/29.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "HistoryViewController.h"
#import "SettingViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UITabBarController* tabController = [[UITabBarController alloc] init];
    
    MainViewController* mainController = [[MainViewController alloc] init];
    mainController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:0];
    [tabController addChildViewController:mainController];
    
    HistoryViewController* historyController = [[HistoryViewController alloc] initWithBackgroundType:HistoryBackgroundTypeLaunchImage];
    historyController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:1];
    [tabController addChildViewController:historyController];
    
	SettingViewController* settingController = [[SettingViewController alloc] init];
    settingController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:2];
    [tabController addChildViewController:settingController];
    
    self.window.rootViewController = tabController;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end

//
//  AppDelegate.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/29.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "AppDelegate.h"
#import "ContentsInterface.h"
#import "MainViewController.h"
#import "HistoryViewController.h"
#import "SettingViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
	
	[[ContentsInterface sharedInstance] initialize];
	
	ContentsParser* parser = [[ContentsParser alloc] init];
	parser.delegate = self;
	[parser parse];

    return YES;
}

- (void)parseDidFinished:(BOOL)executed {
	UITabBarController* tabController = [[UITabBarController alloc] init];
	
	// 物語を選択する、メインとなるViewController
	MainViewController* mainController = [[MainViewController alloc] init];
	mainController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:0];
	[tabController addChildViewController:mainController];
	
	// セーブ&ロードを担当するViewController
	HistoryViewController* historyController = [[HistoryViewController alloc] initWithBackgroundType:HistoryBackgroundTypeLaunchImage];
	historyController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:1];
	[tabController addChildViewController:historyController];
	
	// 設定画面を表示するViewController
	SettingViewController* settingController = [[SettingViewController alloc] init];
	settingController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:2];
	[tabController addChildViewController:settingController];
	
	self.window.rootViewController = tabController;
	[self.window makeKeyAndVisible];
}

- (void)parseErrorDidOccurred:(NSError *)error {
	NSLog(@"XML parse error : %@", error);
}

@end

//
//  AppDelegate.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/29.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "AppDelegate.h"
#import "ContentsInterface.h"
#import "MainMenuTabBarController.h"
#import "ContentsSelectViewController.h"
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
	MainMenuTabBarController* tabController = [[MainMenuTabBarController alloc] init];
	
	// 物語を選択する、メインとなるViewController
	ContentsSelectViewController* selectController = [[ContentsSelectViewController alloc] init];
	selectController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"tab_name_story", nil) image:[UIImage imageNamed:@"ic_play.png"] tag:0];
	[tabController addChildViewController:selectController];
	
	// セーブ&ロードを担当するViewController
	HistoryViewController* historyController = [[HistoryViewController alloc] init];
	historyController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"tab_name_load", nil) image:[UIImage imageNamed:@"ic_save.png"] tag:1];
	[tabController addChildViewController:historyController];
	
	// 設定画面を表示するViewController
	SettingViewController* settingController = [[SettingViewController alloc] init];
	settingController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"tab_name_settings", nil) image:[UIImage imageNamed:@"ic_settings.png"] tag:2];
	[tabController addChildViewController:settingController];
	
	tabController.selectedIndex = 0;
	
	self.window.rootViewController = tabController;
	[self.window makeKeyAndVisible];
}

- (void)parseErrorDidOccurred:(NSError *)error {
	NSLog(@"XML parse error : %@", error);
}

@end

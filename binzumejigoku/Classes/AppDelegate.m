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

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
	
	[[ContentsInterface sharedInstance] initialize];
	
    self.window.rootViewController = [[MainMenuTabBarController alloc] init];
    [self.window makeKeyAndVisible];

    return YES;
}

@end

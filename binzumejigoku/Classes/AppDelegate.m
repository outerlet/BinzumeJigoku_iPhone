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

NSString* const ENTITY_NAME	= @"BinzumeJigoku";

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

#pragma mark - Core Data

- (NSURL*)applicationDocumentsDirectory {
	return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
												   inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectContext*)managedObjectContext {
	if (_managedObjectContext != nil) {
		return _managedObjectContext;
	}
	
	NSPersistentStoreCoordinator *coordinator = self.persistentCoordinator;
	if (!coordinator) {
		return nil;
	}
	
	_managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
	[_managedObjectContext setPersistentStoreCoordinator:coordinator];
	return _managedObjectContext;
}

- (NSManagedObjectModel*)managedObjectModel {
	if (_managedObjectModel != nil) {
		return _managedObjectModel;
	}
	
	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:ENTITY_NAME withExtension:@"momd"];
	_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	
	return _managedObjectModel;
}

- (NSPersistentStoreCoordinator*)persistentCoordinator {
	if (_persistentStoreCoordinator != nil) {
		return _persistentStoreCoordinator;
	}
	
	_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
	
	NSString* storeName = [NSString stringWithFormat:@"%@.sqlite", ENTITY_NAME];
	NSURL* storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:storeName];
	NSError* error = nil;
	
	if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
												   configuration:nil
															 URL:storeURL
														 options:nil
														   error:&error]) {
		NSMutableDictionary* dict = [NSMutableDictionary dictionary];
		dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
		dict[NSLocalizedFailureReasonErrorKey] = @"There was an error creating or loading the application's saved data.";
		dict[NSUnderlyingErrorKey] = error;
		error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
		
		[[NSFileManager defaultManager] removeItemAtPath:storeURL.absoluteString error:nil];
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
	
	return _persistentStoreCoordinator;
}

@end

//
//  AppDelegate.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/29.
//  Copyright © 2016年 1-Take. All rights reserved.

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#define DEFAULT_FONT_NAME @"Hiragino Mincho ProN W3"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
	@private
	NSManagedObjectContext*			_managedObjectContext;
	NSManagedObjectModel*			_managedObjectModel;
	NSPersistentStoreCoordinator*	_persistentStoreCoordinator;
}

@property (strong, nonatomic)	UIWindow*						window;
@property (nonatomic, readonly)	NSManagedObjectContext*			managedObjectContext;
@property (nonatomic, readonly)	NSManagedObjectModel*			managedObjectModel;
@property (nonatomic, readonly)	NSPersistentStoreCoordinator*	persistentStoreCoordinator;

@end

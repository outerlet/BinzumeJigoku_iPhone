//
//  CoreDataHandler.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/23.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 * CoreData関連の処理を集中して扱うシングルトンクラス
 */
@interface CoreDataHandler : NSObject {
	@private
	NSManagedObjectContext*			_managedObjectContext;
	NSManagedObjectModel*			_managedObjectModel;
	NSPersistentStoreCoordinator*	_persistentStoreCoordinator;
}

@property (nonatomic, readonly)	NSManagedObjectContext*			managedObjectContext;
@property (nonatomic, readonly)	NSManagedObjectModel*			managedObjectModel;
@property (nonatomic, readonly)	NSPersistentStoreCoordinator*	persistentStoreCoordinator;
@property (nonatomic, readonly)	BOOL							contentsInstalled;

/**
 * このクラスのシングルトンインスタンスを得る
 */
+ (CoreDataHandler*)sharedInstance;

/**
 * エンティティ"Contents"に挿入するためのManaged Objectを生成して返す
 */
- (NSManagedObject*)createManagedObject;

/**
 * これまでcreateManagedObjectで生成したManaged Objectをまとめて保存する<br />
 * 保存処理の成否は戻り値で、その際のエラーはerrorに参照渡しで返る
 */
- (BOOL)commit:(NSError**)error;

/**
 * エンティティ"Contents"をクエリして得られるFetched Results Controllerを返す
 */
- (NSFetchedResultsController*)fetch:(NSInteger)sectionIndex;

@end

//
//  CoreDataHandler.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/23.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "CoreDataHandler.h"
#import "Utility.h"

static NSString* const kDataModelName	= @"BinzumeJigoku";
static NSString* const kEntityName		= @"Contents";

@implementation CoreDataHandler

static CoreDataHandler*	_instance = nil;

+ (CoreDataHandler*)sharedInstance {
	@synchronized (self) {
		if (!_instance) {
			_instance = [[CoreDataHandler alloc] init];
		}
	}
	return _instance;
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
	
	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:kDataModelName withExtension:@"momd"];
	_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	
	return _managedObjectModel;
}

- (NSPersistentStoreCoordinator*)persistentCoordinator {
	if (_persistentStoreCoordinator != nil) {
		return _persistentStoreCoordinator;
	}
	
	_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
	
	NSString* storeName = [NSString stringWithFormat:@"%@.sqlite", kDataModelName];
	NSURL* storeURL = [[Utility applicationDocumentDirectory] URLByAppendingPathComponent:storeName];
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

- (NSManagedObject*)createManagedObject {
	return [NSEntityDescription insertNewObjectForEntityForName:kEntityName
										 inManagedObjectContext:self.managedObjectContext];
}

- (BOOL)commit:(NSError**)error {
	return [self.managedObjectContext save:error];
}

- (NSFetchedResultsController*)fetch:(NSInteger)sectionIndex {
	NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:kEntityName];
	request.fetchBatchSize = 20;

	// セクションで絞り込み
	request.predicate = [NSPredicate predicateWithFormat:@"section = %ld", sectionIndex];
	
	// ソート条件指定
	NSSortDescriptor *sectionDescriptor = [[NSSortDescriptor alloc] initWithKey:@"section" ascending:YES];
	NSSortDescriptor *sequenceDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sequence" ascending:YES];
	request.sortDescriptors = @[sectionDescriptor, sequenceDescriptor];
	
	NSFetchedResultsController* fetchedResultsController =
			[[NSFetchedResultsController alloc] initWithFetchRequest:request
												managedObjectContext:self.managedObjectContext
												  sectionNameKeyPath:nil
														   cacheName:@"Master"];
	
	NSError *error = nil;
	if (![fetchedResultsController performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
	
	return fetchedResultsController;
}

- (BOOL)contentsInstalled {
	NSString* storeName = [NSString stringWithFormat:@"%@.sqlite", kDataModelName];
	NSURL* storeURL = [[Utility applicationDocumentDirectory] URLByAppendingPathComponent:storeName];
	
	return [[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]];
}

@end

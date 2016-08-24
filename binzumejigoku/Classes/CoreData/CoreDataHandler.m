//
//  CoreDataHandler.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/23.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "CoreDataHandler.h"

static NSString* const DATA_MODEL_NAME	= @"BinzumeJigoku";
static NSString* const ENTITY_NAME		= @"Contents";

@interface CoreDataHandler ()

@property (nonatomic, readonly) NSURL* applicationDocumentsDirectory;

@end

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
	
	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:DATA_MODEL_NAME withExtension:@"momd"];
	_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	
	return _managedObjectModel;
}

- (NSPersistentStoreCoordinator*)persistentCoordinator {
	if (_persistentStoreCoordinator != nil) {
		return _persistentStoreCoordinator;
	}
	
	_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
	
	NSString* storeName = [NSString stringWithFormat:@"%@.sqlite", DATA_MODEL_NAME];
	NSURL* storeURL = [self.applicationDocumentsDirectory URLByAppendingPathComponent:storeName];
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
	return [NSEntityDescription insertNewObjectForEntityForName:ENTITY_NAME
										 inManagedObjectContext:self.managedObjectContext];
}

- (BOOL)commit:(NSError**)error {
	return [self.managedObjectContext save:error];
}

- (NSFetchedResultsController*)fetch:(NSInteger)sectionIndex {
	NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:ENTITY_NAME];
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

@end

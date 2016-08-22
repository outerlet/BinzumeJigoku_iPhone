//
//  ContentsElement.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/01.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "ContentsElement.h"
#import "NSString+CustomDecoder.h"

@interface ContentsElement ()

@property (nonatomic, readwrite)	NSInteger	section;
@property (nonatomic, readwrite)	NSInteger	sequence;
@property (nonatomic, readwrite)	ChainType	chainType;

- (ChainType)convertToChainType:(NSString*)str;

@end

@implementation ContentsElement

- (id)initWithSection:(NSInteger)section sequence:(NSInteger)sequence attribute:(NSDictionary *)attrs object:(id)obj {
	if (self = [super init]) {
		self.section = section;
		self.sequence = sequence;
		_chainString = [attrs objectForKey:@"chain"];
	}
	return self;
}

- (ContentsType)contentsType {
	return ContentsTypeUnknown;
}

- (NSString*)stringValue {
	return @"SuperClass";
}

- (NSManagedObject*)createManagedObject:(NSFetchedResultsController*)fetchedResultsController {
	NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
	NSEntityDescription *entity = [[fetchedResultsController fetchRequest] entity];
	NSManagedObject* obj = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
	
	[obj setValue:[NSNumber numberWithInteger:self.section] forKey:AttributeNameSection];
	[obj setValue:[NSNumber numberWithInteger:self.sequence] forKey:AttributeNameSequence];
	[obj setValue:[NSString stringWithContentsType:self.contentsType] forKey:AttributeNameType];
	[obj setValue:_chainString forKey:AttributeNameCommon0];
	
	return obj;
}

@end

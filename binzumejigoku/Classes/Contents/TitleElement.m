//
//  TitleElement.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/08.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "TitleElement.h"

@interface TitleElement ()

@property (nonatomic, readwrite) NSString*	title;

@end

@implementation TitleElement

- (id)initWithSection:(NSInteger)section sequence:(NSInteger)sequence attribute:(NSDictionary *)attrs object:(id)obj {
	if (self = [super initWithSection:section sequence:sequence attribute:attrs object:obj]) {
		self.title = (NSString*)obj;
	}
	return self;
}

- (ContentsType)contentsType {
	return ContentsTypeTitle;
}

- (NSString*)stringValue {
	return [NSString stringWithFormat:@"Title : text = %@", self.title];
}

- (NSManagedObject*)createManagedObject:(NSFetchedResultsController *)fetchedResultsController {
	NSManagedObject* obj = [super createManagedObject:fetchedResultsController];
	
	[obj setValue:self.title forKey:AttributeNameText];
	
	return obj;
}

@end

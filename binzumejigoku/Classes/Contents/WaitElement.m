//
//  WaitElement.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/08.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "WaitElement.h"

@interface WaitElement ()

@property (nonatomic, readwrite) double	duration;

@end

@implementation WaitElement

- (id)initWithSection:(NSInteger)section sequence:(NSInteger)sequence attribute:(NSDictionary *)attrs object:(id)obj {
	if (self = [super initWithSection:section sequence:sequence attribute:attrs object:obj]) {
		_durationString = [attrs objectForKey:@"duration"];
	}
	return self;
}

- (id)initWithManagedObject:(NSManagedObject *)managedObject {
	if (self = [super initWithManagedObject:managedObject]) {
		self.duration = [[managedObject valueForKey:AttributeNameValue0] doubleValue];
	}
	return self;
}

- (ContentsType)contentsType {
	return ContentsTypeWait;
}

- (NSString*)stringValue {
	return [NSString stringWithFormat:@"Wait : duration = %f", self.duration];
}

- (NSManagedObject*)createManagedObject {
	NSManagedObject* obj = [super createManagedObject];
	
	[obj setValue:_durationString forKey:AttributeNameValue0];
	
	return obj;
}

@end

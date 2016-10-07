//
//  ContentsElement.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/01.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "ContentsElement.h"
#import "AppDelegate.h"
#import "CoreDataHandler.h"
#import "ImageElement.h"
#import "WaitElement.h"
#import "TitleElement.h"
#import "TextElement.h"
#import "ClearTextElement.h"
#import "NSString+CustomDecoder.h"

@interface ContentsElement ()

@property (nonatomic, readwrite)	NSInteger		section;
@property (nonatomic, readwrite)	NSInteger		sequence;
@property (nonatomic, readwrite)	ChainType		chainType;

@end

@implementation ContentsElement

+ (ContentsElement*)contentsElementWithManagedObject:(NSManagedObject*)managedObject {
	ContentsType type = [[managedObject valueForKey:AttributeNameType] decodeToContentsType];
	id cls = nil;
	switch (type) {
		case ContentsTypeImage:
			cls = [ImageElement class];
			break;
		case ContentsTypeWait:
			cls = [WaitElement class];
			break;
		case ContentsTypeTitle:
			cls = [TitleElement class];
			break;
		case ContentsTypeText:
			cls = [TextElement class];
			break;
		case ContentsTypeClearText:
			cls = [ClearTextElement class];
			break;
		default:
			return nil;
	}
	
	return [[cls alloc] initWithManagedObject:managedObject];
}

- (id)initWithSection:(NSInteger)section sequence:(NSInteger)sequence attribute:(NSDictionary *)attrs object:(id)obj {
	if (self = [super init]) {
		self.section = section;
		self.sequence = sequence;
		_chainString = [attrs objectForKey:@"chain"];
	}
	return self;
}

- (id)initWithManagedObject:(NSManagedObject*)managedObject {
	if (self = [super init]) {
		self.section = [[managedObject valueForKey:AttributeNameSection] integerValue];
		self.sequence = [[managedObject valueForKey:AttributeNameSequence] integerValue];
		self.chainType = [[managedObject valueForKey:AttributeNameCommon0] decodeToChainType];
	}
	return self;
}

- (ContentsType)contentsType {
	return ContentsTypeUnknown;
}

- (NSString*)stringValue {
	return @"SuperClass";
}

- (NSManagedObject*)createManagedObject {
	NSManagedObject* obj = [[CoreDataHandler sharedInstance] createManagedObject];
	
	[obj setValue:[NSNumber numberWithInteger:self.section] forKey:AttributeNameSection];
	[obj setValue:[NSNumber numberWithInteger:self.sequence] forKey:AttributeNameSequence];
	[obj setValue:[NSString stringWithContentsType:self.contentsType] forKey:AttributeNameType];
	[obj setValue:_chainString forKey:AttributeNameCommon0];
	
	return obj;
}

@end

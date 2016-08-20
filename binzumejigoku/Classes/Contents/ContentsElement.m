//
//  ContentsElement.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/01.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "ContentsElement.h"

@interface ContentsElement ()

@property (nonatomic, readwrite) ChainType chainType;

- (ChainType)convertToChainType:(NSString*)str;

@end

@implementation ContentsElement

- (id)initWithAttribute:(NSDictionary*)attrs object:(id)obj {
	if (self = [super init]) {
		self.chainType = [self convertToChainType:[attrs objectForKey:@"chain"]];
	}
	return self;
}

- (ContentsType)contentsType {
	return ContentsTypeUnknown;
}

- (NSString*)stringValue {
	return @"SuperClass";
}

- (ChainType)convertToChainType:(NSString *)str {
	if ([[str lowercaseString] isEqualToString:@"wait"]) {
		return ChainTypeWait;
	} else if ([[str lowercaseString] isEqualToString:@"immediate"]) {
		return ChainTypeImmediate;
	}
	
	return ChainTypeNone;
}

@end

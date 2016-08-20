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

- (id)initWithAttribute:(NSDictionary *)attrs object:(id)obj {
	if (self = [super initWithAttribute:attrs object:obj]) {
		self.duration = [[attrs objectForKey:@"duration"] doubleValue];
	}
	return self;
}

- (ContentsType)contentsType {
	return ContentsTypeWait;
}

- (NSString*)stringValue {
	return [NSString stringWithFormat:@"Wait : duration = %f", self.duration];
}

@end

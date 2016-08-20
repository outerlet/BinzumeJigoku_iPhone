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

- (id)initWithAttribute:(NSDictionary *)attrs object:(id)obj {
	if (self = [super initWithAttribute:attrs object:obj]) {
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

@end

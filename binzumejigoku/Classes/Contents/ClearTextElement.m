//
//  ClearTextElement.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/08.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "ClearTextElement.h"

@implementation ClearTextElement

- (ContentsType)contentsType {
	return ContentsTypeClearText;
}

- (NSString*)stringValue {
	return @"ClearText";
}

@end

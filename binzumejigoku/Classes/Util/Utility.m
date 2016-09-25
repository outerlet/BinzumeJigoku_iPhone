//
//  Utility.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/09/25.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+ (NSURL*)applicationDocumentDirectory {
	return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
												   inDomains:NSUserDomainMask] lastObject];
}

@end

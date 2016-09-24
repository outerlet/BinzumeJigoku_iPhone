//
//  AppDelegate.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/29.
//  Copyright © 2016年 1-Take. All rights reserved.

#import <UIKit/UIKit.h>
#import "ContentsParser.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, ContentsParserDelegate>

@property (strong, nonatomic)	UIWindow*	window;

@end

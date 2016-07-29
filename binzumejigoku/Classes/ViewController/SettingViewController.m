//
//  SettingViewController.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/29.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "SettingViewController.h"

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel* label = [[UILabel alloc] initWithFrame:self.view.bounds];
    label.center = self.view.center;
    label.backgroundColor = [UIColor greenColor];
    label.textColor = [UIColor whiteColor];
    label.text = @"SETTING VIEW CONTROLLER";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

@end

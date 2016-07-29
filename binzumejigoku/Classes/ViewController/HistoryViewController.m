//
//  HistoryViewController.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/29.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "HistoryViewController.h"

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel* label = [[UILabel alloc] initWithFrame:self.view.bounds];
    label.center = self.view.center;
    label.backgroundColor = [UIColor yellowColor];
    label.textColor = [UIColor blackColor];
    label.text = @"HISTORY VIEW CONTROLLER";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

@end

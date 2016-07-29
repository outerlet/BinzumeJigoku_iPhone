//
//  MainViewController.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/29.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "MainViewController.h"
#import "MainPageView.h"

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.pagingEnabled = YES;
    
    CGFloat width = 0.0f;
    
    MainPageView* view1 = [[MainPageView alloc] initWithFrame:_scrollView.bounds text:@"Page - 1" textColor:[UIColor blueColor] backgroundColor:[UIColor whiteColor]];
    [_scrollView addSubview:view1];
    width += view1.frame.size.width;
    
    MainPageView* view2 = [[MainPageView alloc] initWithFrame:_scrollView.bounds text:@"Page - 2" textColor:[UIColor greenColor] backgroundColor:[UIColor whiteColor]];
    CGRect frame2 = view2.frame;
    frame2.origin.x += width;
    view2.frame = frame2;
    [_scrollView addSubview:view2];
    width += view2.frame.size.width;
    
    MainPageView* view3 = [[MainPageView alloc] initWithFrame:_scrollView.bounds text:@"Page - 3" textColor:[UIColor blackColor] backgroundColor:[UIColor cyanColor]];
    CGRect frame3 = view3.frame;
    frame3.origin.x += width;
    view3.frame = frame3;
    [_scrollView addSubview:view3];
    width += view3.frame.size.width;
    
    _scrollView.contentSize = CGSizeMake(width, _scrollView.frame.size.height);
    
    [self.view addSubview:_scrollView];
}

@end

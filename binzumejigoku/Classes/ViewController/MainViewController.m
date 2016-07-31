//
//  MainViewController.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/29.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "MainViewController.h"
#import "ContentsViewController.h"
#import "MainPageView.h"

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray* images = [NSArray arrayWithObjects:
			@"section_name_0", @"section_name_1", @"section_name_2", @"section_name_3", nil];
	NSArray* summaries = [NSArray arrayWithObjects:
			@"section_summary_0", @"section_summary_1", @"section_summary_2", @"section_summary_3", nil];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.pagingEnabled = YES;
    
    CGFloat totalWidth = 0.0f;
 
    for (NSInteger idx = 0 ; idx < images.count ; idx++) {
		NSString* imageName = [NSString stringWithFormat:@"section%ld_%02d.jpg", (long)idx, (idx < 3) ? 1 : 0];
		
		MainPageView* view = [[MainPageView alloc] initWithFrame:_scrollView.bounds withTag:idx];
		view.delegate = self;
		view.title = NSLocalizedString([images objectAtIndex:idx], nil);
		view.summary = NSLocalizedString([summaries objectAtIndex:idx], nil);
		view.backgroundImage = [UIImage imageNamed:imageName];
		
        CGRect frame = view.frame;
        frame.origin.x += totalWidth;
        view.frame = frame;
        
        totalWidth += view.frame.size.width;
        
        [_scrollView addSubview:view];
    }
    
    _scrollView.contentSize = CGSizeMake(totalWidth, self.view.bounds.size.height);
	
    [self.view addSubview:_scrollView];
}

- (void)viewDidTouch:(MainPageView *)view {
	[self presentViewController:[[ContentsViewController alloc] initWithSectionIndex:view.tag]
					   animated:YES
					 completion:nil];
}

@end

//
//  MainViewController.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/29.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "ContentsSelectViewController.h"
#import "ContentsInterface.h"
#import "ContentsViewController.h"
#import "MainPageView.h"
#import "TutorialViewController.h"

static const CGFloat kHeightOfPageControl	= 30.0f;

@implementation ContentsSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray* images = [NSArray arrayWithObjects:
			@"section_name_0", @"section_name_1", @"section_name_2", @"section_name_3", nil];
	NSArray* summaries = [NSArray arrayWithObjects:
			@"section_summary_0", @"section_summary_1", @"section_summary_2", @"section_summary_3", nil];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.pagingEnabled = YES;
	_scrollView.delegate = self;
    
    CGFloat totalWidth = 0.0f;
	NSMutableArray* mainPageViews = [[NSMutableArray alloc] init];

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
		
		[mainPageViews addObject:view];
    }
	
    _scrollView.contentSize = CGSizeMake(totalWidth, self.view.bounds.size.height);
    [self.view addSubview:_scrollView];
	
	_mainPageViews = [NSArray arrayWithArray:mainPageViews];
	
	_pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, self.view.bounds.size.height - self.tabBarController.tabBar.frame.size.height - kHeightOfPageControl, self.view.bounds.size.width, kHeightOfPageControl)];
	_pageControl.backgroundColor = [UIColor clearColor];
	_pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1.0f];
	_pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.4f green:0.4f blue:0.4f alpha:1.0f];
	_pageControl.numberOfPages = _mainPageViews.count;
	_pageControl.currentPage = 0;
	[self.view addSubview:_pageControl];
}

- (void)viewDidTouch:(MainPageView *)view {
	[self presentViewController:[[ContentsViewController alloc] initWithSectionIndex:view.tag]
					   animated:YES
					 completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	for (NSInteger idx = 0 ; idx < _mainPageViews.count ; idx++) {
		MainPageView* view = [_mainPageViews objectAtIndex:idx];
		
		if (scrollView.contentOffset.x == view.frame.origin.x) {
			_pageControl.currentPage = idx;
			break;
		}
	}
}

@end

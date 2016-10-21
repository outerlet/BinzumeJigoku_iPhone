//
//  MainViewController.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/29.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainPageView.h"

/**
 * 読むセクションを選択するためのViewController
 */
@interface ContentsSelectViewController : UIViewController <MainPageViewDelegate, UIScrollViewDelegate> {
    @private
    UIScrollView*   _scrollView;
	UIPageControl*	_pageControl;
	
	NSArray*	_mainPageViews;
}

@end

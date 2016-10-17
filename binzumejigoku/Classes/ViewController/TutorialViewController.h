//
//  TutorialViewController.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/10/14.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverlayViewController.h"

typedef NS_ENUM(NSUInteger, TutorialType) {
	TutorialTypeAll,
	TutorialTypeAboutApplication,
	TutorialTypeHowToControl,
};

@interface TutorialViewController : OverlayViewController <UIScrollViewDelegate> {
	@private
	TutorialType		_tutorialType;
	NSArray<UIView*>*	_tutorialViews;
	UIPageControl*		_pageControl;
}

- (id)initWithTutorialType:(TutorialType)tutorialType;

@end

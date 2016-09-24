//
//  ContentsViewController.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/31.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertControllerHandler.h"

@class TitleView;
@class ContentsTitleView;
@class ContentsImageView;
@class ContentsTextView;
@class ContentsWaitingIndicatorView;

@interface ContentsViewController : UIViewController <AlertControllerHandlerDelegate> {
	@private
	ContentsTitleView*				_titleView;
	ContentsImageView*				_imageView;
	ContentsTextView*				_textView;
	ContentsWaitingIndicatorView*	_indicatorView;
	
	NSArray*	_contents;
	NSInteger	_currentIndex;
	BOOL		_isContentsOngoing;
}

@property (nonatomic, readonly) NSInteger sectionIndex;

/**
 * イニシャライザ<br />
 * セクション番号からインスタンスを生成する
 */
- (id)initWithSectionIndex:(NSInteger)sectionIndex;

@end

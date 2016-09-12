//
//  ContentsViewController.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/31.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentsImageView.h"
#import "RubyTextView.h"

@class TitleView;

@interface ContentsViewController : UIViewController <ContentsImageViewDelegate, RubyTextViewDelegate> {
	@private
	ContentsImageView*	_imageView;
	RubyTextView*		_textView;
	NSArray*			_contents;
	NSInteger			_currentIndex;
}

@property (nonatomic, readonly) NSInteger sectionIndex;

/**
 * イニシャライザ<br />
 * セクション番号からインスタンスを生成する
 */
- (id)initWithSectionIndex:(NSInteger)sectionIndex;

@end

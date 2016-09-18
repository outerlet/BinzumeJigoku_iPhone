//
//  ContentsViewController.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/31.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContentsImageView;
@class ContentsTextView;

@interface ContentsViewController : UIViewController {
	@private
	ContentsImageView*	_imageView;
	ContentsTextView*	_textView;
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

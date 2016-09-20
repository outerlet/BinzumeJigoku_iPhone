//
//  TitleView.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/25.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 章のタイトルを表示するView
 */
@interface ContentsTitleView : UIView {
	@private
	NSArray*		_titleLabels;
	NSTimeInterval	_sequenceTime;
	NSTimeInterval	_labelUnitTime;
	
	void (^_completion)(void);
}

/**
 * タイトルとフォントを設定する
 */
- (void)setTitle:(NSString*)title font:(UIFont*)font;

/**
 * タイトルのアニメーションをdurationに指定した時間で実行する
 */
- (void)startAnimationWithDuration:(NSTimeInterval)duration completion:(void (^)(void))completion;

@end

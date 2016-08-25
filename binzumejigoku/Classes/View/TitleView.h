//
//  TitleView.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/25.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TitleView;

/**
 * TitleViewに関するイベントを捕捉するためのデリゲート
 */
@protocol TitleViewDelegate <NSObject>

/**
 * TitleViewのアニメーションが終了した
 */
- (void)titleViewAnimationDidFinish:(TitleView*)titleView;

@end

/**
 * 章のタイトルを表示するView
 */
@interface TitleView : UIView {
	@private
	NSArray*		_titleLabels;
	NSTimeInterval	_sequenceTime;
	NSTimeInterval	_labelUnitTime;
}

@property (nonatomic)	id<TitleViewDelegate>	delegate;

/**
 * イニシャライザ<br />
 * 指定したサイズ、タイトル文字列、フォントでインスタンスを初期化する
 */
- (id)initWithFrame:(CGRect)frame title:(NSString*)title font:(UIFont*)font;

/**
 * タイトルのアニメーションをdurationに指定した時間で実行する
 */
- (void)startAnimationWithDuration:(NSTimeInterval)duration;

@end

//
//  MainPageView.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/29.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainPageView;

/**
 * このViewをタッチしたとき、つまり章を選択したときのイベントを捕捉するためのデリゲート
 */
@protocol MainPageViewDelegate <NSObject>

/**
 * Viewがタッチされたイベントを捕捉する
 * @param	view	タッチされたView
 */
- (void)viewDidTouch:(MainPageView*)view;

@end

/**
 * 各章の画像やタイトル、概要を表示させるためのView<br />
 * 読む章を選択するMainViewControllerが利用する
 */
@interface MainPageView : UIView {
    @private
	UILabel*		_titleLabel;
	UILabel*		_summaryLabel;
	UIImageView*	_backgroundImageView;
}

/** MainPageViewに対して発生したイベントを捕捉するデリゲート */
@property (nonatomic) id<MainPageViewDelegate>	delegate;

/** 章のタイトル */
@property (nonatomic, readwrite)	NSString*	title;

/** 章の概要 */
@property (nonatomic, readwrite)	NSString*	summary;

/** 章の背景画像 */
@property (nonatomic, readwrite)	UIImage*	backgroundImage;

/**
 * イニシャライザ<br />
 * 与えらえれたバウンディングボックスとタグでこのViewを初期化する
 * @param	frame	バウンディングボックス
 * @param	tag		Viewを識別するためのタグ値
 * @return	初期化されたMainPageView
 */
- (id)initWithFrame:(CGRect)frame withTag:(NSInteger)tag;

@end

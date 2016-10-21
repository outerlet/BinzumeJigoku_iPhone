//
//  TutorialViewController.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/10/14.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverlayViewController.h"

/**
 * チュートリアルの種類を示す列挙値
 */
typedef NS_ENUM(NSUInteger, TutorialType) {
	/** 全てのチュートリアル */
	TutorialTypeAll,
	/** このアプリに関する情報のみ */
	TutorialTypeAboutApplication,
	/** 操作方法のみ */
	TutorialTypeHowToControl,
};

/**
 * チュートリアルを表示するためのViewController
 */
@interface TutorialViewController : OverlayViewController <UIScrollViewDelegate> {
	@private
	TutorialType		_tutorialType;
	NSArray<UIView*>*	_tutorialViews;
	UIPageControl*		_pageControl;
}

/**
 * イニシャライザ<br />
 * どのチュートリアルを表示するか指定してオブジェクトを初期化する
 * @param	tutorialType	チュートリアルの種類
 * @return	初期化されたオブジェクト
 */
- (id)initWithTutorialType:(TutorialType)tutorialType;

@end

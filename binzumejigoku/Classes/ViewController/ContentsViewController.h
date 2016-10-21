//
//  ContentsViewController.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/31.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertControllerHandler.h"
#import "HistorySelectView.h"
#import "GestureHintView.h"
#import "OverlayViewController.h"

@class TitleView;
@class ContentsTitleView;
@class ContentsImageView;
@class ContentsTextView;
@class ContentsWaitingIndicatorView;
@class SaveData;

/**
 * 物語の進行を制御するViewController<br />
 * 本アプリの核となるクラス
 */
@interface ContentsViewController : UIViewController <AlertControllerHandlerDelegate, HistorySelectViewDelegate, GestureHintViewDelegate, OverlayViewControllerDelegate> {
	@private
	ContentsTitleView*				_titleView;
	ContentsImageView*				_imageView;
	ContentsTextView*				_textView;
	ContentsWaitingIndicatorView*	_indicatorView;
	GestureHintView*				_gestureHintView;
	HistorySelectView*				_historyView;
	
	NSArray*	_contents;
	NSInteger	_currentIndex;
	BOOL		_isContentsOngoing;
	
	SaveData*	_targetSaveData;
	
	UILongPressGestureRecognizer*	_gestureRecognizer;
	CGPoint							_longPressBeganPoint;
	CGPoint							_longPressEndPoint;
}

/** 進行中のセクション番号 */
@property (nonatomic, readonly) NSInteger sectionIndex;

/**
 * イニシャライザ<br />
 * セクション番号でインスタンスを初期化する
 * @param	sectionIndex	0から始まるセクション番号
 */
- (id)initWithSectionIndex:(NSInteger)sectionIndex;

/**
 * イニシャライザ<br />
 * セーブデータでインスタンスを初期化する
 * @param	saveData	セーブデータ
 */
- (id)initWithSaveData:(SaveData*)saveData;

@end

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

@class TitleView;
@class ContentsTitleView;
@class ContentsImageView;
@class ContentsTextView;
@class ContentsWaitingIndicatorView;
@class GestureHintView;
@class SaveData;

@interface ContentsViewController : UIViewController <AlertControllerHandlerDelegate, HistorySelectViewDelegate> {
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
	BOOL		_isAdvanceLocked;
	SaveData*	_targetSaveData;
	
	UILongPressGestureRecognizer*	_gestureRecognizer;
	CGPoint							_longPressBeganPoint;
	CGPoint							_longPressEndPoint;
}

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

//
//  HistorySelectView.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/09/28.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SaveData;

/**
 * HistorySelectViewで発生したイベントを捕捉するデリゲート
 */
@protocol HistorySelectViewDelegate <NSObject>

/**
 * HistorySelectViewでセーブデータが選択された
 * @param	saveData	選択されたセーブデータ
 * @param	forSave		セーブ目的ならYES、ロードならNO
 */
- (void)historyDidSelected:(SaveData*)saveData forSave:(BOOL)forSave;

@end

/**
 * セーブデータを選択するためのView
 */
@interface HistorySelectView : UIView {
	@private
	UILabel*			_modeLabel;
	NSArray<UIButton*>*	_historyButtons;
	UIButton*			_closeButton;
	UIButton*			_switchButton;
	BOOL				_isSaveMode;
}

/** セーブモードかどうか。セーブモードならYES、ロードならNO */
@property (nonatomic)	BOOL	saveMode;

/** Viewで発生したイベントを捕捉するデリゲートオブジェクト */
@property (nonatomic)	id<HistorySelectViewDelegate>	delegate;

/**
 * イニシャライザ
 * @param	frame		Viewを初期化するためのバウンディングボックス
 * @param	withClose	Viewを閉じる(非表示にする)ボタンをつけるならYES
 * @param	withSwitch	Viewのセーブ・ロードを切り替えるボタンをつけるならYES
 * @return	初期化されたインスタンス
 */
- (id)initWithFrame:(CGRect)frame withClose:(BOOL)withClose withSwitch:(BOOL)withSwitch;

- (void)showAnimated:(BOOL)animated completion:(void (^)(void))completion;
- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end

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

@property (nonatomic, readonly)	BOOL	shown;

/** Viewで発生したイベントを捕捉するデリゲートオブジェクト */
@property (nonatomic)	id<HistorySelectViewDelegate>	delegate;

/**
 * イニシャライザ
 * @param	frame		Viewを初期化するためのバウンディングボックス
 * @param	closable	Viewを閉じる(非表示にする)ボタンをつけるならYES
 * @param	loadOnly	ロード専用(Viewのセーブ・ロードを切り替えるボタンをつけない)ならYES
 * @param	autoSave	自動セーブデータも含むかどうか(loadOnly=YESのときのみ有効)
 * @return	初期化されたインスタンス
 */
- (id)initWithFrame:(CGRect)frame closable:(BOOL)closable loadOnly:(BOOL)loadOnly autoSave:(BOOL)autoSave;

/**
 * このViewを表示する
 * @param	animated	アニメーション付きで表示するか
 * @param	completion	表示が完了した時に呼び出すコールバック
 */
- (void)showAnimated:(BOOL)animated completion:(void (^)(void))completion;

/**
 * このViewを非表示にする
 * @param	animated	アニメーション付きで非表示にするか
 * @param	completion	非表示にし終わった時に呼び出すコールバック
 */
- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion;

/**
 * セーブデータの内容に応じてボタンの文言や活性/非活性を設定する
 */
- (void)refresh;

@end

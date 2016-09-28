//
//  GestureHintView.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/09/27.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * ロングタップのジェスチャに関するヒントを表示するView
 */
@interface GestureHintView : UIView {
	@private
	UIView*				_backgroundView;
	NSArray<UILabel*>*	_hintLabels;
}

/**
 * イニシャライザ
 * @param	frame		Viewを初期化するバウンディングボックス
 * @param	font		フォント
 * @param	hintTexts	操作のヒントとなる文字列。ここで与えた順番がそのまま他のメソッドで指定すべきインデックス値になる
 * @return	初期化されたインスタンス
 */
- (id)initWithFrame:(CGRect)frame font:(UIFont*)font hints:(NSString*)hintTexts, ...NS_REQUIRES_NIL_TERMINATION;

/**
 * 指定したindexに該当するテキストの中心位置を指定する
 * @param	index	中心位置を設定したいテキストを特定するためのインデックス値
 * @param	center	テキストの中心位置
 */
- (void)setCenterAtIndex:(NSInteger)index center:(CGPoint)center;

/**
 * 透過状態の黒を背景にヒントの文字列を白文字で表示させる
 * @param	duration		背景を表示させる時間
 * @param	hintDuration	ヒントの文字列を表示させる時間
 */
- (void)showWithDuration:(NSTimeInterval)duration hint:(NSTimeInterval)hintDuration;

/**
 * showWithDurationで表示したヒントを非表示にする
 * @param	duration		背景を非表示にする時間
 * @param	hintDuration	ヒントの文字列を非表示にする時間
 */
- (void)hideWithDuration:(NSTimeInterval)duration hint:(NSTimeInterval)hintDuration;

@end

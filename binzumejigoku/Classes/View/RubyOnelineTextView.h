//
//  RubyOnelineTextView.h
//  SampleApp
//
//  Created by Shizuo Ichitake on 2016/09/11.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * ルビ入りテキスト1行を表示する<br />
 * UIViewでなくUILabelのサブクラスなのはアニメーション対策
 */
@interface RubyOnelineTextView : UILabel {
	@private
	CGRect	_initializedFrame;
	CGFloat	_rubyHeight;
	CGFloat	_textHeight;
	BOOL	_cancelled;
	
	NSMutableDictionary<NSValue*, NSAttributedString*>*	_attributedRubys;
	NSMutableAttributedString*							_attributedText;
}

/** テキストに対するルビのサイズを決定する比率 */
@property (nonatomic)			CGFloat		rubySizeFactor;

/** Viewに設定した文字をすべて描画した時に必要となるサイズ */
@property (nonatomic, readonly)	CGSize		requiredSize;

/** appendされた文字数(テキスト。ルビではない) */
@property (nonatomic, readonly)	NSInteger	textLength;

/**
 * テキストとルビを追加する<br />
 * ルビが不要な場合はrubyにnilをセットする
 * @param	text	テキスト
 * @param	ruby	ルビ
 * @return	追加できたらYES.initWithFrame:で与えられた幅からはみ出すようならNO
 */
- (BOOL)append:(NSString*)text ruby:(NSString*)ruby;

/**
 * テキストのストリーム表示を開始する
 * @param	duration	ストリーム表示にかける時間(sec)
 * @param	completion	ストリーム表示が完了したら呼び出されるブロック
 */
- (void)executeAnimationWithDuration:(NSTimeInterval)duration completion:(void (^)(void))completion;

/**
 * テキストのストリーム表示を途中で停止し、全てのテキストを表示する
 */
- (void)cancelAnimation;

@end

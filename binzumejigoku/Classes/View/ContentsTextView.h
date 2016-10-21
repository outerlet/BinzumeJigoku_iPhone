//
//  ContentsTextView.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/09/20.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentsView.h"

@class RubyTextView;
@class TextElement;

/**
 * ルビ付きのテキストを表示するView
 */
@interface ContentsTextView : UIView <ContentsView> {
	@private
	NSMutableArray<RubyTextView*>*	_subviews;
	
	NSString*	_rubyClosure;
	NSString*	_rubyDelimiter;
}

/**
 * 表示するテキストを保持するTextElement要素をセットする
 * @param	textElement	表示するテキストを保持するTextElement要素
 */
- (void)setTextElement:(TextElement*)textElement;

/**
 * テキストのストリーム表示を開始する
 * @param	interval	テキスト1文字あたりの描画にかける時間(sec)
 * @param	completion	ストリーム表示が完了した時に呼び出されるブロック
 */
- (void)executeAnimationWithInterval:(NSTimeInterval)interval completion:(void (^)(void))completion;

/**
 * テキストのストリーム表示が実行中であれば停止して全てのテキストを表示する
 */
- (void)cancelAnimation;

/**
 * 現在表示されているテキストを全て破棄する<br />
 * (何も表示されていない状態にする)
 */
- (void)clearAllTexts;

@end

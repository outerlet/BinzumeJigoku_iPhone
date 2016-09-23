//
//  RubyView.h
//  SampleApp
//
//  Created by Shizuo Ichitake on 2016/08/28.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RubyOnelineTextView;

/**
 * ルビ入りテキストを複数行表示する<br />
 RubyOnelineTextViewと異なり改行は自動的に入る
 */
@interface RubyTextView : UIView {
	@private
	NSMutableArray<RubyOnelineTextView*>*	_subviews;
	
	NSInteger	_index;
	void		(^_completion)(void);
}

/** テキスト色 */
@property (nonatomic)			UIColor*	textColor;

/** テキストフォント */
@property (nonatomic)			UIFont*		font;

/** このViewに描画されるテキストをすべて表示するのに必要なサイズ */
@property (nonatomic,readonly)	CGSize		requiredSize;

/**
 * イニシャライザ<br />
 * Viewの高さはappendされるテキストによって決定されるので、最大幅だけ決めて初期化する
 * @param	width	Viewの最大幅
 * @return	インスタンス
 */
- (id)initWithWidth:(CGFloat)width;

/**
 * Viewに描画するテキストを追加する
 * @param	text	テキスト
 */
- (void)append:(NSString*)text alignment:(NSTextAlignment)alignment;

/**
 * Viewに描画するテキストとルビを追加する
 * @param	text	テキスト
 * @param	ruby	ルビ
 * @return	インスタンス
 */
- (void)append:(NSString*)text ruby:(NSString*)ruby alignment:(NSTextAlignment)alignment;

/**
 * 空行を挿入する
 */
- (void)newLine;

/**
 * テキストのストリーム表示を開始する
 * @param	interval	テキスト1文字あたりの描画にかける時間(sec)
 * @param	completion	ストリーム表示が完了した時に呼び出されるブロック
 */
- (void)startStreamingByInterval:(NSTimeInterval)interval completion:(void (^)(void))completion;

@end

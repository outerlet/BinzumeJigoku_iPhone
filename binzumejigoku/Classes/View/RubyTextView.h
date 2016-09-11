//
//  RubyView.h
//  SampleApp
//
//  Created by Shizuo Ichitake on 2016/08/28.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RubyTextView;

/**
 * RubyTextViewに関するイベントを捕捉するためのデリゲート
 */
@protocol RubyTextViewDelegate <NSObject>

/**
 * RubyTextView.startStreamingで開始されたテキストのストリーム表示が終了した
 * @param textView	ストリーム表示を終えたRubyTextView
 */
- (void)rubyTextStreamingDidFinish:(RubyTextView*)textView;

@end

@interface RubyTextView : UIView {
	@private
	NSMutableArray*	_subviews;	// ルビ付テキスト1行を表示するRubyOnelineTextViewの配列
	NSTimer*		_timer;		// テキストの表示を更新するためのタイマー
	
	BOOL			_isNewLine;	// 次に文字列をappendする前に改行を入れるかどうか
	NSInteger		_lineIndex;	// 現在描画中の行を示すインデックス値
}

/** テキストカラー */
@property (nonatomic)	UIColor*	textColor;

/** フォント */
@property (nonatomic)	UIFont*	font;

/** デリゲート */
@property (nonatomic)	id<RubyTextViewDelegate>	delegate;

/**
 * イニシャライザ。幅を指定してViewを初期化する
 * @param width	Viewの幅
 */
- (id)initWithWidth:(CGFloat)width;

/**
 * このViewに表示されるルビ無しのテキストを追加する
 * @param string	本文のテキスト
 */
- (void)appendText:(NSString*)text;

/**
 * このViewに表示されるテキストを追加する。ルビ無しテキストにする場合はannotationにnilを与える
 * @param string		本文のテキスト
 * @param annotation	stringに対して設定するルビ
 */
- (void)appendText:(NSString*)text annotation:(NSString*)annotation;

/**
 * 次にappendTextされるものを次の行に表示する
 */
- (void)newLine;

/**
 *　テキストのストリーム表示を開始する
 * @param interval	テキストの表示更新間隔
 */
- (void)startStreaming:(NSTimeInterval)interval;

@end

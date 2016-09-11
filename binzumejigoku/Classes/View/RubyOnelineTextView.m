//
//  RubyOnelineTextView.m
//  SampleApp
//
//  Created by Shizuo Ichitake on 2016/09/11.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "RubyOnelineTextView.h"
#import <CoreText/CoreText.h>

@import QuartzCore;

@implementation RubyOnelineTextView

/**
 * 描画するAttributed StringをもとにこのViewを初期化する
 * @param attributedString	このViewに描画されるAttributed String
 */
- (id)initWithMutableAttributedString:(NSMutableAttributedString*)attributedString {
	if (self = [super init]) {
		_attributedString = attributedString;
		
		// テキスト＋ルビの描画領域を示すバウンディングボックス
		// ルビもテキストと同じだけの高さを取ると見ておけば余裕があるようなので単純にAttributed Stringの倍
		_size = _attributedString.size;
		_size.height *= 2.0f;

		// 初期サイズと表示位置はどちらも0
		CGRect frame = CGRectZero;
		frame.size.height = _size.height;
		self.frame = frame;
	}
	return self;
}

- (NSMutableAttributedString*)attributedString {
	return _attributedString;
}

- (CGSize)size {
	return _size;
}

- (void)drawRect:(CGRect)rect {
	// グラフィックスコンテキストの取得と座標空間の反転
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, 0.0f, 0.0f);
	CGContextScaleCTM(context, 1.0f, -1.0f);

	// 描画位置をバウンディングボックスの高さ75%にすると、日本語でもアルファベットでもルビと文字がいい具合にその中に収まる
	CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)_attributedString);
	CGContextSetTextPosition(context, 0.0f, _size.height * -0.75f);
	CTLineDraw(line, context);
	CFRelease(line);
}

@end

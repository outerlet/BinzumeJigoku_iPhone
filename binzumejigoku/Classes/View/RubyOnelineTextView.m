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
		
		// 徐々に幅を広げていくので、初期の幅と表示位置はどちらも0、高さは必要なだけ
		CGRect frame = CGRectZero;
		frame.size.height = self.requiredSize.height;
		self.frame = frame;
	}
	return self;
}

- (void)appendAttributedString:(NSAttributedString *)appendage {
	[_attributedString appendAttributedString:appendage];
}

// テキスト＋ルビの描画領域を示すバウンディングボックスのサイズ
- (CGSize)requiredSize {
	// ルビもテキストと同じだけの高さを取ると見ておけば余裕があるようなので単純にAttributed Stringの倍
	CGSize size = _attributedString.size;
	size.height *= 2.0f;
	
	return size;
}

- (NSInteger)length {
	return _attributedString.length;
}

- (void)drawRect:(CGRect)rect {
	// グラフィックスコンテキストの取得と座標空間の反転
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, 0.0f, 0.0f);
	CGContextScaleCTM(context, 1.0f, -1.0f);

	// 描画位置をバウンディングボックスの高さ75%にすると、日本語でもアルファベットでもルビと文字がいい具合にその中に収まる
	CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)_attributedString);
	CGContextSetTextPosition(context, 0.0f, self.requiredSize.height * -0.75f);
	CTLineDraw(line, context);
	CFRelease(line);
}

@end

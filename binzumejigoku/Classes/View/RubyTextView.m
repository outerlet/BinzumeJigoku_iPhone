//
//  RubyView.m
//  SampleApp
//
//  Created by Shizuo Ichitake on 2016/08/28.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "RubyTextView.h"
#import "RubyOnelineTextView.h"
#import "UIView+Adjustment.h"
#import <CoreText/CoreText.h>

static const CGFloat RUBY_SIZE_FACTOR	= 0.5f;	// テキストに対するルビのサイズを示す倍率

@interface RubyTextView ()

/**
 * NSTimerの更新間隔が経過する度に呼び出されるメソッド
 */
- (void)timerIntervalDidPass;

/**
 * Attributed Stringを表示する新しい行(RubyOnelineTextView)を追加する
 * @param attributedString
 */
- (void)addNewLine:(NSMutableAttributedString*)attributedString;

/**
 * 本文にstringが、ルビにannotationが設定されたNSMutableAttributedStringを生成する<br />
 * ルビ無しテキストを生成する場合はannotationにnilを与える
 * @param string		本文のテキスト
 * @param annotation	stringに対して設定するルビ。ルビを付与しないならnil
 * @return	ルビ入りのMutable Attributed String
 */
- (NSMutableAttributedString*)createAnnotatedString:(NSString*)string annotation:(NSString*)annotation;

@end

@implementation RubyTextView

@synthesize font = _font;
@synthesize textColor = _textColor;

- (id)initWithWidth:(CGFloat)width {
	if (self = [super initWithFrame:CGRectMake(0.0f, 0.0f, width, 0.0f)]) {
		_subviews = [[NSMutableArray alloc] init];
		
		_isNewLine = NO;
		_lineIndex = 0;
		_completion = nil;
	}
	return self;
}

- (void)appendText:(NSString*)text {
	[self appendText:text annotation:nil];
}

- (void)appendText:(NSString*)text annotation:(NSString*)annotation {
	NSMutableAttributedString* appendage = [self createAnnotatedString:text annotation:annotation];
	
	if (_subviews.count > 0) {
		RubyOnelineTextView* latest = [_subviews lastObject];
		
		if (appendage.size.width + latest.requiredSize.width >= self.bounds.size.width || _isNewLine) {
			[self addNewLine:appendage];
			_isNewLine = NO;
		} else {
			[latest appendAttributedString:appendage];
		}
	} else {
		[self addNewLine:appendage];
	}
}

- (void)newLine {
	_isNewLine = YES;
}

- (void)startStreaming:(NSTimeInterval)interval completion:(void (^)(void))completion {
	_completion = completion;
	
	_timer = [NSTimer scheduledTimerWithTimeInterval:interval
											  target:self
											selector:@selector(timerIntervalDidPass)
											userInfo:nil
											 repeats:YES];
}

- (void)timerIntervalDidPass {
	RubyOnelineTextView* current = [_subviews objectAtIndex:_lineIndex];
	
	// Adjustmentカテゴリのメソッドを使ってViewをリサイズ
	CGFloat w = current.requiredSize.width / current.length;
	[current resizeBy:CGSizeMake(w, 0.0f)];
	[current setNeedsDisplay];
	
	if (current.frame.size.width > current.requiredSize.width) {
		++_lineIndex;
		
		if (_lineIndex >= _subviews.count) {
			[_timer invalidate];
			
			if (_completion) {
				_completion();
			}
		}
	}
}

- (void)animationDidComplete {
	RubyOnelineTextView* current = [_subviews objectAtIndex:_lineIndex];
	
	// Adjustmentカテゴリのメソッドを使ってViewをリサイズ
	CGFloat w = current.requiredSize.width / current.length;
	[current resizeBy:CGSizeMake(w, 0.0f)];
	[current setNeedsDisplay];
	
	if (current.frame.size.width >= current.requiredSize.width) {
		++_lineIndex;
		
		if (_lineIndex >= _subviews.count) {
			[_timer invalidate];
			
			if (_completion) {
				_completion();
			}
		}
	}
}

- (void)addNewLine:(NSMutableAttributedString*)attributedString {
	RubyOnelineTextView* textView = [[RubyOnelineTextView alloc] initWithMutableAttributedString:attributedString];
	textView.backgroundColor = self.backgroundColor;
	
	[self addSubview:textView];
	
	if (_subviews.count > 0) {
		RubyOnelineTextView* latest = [_subviews lastObject];
		[textView moveTo:CGPointMake(0.0f, latest.frame.origin.y + latest.frame.size.height)];
	}
	
	[_subviews addObject:textView];
	
	[self resizeBy:CGSizeMake(0.0f, textView.requiredSize.height)];
}

- (NSMutableAttributedString*)createAnnotatedString:(NSString*)string annotation:(NSString*)annotation {
	NSMutableDictionary* attrs = [[NSMutableDictionary alloc] init];
	[attrs setObject:_font forKey:NSFontAttributeName];
	[attrs setObject:_textColor forKey:NSForegroundColorAttributeName];
	
	if (annotation) {
		CFStringRef furigana[kCTRubyPositionCount] = { (__bridge CFStringRef)annotation, NULL, NULL, NULL };
		CTRubyAnnotationRef ruby = CTRubyAnnotationCreate(kCTRubyAlignmentAuto, kCTRubyOverhangAuto, RUBY_SIZE_FACTOR, furigana);
		
		[attrs setObject:(__bridge id)ruby forKey:(NSString*)kCTRubyAnnotationAttributeName];
		
		CFRelease(ruby);
	}
	
	return [[NSMutableAttributedString alloc] initWithString:string attributes:attrs];
}

@end

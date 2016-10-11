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

static const CGFloat kRubySizeFactor	= 0.5f;
static const CGFloat kOnelineHeight		= 48.0f;

@interface RubyTextView ()

// [非公開メソッド]新しい行を幅が0の状態で末尾に追加する
- (RubyOnelineTextView*)addNewLine;

// [非公開メソッド]NSTextAilgnmentの値次第でviewの位置を調整する
- (void)repositionByAlignment:(RubyOnelineTextView*)view alignment:(NSTextAlignment)alignment;

@end

@implementation RubyTextView

@synthesize font = _font;
@synthesize textColor = _textColor;

- (id)initWithWidth:(CGFloat)width {
	if (self = [super initWithFrame:CGRectMake(0.0f, 0.0f, width, 0.0f)]) {
		_subviews = [[NSMutableArray alloc] init];
		_index = 0;
	}
	return self;
}

- (void)append:(NSString*)text alignment:(NSTextAlignment)alignment {
	for (NSInteger idx = 0 ; idx < text.length ; idx++) {
		RubyOnelineTextView* latest = [_subviews lastObject];
		
		if (!latest) {
			latest = [self addNewLine];
		}
		
		NSString* appendText = [text substringWithRange:NSMakeRange(idx, 1)];
		BOOL appended = [latest append:appendText ruby:nil];
		
		if (!appended) {
			latest = [self addNewLine];
			[latest append:appendText ruby:nil];
		}
		
		if (idx == text.length - 1) {
			[self repositionByAlignment:latest alignment:alignment];
		}
	}
}

- (void)append:(NSString*)text ruby:(NSString*)ruby alignment:(NSTextAlignment)alignment {
	if (!ruby) {
		[self append:text alignment:alignment];
		return;
	}
	
	RubyOnelineTextView* latest = [_subviews lastObject];
	
	if (!latest) {
		latest = [self addNewLine];
	}
	
	BOOL appended = [latest append:text ruby:ruby];
	
	if (!appended) {
		latest = [self addNewLine];
		[latest append:text ruby:ruby];
	}
	
	[self repositionByAlignment:latest alignment:alignment];
}

- (void)sizeToFit {
	for (RubyOnelineTextView* oneline in _subviews) {
		[oneline sizeToFit];
	}
}

- (void)newLine {
	[self addNewLine];
}

- (void)executeAnimationWithInterval:(NSTimeInterval)interval completion:(void (^)(void))completion {
	if (completion) {
		_completion = completion;
	}

	RubyOnelineTextView* textView = [_subviews objectAtIndex:_index];
	
	[textView executeAnimationWithDuration:interval * textView.textLength
								completion:^(void) {
									if (++_index < _subviews.count) {
										[self executeAnimationWithInterval:interval completion:nil];
									} else {
										_completion();
									}
								}];
}

- (void)cancelAnimation {
	[[_subviews objectAtIndex:_index] cancelAnimation];
	
	for (NSInteger idx = _index + 1 ; idx < _subviews.count ; idx++) {
		[[_subviews objectAtIndex:idx] sizeToFit];
	}
}

- (RubyOnelineTextView*)addNewLine {
	RubyOnelineTextView* newLine = [[RubyOnelineTextView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, kOnelineHeight)];
	newLine.textColor = _textColor;
	newLine.font = _font;
	newLine.rubySizeFactor = kRubySizeFactor;
	[newLine resizeTo:CGSizeMake(0.0f, newLine.frame.size.height)];
	
	RubyOnelineTextView* latest = [_subviews lastObject];
	if (latest) {
		[newLine moveTo:CGPointMake(0.0f, latest.frame.origin.y + latest.frame.size.height)];
	}
	
	[_subviews addObject:newLine];
	
	[self addSubview:newLine];
	
	[self resizeBy:CGSizeMake(0.0f, newLine.frame.size.height)];
	
	return newLine;
}

- (void)repositionByAlignment:(RubyOnelineTextView*)view alignment:(NSTextAlignment)alignment {
	if (alignment == NSTextAlignmentRight) {
		CGPoint pos = CGPointMake(self.bounds.size.width - view.requiredSize.width, view.frame.origin.y);
		[view moveTo:pos];
	} else if (alignment == NSTextAlignmentCenter) {
		CGPoint pos = CGPointMake((self.bounds.size.width - view.requiredSize.width) / 2.0f, view.frame.origin.y);
		[view moveTo:pos];
	}
}

@end

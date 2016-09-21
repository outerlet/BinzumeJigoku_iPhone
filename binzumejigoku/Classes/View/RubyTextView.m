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

- (void)append:(NSString*)text {
	for (NSInteger idx = 0 ; idx < text.length ; idx++) {
		RubyOnelineTextView* latest = [_subviews lastObject];
		
		if (!latest) {
			latest = [self addNewLine];
		}
		
		NSString* appendText = [text substringWithRange:NSMakeRange(idx, 1)];
		BOOL appended = [latest append:appendText ruby:nil];
		
		if (!appended) {
			[[self addNewLine] append:appendText ruby:nil];
		}
	}
}

- (void)append:(NSString*)text ruby:(NSString*)ruby {
	if (!ruby) {
		[self append:text];
		return;
	}
	
	RubyOnelineTextView* latest = [_subviews lastObject];
	
	if (!latest) {
		latest = [self addNewLine];
	}
	
	BOOL appended = [latest append:text ruby:ruby];
	
	if (!appended) {
		[[self addNewLine] append:text ruby:ruby];
	}
}

- (void)sizeToFit {
	for (RubyOnelineTextView* oneline in _subviews) {
		[oneline sizeToFit];
	}
}

- (void)newLine {
	[self addNewLine];
}

- (void)startStreamingByInterval:(NSTimeInterval)interval completion:(void (^)(void))completion {
	if (completion) {
		_completion = completion;
	}

	RubyOnelineTextView* textView = [_subviews objectAtIndex:_index];
	
	[textView startStreamingWithDuration:interval * textView.textLength
							  completion:^(void) {
								  if (_index++ < _subviews.count - 1) {
									  [self startStreamingByInterval:interval completion:nil];
								  } else {
									  _completion();
								  }
							  }];
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

@end

//
//  RubyOnelineTextView.m
//  SampleApp
//
//  Created by Shizuo Ichitake on 2016/09/11.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "RubyOnelineTextView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Adjustment.h"

@interface RubyOnelineTextView ()

- (NSMutableAttributedString*)createAttributedString:(NSString*)string isRuby:(BOOL)isRuby;

@end

@implementation RubyOnelineTextView

@synthesize rubySizeFactor = _rubySizeFactor;

#pragma mark - イニシャライザ

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		_attributedRubys = [[NSMutableDictionary alloc] init];
		_attributedText = [[NSMutableAttributedString alloc] init];
		
		// ルビのデフォルトのサイズはテキストに対して50%
		// ルビとテキストの高さの比率は6:4くらいがよく見える(ルビのフォントサイズがテキストの50%である場合)
		_rubySizeFactor = 0.5f;
		_rubyHeight = frame.size.height * 0.4f;
		_textHeight = frame.size.height - _rubyHeight;
		_initializedFrame = frame;
		_cancelled = NO;
	}
	return self;
}

#pragma mark - プロパティ

- (CGSize)requiredSize {
	return CGSizeMake(_attributedText.size.width, _initializedFrame.size.height);
}

- (NSInteger)textLength {
	return _attributedText.length;
}

#pragma mark - インスタンスメソッド

- (BOOL)append:(NSString *)text ruby:(NSString *)ruby {
	NSMutableAttributedString* appendText = [self createAttributedString:text isRuby:NO];
	
	BOOL appended;
	
	// ルビありの場合
	if (ruby) {
		NSMutableAttributedString* appendRuby = [self createAttributedString:ruby isRuby:YES];
		
		CGFloat width = 0.0f;
		
		// 幅が足りない方の長さはカーニングで補う
		if (appendText.size.width > appendRuby.size.width) {
			CGFloat difference = appendText.size.width - appendRuby.size.width;
			NSInteger numberOfInterval = (appendRuby.length > 1) ? (appendRuby.length - 1) : 1;
			CGFloat kerning = difference / numberOfInterval;
			
			[appendRuby addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat:kerning] range:NSMakeRange(0, appendRuby.length)];
			
			width = appendText.size.width;
		} else {
			CGFloat difference = appendRuby.size.width - appendText.size.width;
			NSInteger numberOfInterval = (appendText.length > 1) ? appendText.length - 1 : 1;
			CGFloat kerning = difference / numberOfInterval;
			
			[appendText addAttribute:NSKernAttributeName value:[NSNumber numberWithFloat:kerning] range:NSMakeRange(0, appendText.length)];
			
			width = appendRuby.size.width;
		}

		appended = (_attributedText.size.width + width <= _initializedFrame.size.width);
		
		if (appended) {
			CGRect frame = CGRectMake(_attributedText.size.width, _rubyHeight - appendRuby.size.height, appendRuby.size.width, appendRuby.size.height);
			[_attributedRubys setObject:appendRuby forKey:[NSValue valueWithCGRect:frame]];
			[_attributedText appendAttributedString:appendText];
		}
	// ルビ無しの場合
	} else {
		appended = (_attributedText.size.width + appendText.size.width <= _initializedFrame.size.width);
		
		if (appended) {
			[_attributedText appendAttributedString:appendText];
		}
	}
	
	return appended;
}

- (void)executeAnimationWithDuration:(NSTimeInterval)duration completion:(void (^)(void))completion {
	[self setNeedsLayout];
	
	[UIView animateWithDuration:duration
					 animations:^(void) {
						 [self sizeToFit];
						 [self setNeedsLayout];
					 }
					 completion:^(BOOL finished) {
						 if (!_cancelled) {
							 completion();
						 }
					 }];
}

- (void)cancelAnimation {
	_cancelled = YES;
	[self.layer removeAllAnimations];
}

- (NSMutableAttributedString*)createAttributedString:(NSString*)string isRuby:(BOOL)isRuby {
	NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
	style.alignment = NSTextAlignmentLeft;
	
	UIFont* font;
	if (isRuby) {
		font = [UIFont fontWithName:self.font.fontName size:self.font.pointSize * self.rubySizeFactor];
	} else {
		font = self.font;
	}
	
	NSMutableAttributedString* attributed = [[NSMutableAttributedString alloc] initWithString:string];
	[attributed addAttribute:NSForegroundColorAttributeName value:self.textColor range:NSMakeRange(0, string.length)];
	[attributed addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
	[attributed addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
	
	return attributed;
}

#pragma mark - オーバーライドメソッド

- (void)sizeToFit {
	[self resizeTo:self.requiredSize];
}

- (void)drawRect:(CGRect)rect {
	// ルビ
	for (NSValue* value in _attributedRubys.allKeys) {
		[[_attributedRubys objectForKey:value] drawWithRect:[value CGRectValue]
													options:NSStringDrawingUsesLineFragmentOrigin
													context:nil];
	}
	
	// テキスト
	[_attributedText drawWithRect:CGRectMake(0.0f, _rubyHeight, _attributedText.size.width, _attributedText.size.height)
						  options:NSStringDrawingUsesLineFragmentOrigin
						  context:nil];
}

@end

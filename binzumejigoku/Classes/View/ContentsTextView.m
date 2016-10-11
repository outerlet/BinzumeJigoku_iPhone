//
//  ContentsTextView.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/09/20.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "ContentsTextView.h"

#import "AppDelegate.h"
#import "ContentsInterface.h"
#import "TextElement.h"
#import "ClearTextElement.h"
#import "RubyTextView.h"
#import "UIView+Adjustment.h"

@implementation ContentsTextView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		_subviews = [[NSMutableArray alloc] init];
		
		ContentsInterface* cif = [ContentsInterface sharedInstance];
		_rubyClosure = cif.rubyClosure;
		_rubyDelimiter = cif.rubyDelimiter;
	}
	return self;
}

- (void)setTextElement:(TextElement*)textElement {
	ContentsInterface* cif = [ContentsInterface sharedInstance];
	
	RubyTextView* newView = [[RubyTextView alloc] initWithWidth:self.bounds.size.width];
	newView.backgroundColor = [UIColor clearColor];
	newView.textColor = textElement.color;
	newView.font = [UIFont fontWithName:cif.fontName size:cif.textSize];
	
	// indentの数だけ付加する全角スペースを作成
	NSMutableString* indent = [[NSMutableString alloc] init];
	for (NSInteger idx = 0 ; idx < textElement.indent ; idx++) {
		[indent appendString:@"　"];
	}
	
	// alignment次第でスペースを挿入する位置を変える
	// NSTextAlignmentCenterの場合はインデントとか無視
	NSString* text = nil;
	if (textElement.alignment == NSTextAlignmentLeft) {
		text = [NSString stringWithFormat:@"%@%@", indent, textElement.text];
	} else if (textElement.alignment == NSTextAlignmentRight) {
		text = [NSString stringWithFormat:@"%@%@", textElement.text, indent];
	} else {
		text = textElement.text;
	}
	
	NSArray<NSString*>* components = [text componentsSeparatedByString:_rubyClosure];
	
	for (NSString* component in components) {
		if (component && component.length > 0) {
			if ([component containsString:_rubyDelimiter]) {
				NSArray<NSString*>* elms = [component componentsSeparatedByString:_rubyDelimiter];
				[newView append:[elms firstObject] ruby:[elms lastObject] alignment:textElement.alignment];
			} else {
				[newView append:component alignment:textElement.alignment];
			}
		}
	}
	
	RubyTextView* latestView = [_subviews lastObject];
	if (latestView) {
		CGFloat bottomOfLatest = latestView.frame.origin.y + latestView.frame.size.height;
		
		if (bottomOfLatest + newView.frame.size.height > self.bounds.size.height) {
			[self clearAllTexts];
		} else {
			[newView moveTo:CGPointMake(0.0f, latestView.frame.origin.y + latestView.frame.size.height)];
		}
	}
	
	[_subviews addObject:newView];
	
	[self addSubview:newView];
}

- (void)executeAnimationWithInterval:(NSTimeInterval)interval completion:(void (^)(void))completion {
	RubyTextView* latestView = [_subviews lastObject];
	
	if (latestView) {
		[latestView executeAnimationWithInterval:interval completion:completion];
	}
}

- (void)cancelAnimation {
	RubyTextView* latestView = [_subviews lastObject];
	
	if (latestView) {
		[latestView cancelAnimation];
	}
}

- (void)clearAllTexts {
	for (RubyTextView* tv in _subviews) {
		[tv removeFromSuperview];
	}
	
	[_subviews removeAllObjects];
}

- (void)handleElement:(id)element completion:(void (^)(void))completion {
	if ([element isMemberOfClass:[TextElement class]]) {
		TextElement* textElement = element;
		
		[self setTextElement:textElement];
		
		[self executeAnimationWithInterval:[ContentsInterface sharedInstance].textSpeedInterval
								completion:completion];
	} else if ([element isMemberOfClass:[ClearTextElement class]]) {
		[self clearAllTexts];
		completion();
	}
}

@end

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
	RubyTextView* newView = [[RubyTextView alloc] initWithWidth:self.bounds.size.width];
	newView.backgroundColor = [UIColor clearColor];
	newView.textColor = textElement.color;
	newView.font = [UIFont fontWithName:DEFAULT_FONT_NAME size:DEFAULT_FONT_SIZE];
	
	NSArray<NSString*>* components = [textElement.text componentsSeparatedByString:_rubyClosure];
	
	for (NSString* component in components) {
		if (component && component.length > 0) {
			if ([component containsString:_rubyDelimiter]) {
				NSArray<NSString*>* elms = [component componentsSeparatedByString:_rubyDelimiter];
				[newView append:[elms firstObject] ruby:[elms lastObject]];
			} else {
				[newView append:component];
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

- (void)startStreamingWithInterval:(NSTimeInterval)interval completion:(void (^)(void))completion {
	RubyTextView* latestView = [_subviews lastObject];
	
	if (latestView) {
		[latestView startStreamingByInterval:interval completion:completion];
	}
}

- (void)clearAllTexts {
	for (RubyTextView* tv in _subviews) {
		[tv removeFromSuperview];
	}
	
	[_subviews removeAllObjects];
}

@end

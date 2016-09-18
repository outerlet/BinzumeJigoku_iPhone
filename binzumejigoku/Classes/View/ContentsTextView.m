//
//  ContentsTextView.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/09/15.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "ContentsTextView.h"
#import "RubyTextView.h"
#import "UIView+Adjustment.h"

@implementation ContentsTextView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		_subviews = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)setNextText:(NSString*)nextText {
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSString* closure = [defaults objectForKey:@"RUBY_CLOSURE"];
	NSString* delimiter = [defaults objectForKey:@"RUBY_DELIMITER"];
	
	NSArray<NSString*>* strs = [nextText componentsSeparatedByString:closure];
	
	RubyTextView* textView = [[RubyTextView alloc] initWithWidth:self.bounds.size.width];
	textView.backgroundColor = [UIColor clearColor];
	textView.font = self.font;
	textView.textColor = self.textColor;

	for (NSString* str in strs) {
		if ([str containsString:delimiter]) {
			NSArray<NSString*>* elms = [str componentsSeparatedByString:delimiter];
			[textView appendText:[elms objectAtIndex:0] annotation:[elms objectAtIndex:1]];
		} else {
			[textView appendText:str];
		}
	}
	
	if (_subviews.count > 0) {
		RubyTextView* last = [_subviews lastObject];
		
		if (last.frame.origin.y + last.frame.size.height + textView.frame.size.height > self.bounds.size.height) {
			for (RubyTextView* subview in _subviews) {
				[subview removeFromSuperview];
			}
			[_subviews removeAllObjects];
		} else {
			[textView moveTo:CGPointMake(0.0f, last.frame.origin.y + last.frame.size.height)];
		}
	}
	
	[self addSubview:textView];
	
	[_subviews addObject:textView];
}

- (void)startStreaming:(NSTimeInterval)interval completion:(void (^)(void))completion {
	if (_subviews.count > 0) {
		[[_subviews lastObject] startStreaming:interval completion:completion];
	}
}

@end

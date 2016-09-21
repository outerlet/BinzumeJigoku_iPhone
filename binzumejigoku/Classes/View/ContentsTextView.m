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
	RubyTextView* textView = [[RubyTextView alloc] initWithWidth:self.bounds.size.width];
	textView.backgroundColor = [UIColor clearColor];
	textView.textColor = textElement.color;
	textView.font = [UIFont fontWithName:DEFAULT_FONT_NAME size:DEFAULT_FONT_SIZE];
	
	NSArray<NSString*>* components = [textElement.text componentsSeparatedByString:_rubyClosure];
	for (NSString* component in components) {
		if (component && component.length > 0) {
			if ([component containsString:_rubyDelimiter]) {
				NSArray<NSString*>* elms = [component componentsSeparatedByString:_rubyDelimiter];
				[textView append:[elms firstObject] ruby:[elms lastObject]];
			} else {
				[textView append:component];
			}
		}
	}
	
	[textView sizeToFit];
	
	RubyTextView* latest = [_subviews lastObject];
	if (latest) {
		[textView moveTo:CGPointMake(0.0f, latest.frame.origin.y + latest.frame.size.height)];
	}
	
	[_subviews addObject:textView];
	
	[self addSubview:textView];
}

@end

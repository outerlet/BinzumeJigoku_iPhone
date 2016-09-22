//
//  ContentsTextView.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/09/20.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RubyTextView;
@class TextElement;

@interface ContentsTextView : UIView {
	@private
	NSMutableArray<RubyTextView*>*	_subviews;
	
	NSString*	_rubyClosure;
	NSString*	_rubyDelimiter;
}

- (void)setTextElement:(TextElement*)textElement;
- (void)startStreamingWithInterval:(NSTimeInterval)interval completion:(void (^)(void))completion;
- (void)clearAllTexts;

@end

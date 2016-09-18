//
//  ContentsTextView.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/09/15.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RubyTextView;

@interface ContentsTextView : UIView {
	@private
	NSMutableArray<RubyTextView*>*	_subviews;
}

@property (nonatomic)	UIFont*		font;
@property (nonatomic)	UIColor*	textColor;

- (void)setNextText:(NSString*)nextText;
- (void)startStreaming:(NSTimeInterval)interval completion:(void (^)(void))completion;

@end

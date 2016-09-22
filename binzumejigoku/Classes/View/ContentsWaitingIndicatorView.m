//
//  ContentsWaitingIndicatorView.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/09/22.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "ContentsWaitingIndicatorView.h"
#import <QuartzCore/QuartzCore.h>

const CGFloat kImageViewSideSize		= 24.0f;
NSString* const kImageNameOfIndicator	= @"ic_wait_advance.png";

@interface ContentsWaitingIndicatorView ()

@property (nonatomic, readwrite)	BOOL	animating;

- (void)executeAnimation:(BOOL)forward;

@end

@implementation ContentsWaitingIndicatorView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.animating = NO;
		_animationCount = 0;
		
		_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kImageViewSideSize, kImageViewSideSize)];
		_imageView.image = [UIImage imageNamed:kImageNameOfIndicator];
		_imageView.center = CGPointMake(self.bounds.size.width - (kImageViewSideSize / 2.0f), self.bounds.size.height / 2.0f);
		_imageView.alpha = 0.0f;
		[self addSubview:_imageView];
	}
	return self;
}

- (void)startAnimation {
	if (!self.animating) {
		[self executeAnimation:YES];
		
		self.animating = YES;
	}
}

- (void)stopAnimation {
	if (self.animating) {
		self.animating = NO;
		_animationCount = 0;
		_imageView.alpha = 0.0f;
	}
}

- (void)executeAnimation:(BOOL)forward {
	CGFloat alpha = forward ? 1.0f : 0.0f;
	NSTimeInterval delay = (_animationCount == 0) ? 0.0f : 0.5f;

	[UIView animateWithDuration:0.5f
						  delay:delay
						options:UIViewAnimationOptionCurveLinear
					 animations:^(void) {
						 _imageView.alpha = alpha;
					 }
					 completion:^(BOOL finished) {
						 if (self.animating) {
							 ++_animationCount;
							 [self executeAnimation:!forward];
						 }
					 }];
}

@end

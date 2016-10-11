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

@implementation ContentsWaitingIndicatorView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kImageViewSideSize, kImageViewSideSize)];
		_imageView.image = [UIImage imageNamed:kImageNameOfIndicator];
		_imageView.center = CGPointMake(self.bounds.size.width - (kImageViewSideSize / 2.0f), self.bounds.size.height / 2.0f);
		_imageView.alpha = 0.0f;
		[self addSubview:_imageView];
	}
	return self;
}

- (void)startAnimation {
	[UIView animateWithDuration:1.0f
						  delay:0.0f
						options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
					 animations:^(void) {
						 _imageView.alpha = 1.0f;
					 }
					 completion:^(BOOL finished) {
						 _imageView.alpha = 0.0f;
					 }];
}

- (void)stopAnimation {
	[_imageView.layer removeAllAnimations];
}

@end

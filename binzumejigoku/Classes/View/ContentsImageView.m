//
//  ContentsImageView.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/27.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "ContentsImageView.h"

static const NSInteger IMAGE_VIEW_NUMBER = 2;

@interface ContentsImageView ()

- (UIImageView*)imageViewByHidden:(BOOL)hidden;
- (void)animationDidEnd;

@end

@implementation ContentsImageView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		NSMutableArray* imageViews = [[NSMutableArray alloc] init];
		
		for (NSInteger idx = 0 ; idx < IMAGE_VIEW_NUMBER ; idx++) {
			UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.bounds];
			imageView.hidden = YES;
			imageView.alpha = 0.0f;
			imageView.contentMode = UIViewContentModeScaleAspectFill;
			[self addSubview:imageView];
			
			[imageViews addObject:imageView];
		}
		
		_imageViews = [NSArray arrayWithArray:imageViews];
	}
	return self;
}

- (void)setNextImage:(UIImage*)image {
	_nextImage = image;
}

- (void)startAnimationWithEffect:(ImageEffect)effect duration:(NSTimeInterval)duration {
	UIImageView* current = [self imageViewByHidden:NO];
	
	// エラー対策。現在何の画像も表示しておらず次に表示すべきものも無い場合は何もしない
	if (!current && !_nextImage) {
		return;
	}
	
	UIImageView* next = [self imageViewByHidden:YES];
	next.image = _nextImage;
	next.hidden = NO;
	
	// setImage:でセットされた画像の表示または非表示を実行するブロック
	void (^execution)(void) = nil;
	if (current) {
		execution = ^(void) {
			if (next.image) {
				next.alpha = 1.0f;
			}
			current.alpha = 0.0f;
		};
	} else {
		execution = ^(void) {
			next.alpha = 1.0f;
		};
	}
	
	// executionが終了したときに実行すべきブロック
	// 使わなくなったUIImageViewをhiddenにして_nextImageをクリアしている
	void (^completion)(void) = ^(void) {
		if (current) {
			current.hidden = YES;
		}
		
		_nextImage = nil;
	};
	
	// フェードならアニメーションを実行
	if (effect == ImageEffectFade) {
		[UIView animateWithDuration:duration
						 animations:execution
						 completion:^(BOOL isFinished) {
							 completion();
						 }];
	// カットなら即座にアルファ値を変更
	} else if (effect == ImageEffectCut) {
		execution();
		completion();
		[self animationDidEnd];
	}
}

- (UIImageView*)imageViewByHidden:(BOOL)hidden {
	for (NSInteger idx = 0 ; idx < _imageViews.count ; idx++) {
		UIImageView* imageView = [_imageViews objectAtIndex:idx];
		if (imageView.hidden == hidden) {
			return imageView;
		}
	}
	return nil;
}

- (void)animationDidEnd {
	if (self.delegate && [self.delegate respondsToSelector:@selector(imageViewAnimationDidFinish:)]) {
		[self.delegate imageViewAnimationDidFinish:self];
	}
}

@end
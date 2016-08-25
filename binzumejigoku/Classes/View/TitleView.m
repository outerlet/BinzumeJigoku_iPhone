//
//  TitleView.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/25.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "TitleView.h"

@interface TitleView ()

- (void)startDismissAnimation;
- (void)titleViewAnimationDidFinish;

@end

@implementation TitleView

- (id)initWithFrame:(CGRect)frame title:(NSString*)title font:(UIFont*)font {
	if (self = [super initWithFrame:frame]) {
		NSMutableArray* labels = [[NSMutableArray alloc] init];
		
		NSDictionary* attrs = @{ NSFontAttributeName : font };
		CGFloat totalWidth = 0.0f;
		
		// 1文字ごとを描画するのに必要なサイズを求めつつ文字数と同じだけのUILabelを生成
		for (NSInteger idx = 0 ; idx < title.length ; idx++) {
			NSString* str = [title substringWithRange:NSMakeRange(idx, 1)];
			CGSize size = [str sizeWithAttributes:attrs];
			
			totalWidth += size.width;
			
			UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
			label.font = font;
			label.backgroundColor = [UIColor clearColor];
			label.textColor = [UIColor blackColor];
			label.textAlignment = NSTextAlignmentCenter;
			label.alpha = 0.0f;
			label.text = str;
			[self addSubview:label];
			
			[labels addObject:label];
		}
		
		_titleLabels = [NSArray arrayWithArray:labels];
		
		CGPoint pos = self.center;
		pos.x -= (totalWidth / 2);
		
		// 先に生成したUILabelを適切な場所に配置
		for (NSInteger idx = 0 ; idx < _titleLabels.count ; idx++) {
			UILabel* label = [_titleLabels objectAtIndex:idx];
			
			CGFloat half = label.frame.size.width / 2;
			pos.x += half;
			label.center = pos;
			pos.x += half;
		}
	}
	
	return self;
}

- (void)startAnimationWithDuration:(NSTimeInterval)duration {
	_sequenceTime = duration / 3;
	_labelUnitTime = _sequenceTime / (_titleLabels.count + 1);
	
	for (NSInteger idx = 0 ; idx < _titleLabels.count ; idx++) {
		UILabel* label = [_titleLabels objectAtIndex:idx];
		
		void (^completion)(BOOL finished) = nil;
		if (idx == _titleLabels.count - 1) {
			completion = ^(BOOL finished) {
				[self startDismissAnimation];
			};
		}
		
		[UIView animateWithDuration:_labelUnitTime * 2
							  delay:_labelUnitTime * idx
							options:UIViewAnimationOptionCurveLinear
						 animations:^(void) {
							 label.alpha = 1.0f;
						 }
						 completion:completion];
	}
}

- (void)startDismissAnimation {
	for (NSInteger idx = 0 ; idx < _titleLabels.count ; idx++) {
		UILabel* label = [_titleLabels objectAtIndex:idx];
		
		void (^completion)(BOOL finished) = nil;
		if (idx == _titleLabels.count - 1) {
			completion = ^(BOOL finished) {
				[self titleViewAnimationDidFinish];
			};
		}
		
		[UIView animateWithDuration:_labelUnitTime * 2
							  delay:_sequenceTime + _labelUnitTime * idx
							options:UIViewAnimationOptionCurveLinear
						 animations:^(void) {
							 label.alpha = 0.0f;
						 }
						 completion:completion];
	}
}

- (void)titleViewAnimationDidFinish {
	if (self.delegate && [self.delegate respondsToSelector:@selector(titleViewAnimationDidFinish:)]) {
		[self.delegate titleViewAnimationDidFinish:self];
	}
}

@end

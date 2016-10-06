//
//  TitleView.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/25.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "ContentsTitleView.h"
#import "ContentsInterface.h"
#import "TitleElement.h"

const CGFloat kContentsTitleTextSize	= 36.0f;

@interface ContentsTitleView ()

- (void)startDismissAnimation;

@end

@implementation ContentsTitleView

- (void)setTitle:(NSString*)title font:(UIFont*)font {
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

- (void)startAnimationWithDuration:(NSTimeInterval)duration completion:(void (^)(void))completion {
	_sequenceTime = duration / 3;
	_labelUnitTime = _sequenceTime / (_titleLabels.count + 1);
	
	_completion = completion;
	
	for (NSInteger idx = 0 ; idx < _titleLabels.count ; idx++) {
		UILabel* label = [_titleLabels objectAtIndex:idx];

		[UIView animateWithDuration:_labelUnitTime * 2
							  delay:_labelUnitTime * idx
							options:UIViewAnimationOptionCurveLinear
						 animations:^(void) {
							 label.alpha = 1.0f;
						 }
						 completion:^(BOOL finished) {
							 if (idx == _titleLabels.count - 1) {
							 	[self startDismissAnimation];
							 }
						 }];
	}
}

- (void)startDismissAnimation {
	for (NSInteger idx = 0 ; idx < _titleLabels.count ; idx++) {
		UILabel* label = [_titleLabels objectAtIndex:idx];
		
		[UIView animateWithDuration:_labelUnitTime * 2
							  delay:_sequenceTime + _labelUnitTime * idx
							options:UIViewAnimationOptionCurveLinear
						 animations:^(void) {
							 label.alpha = 0.0f;
						 }
						 completion:^(BOOL finished) {
							 if (idx == _titleLabels.count - 1 && _completion) {
								 _completion();
							 }
						 }];
	}
}

- (void)handleElement:(id)element completion:(void (^)(void))completion {
	if (![element isMemberOfClass:[TitleElement class]]) {
		return;
	}
	
	TitleElement* titleElement = element;
		
	ContentsInterface* cif = [ContentsInterface sharedInstance];
		
	[self setTitle:titleElement.title font:[UIFont fontWithName:cif.fontName
														   size:kContentsTitleTextSize]];
	
	[self startAnimationWithDuration:3.0f completion:completion];
}

@end

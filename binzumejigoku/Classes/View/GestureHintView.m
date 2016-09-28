//
//  GestureHintView.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/09/27.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "GestureHintView.h"
#import "ContentsInterface.h"
#import "UIView+Adjustment.h"

@implementation GestureHintView

- (id)initWithFrame:(CGRect)frame font:(UIFont*)font hints:(NSString*)hintTexts, ...NS_REQUIRES_NIL_TERMINATION {
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];
		self.hidden = YES;
		
		ContentsInterface* cif = [ContentsInterface sharedInstance];
		
		_backgroundView = [[UIView alloc] initWithFrame:self.bounds];
		_backgroundView.backgroundColor = [UIColor blackColor];
		_backgroundView.alpha = 0.0f;
		[self addSubview:_backgroundView];
		
		NSMutableArray* labels = [[NSMutableArray alloc] init];
		va_list texts;
		va_start(texts, hintTexts);
		for (NSString* text = hintTexts; text != nil; text = va_arg(texts, NSString*)) {
			NSDictionary* attrs = @{ NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor whiteColor] };
			
			UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
			label.font = [UIFont fontWithName:cif.fontName size:32.0f];
			label.backgroundColor = [UIColor clearColor];
			label.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attrs];
			label.numberOfLines = 2;
			label.alpha = 0.0f;
			[label sizeToFit];
			[self addSubview:label];
			
			[labels addObject:label];
		}
		va_end(texts);
		
		_hintLabels = [NSArray arrayWithArray:labels];
	}
	return self;
}

- (void)setCenterAtIndex:(NSInteger)index center:(CGPoint)center {
	[_hintLabels objectAtIndex:index].center = center;
}

- (void)showWithDuration:(NSTimeInterval)duration hint:(NSTimeInterval)hintDuration {
	self.hidden = NO;
	
	[UIView animateWithDuration:duration
					 animations:^(void) {
						 _backgroundView.alpha = 0.5f;
					 }
					 completion:^(BOOL finished) {
						 for (UILabel* label in _hintLabels) {
							 [UIView animateWithDuration:hintDuration
											  animations:^(void) {
												  label.alpha = 1.0f;
											  }];
						 }
					 }];
}

- (void)hideWithDuration:(NSTimeInterval)duration hint:(NSTimeInterval)hintDuration {
	for (NSInteger idx = 0 ; idx < _hintLabels.count ; idx++) {
		UILabel* label = [_hintLabels objectAtIndex:idx];
		
		[UIView animateWithDuration:hintDuration
						 animations:^(void) {
							 label.alpha = 0.0f;
						 }
						 completion:^(BOOL finished) {
							 if (idx == _hintLabels.count - 1) {
								 [UIView animateWithDuration:duration
												  animations:^(void) {
													  _backgroundView.alpha = 0.0f;
												  }
												  completion:^(BOOL finished) {
													  self.hidden = YES;
												  }];
							 }
						 }];
	}
}

@end

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
#import "UIColor+CustomColor.h"

static const CGFloat	kDistanceFromTouchToHint	= 120.0f;
static const CGFloat	kDistanceTouchAccept		= 60.0f;
static const CGFloat	kLengthTouchCancel			= 10.0f;

@interface GestureHintView ()

// このViewを表示する
- (void)showWithDuration:(NSTimeInterval)duration hint:(NSTimeInterval)hintDuration;

// このViewを非表示にする
- (void)hideWithDuration:(NSTimeInterval)duration hint:(NSTimeInterval)hintDuration;

@end

@implementation GestureHintView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor translucentBlackColor];
		self.alpha = 0.0f;
		
		_hintLabels = [[NSMutableDictionary alloc] init];
		_startPoint = CGPointZero;
		
		self.hidden = YES;
	}
	return self;
}

- (void)setHint:(NSString*)hintText direction:(GestureDirection)direction {
	NSNumber* key = [NSNumber numberWithInteger:direction];
	
	if (hintText) {
		UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor whiteColor];
		label.font = [UIFont fontWithName:[ContentsInterface sharedInstance].fontName size:20.0f];
		label.text = hintText;
		label.alpha = 0.0f;
		[label sizeToFit];
		[self addSubview:label];
		
		[_hintLabels setObject:label forKey:key];
	} else {
		[_hintLabels removeObjectForKey:key];
	}
}

- (void)startGestureAt:(CGPoint)startPoint {
	_startPoint = startPoint;
	
	// ジェスチャ開始位置から各ラベルを適切な位置に配置する
	for (NSNumber* key in _hintLabels.allKeys) {
		UILabel* label = [_hintLabels objectForKey:key];
		
		GestureDirection direction = [key integerValue];
		switch (direction) {
			case GestureDirectionNorth:
				label.center = CGPointMake(startPoint.x, startPoint.y - kDistanceFromTouchToHint);
				break;
			case GestureDirectionEast:
				label.center = CGPointMake(startPoint.x + kDistanceFromTouchToHint, startPoint.y);
				break;
			case GestureDirectionSouth:
				label.center = CGPointMake(startPoint.x, startPoint.y + kDistanceFromTouchToHint);
				break;
			case GestureDirectionWest:
				label.center = CGPointMake(startPoint.x - kDistanceFromTouchToHint, startPoint.y);
				break;
			default:
				return;
		}
		
		CGRect frame = label.frame;
		
		// ラベルが画面外にはみ出してしまうようなら表示しない
		label.hidden = (frame.origin.x < 0.0f
						|| frame.origin.y < 0.0f
						|| frame.origin.x + frame.size.width > self.bounds.size.width
						|| frame.origin.y + frame.size.height > self.bounds.size.height);
	}
	
	[self showWithDuration:0.6f hint:0.1f];
}

- (void)endGestureAt:(CGPoint)endPoint {
	GestureDirection direction = GestureDirectionUnknown;
	
	CGFloat distanceX = endPoint.x - _startPoint.x;
	CGFloat distanceY = endPoint.y - _startPoint.y;
	
	// X軸方向に規定の距離以上の移動を認めた場合
	if (fabs(distanceX) > kDistanceTouchAccept) {
		if (fabs(distanceY) < kLengthTouchCancel) {
			direction = (distanceX < 0.0f) ? GestureDirectionWest : GestureDirectionEast;
		}
	}
	
	// Y軸方向に規定の距離以上の移動を認めた場合
	if (fabs(distanceY) > kDistanceTouchAccept) {
		if (fabs(distanceX) < kLengthTouchCancel) {
			direction = (distanceY < 0.0f) ? GestureDirectionNorth : GestureDirectionSouth;
		}
	}
	
	// 正しい方向が選択され、かつその方向のラベルが表示されていればコマンドは有効
	if (direction != GestureDirectionUnknown) {
		UILabel* label = [_hintLabels objectForKey:[NSNumber numberWithInteger:direction]];
		
		if (self.delegate && !label.hidden) {
			[self.delegate hintGestureDidDetect:direction];
		}
	}
	
	[self hideWithDuration:0.4f hint:0.2f];
}

- (void)showWithDuration:(NSTimeInterval)duration hint:(NSTimeInterval)hintDuration {
	self.hidden = NO;
	
	for (NSNumber* key in _hintLabels.allKeys) {
		[_hintLabels objectForKey:key].textColor = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f];
	}
	
	[UIView animateWithDuration:duration
					 animations:^(void) {
						 self.alpha = 1.0f;
					 }
					 completion:^(BOOL finished) {
						 for (NSNumber* key in _hintLabels.allKeys) {
							 UILabel* label = [_hintLabels objectForKey:key];
							 
							 [UIView animateWithDuration:hintDuration
											  animations:^(void) {
												  label.alpha = 1.0f;
											  }
											  completion:^(BOOL finished) {
												  label.textColor = [UIColor whiteColor];
											  }];
						 }
					 }];
}

- (void)hideWithDuration:(NSTimeInterval)duration hint:(NSTimeInterval)hintDuration {
	NSInteger index = 0;
	for (NSNumber* key in _hintLabels.allKeys) {
		UILabel* label = [_hintLabels objectForKey:key];
		
		[UIView animateWithDuration:hintDuration
						 animations:^(void) {
							 label.alpha = 0.0f;
						 }
						 completion:^(BOOL finished) {
							 if (index == _hintLabels.count - 1) {
								 [UIView animateWithDuration:duration
												  animations:^(void) {
													  self.alpha = 0.0f;
												  }
												  completion:^(BOOL finished) {
													  self.hidden = YES;
												  }];
							 }
						 }];
		
		++index;
	}
}

@end

//
//  LaunchImageView.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/11/03.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "LauncherView.h"
#import "ContentsInterface.h"
#import "UIView+Adjustment.h"

const CGFloat	kTitleTextSize				= 40.0f;	// タイトルのテキストサイズ
const CGFloat	kSubtitleTextSize			= 20.0f;	// サブタイトルのテキストサイズ
const CGFloat	kInteractionTextSize		= 24.0f;	// ユーザーのインタラクションを待つ旨のテキストサイズ
const CGFloat	kDistanceOfTitleAndSubtitle	= 20.0f;	// タイトルとサブタイトルの間隔

@interface LauncherView ()

// タイトルとサブタイトルのラベルが載ったViewを生成する
- (UIView*)createTitleView;

// タイトル＆サブタイトルを表示する
// UIView#animateWithDurationのネストが深くなると読み辛いので一部の処理を分離したもの
- (void)showTitle;

@end

@implementation LauncherView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		UIImageView* imageView2 = [[UIImageView alloc] initWithFrame:self.bounds];
		imageView2.contentMode = UIViewContentModeScaleAspectFill;
		imageView2.image = [UIImage imageNamed:@"launch_01.jpg"];
		[self addSubview:imageView2];
		
		UIImageView* imageView1 = [[UIImageView alloc] initWithFrame:self.bounds];
		imageView1.contentMode = UIViewContentModeScaleAspectFill;
		imageView1.image = [UIImage imageNamed:@"launch_00.jpg"];
		[self addSubview:imageView1];
		
		_imageViews = @[ imageView1, imageView2, ];
		
		_titleView = [self createTitleView];
		_titleView.center = CGPointMake(self.center.x, self.bounds.size.height * 0.4f);
		_titleView.alpha = 0.0f;
		_titleView.hidden = YES;
		[self addSubview:_titleView];
		
		_interactionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_interactionLabel.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"launcher_interaction", nil) attributes:@{ NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont fontWithName:[ContentsInterface sharedInstance].fontName size:kInteractionTextSize] }];
		[_interactionLabel sizeToFit];
		_interactionLabel.center = CGPointMake(self.center.x, self.bounds.size.height * 0.75f);
		_interactionLabel.alpha = 0.0f;
		_interactionLabel.hidden = YES;
		[self addSubview:_interactionLabel];
		
		_enableInteraction = NO;
	}
	return self;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	if (_enableInteraction) {
		if (self.delegate) {
			[self.delegate viewDidTouched:self];
		}
		
		_enableInteraction = NO;
	}
}

- (void)showWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay {
	[UIView animateWithDuration:duration
						  delay:delay
						options:UIViewAnimationOptionCurveLinear
					 animations:^(void) {
						 [_imageViews objectAtIndex:0].alpha = 0.0f;
					 }
					 completion:^(BOOL finished) {
						 [_imageViews objectAtIndex:0].hidden = YES;
						 
						 [self showTitle];
					 }];
}

- (void)dismissWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay {
	[_interactionLabel.layer removeAllAnimations];
	_interactionLabel.hidden = YES;
	
	[UIView animateWithDuration:0.5f
						  delay:delay
						options:UIViewAnimationOptionCurveLinear
					 animations:^(void) {
						 _titleView.alpha = 0.0f;
					 }
					 completion:^(BOOL finished) {
						 _titleView.hidden = YES;
						 
						 [UIView animateWithDuration:duration
											   delay:0.5f
											 options:UIViewAnimationOptionCurveLinear
										  animations:^(void) {
											  [_imageViews objectAtIndex:1].alpha = 0.0f;
										  }
										  completion:^(BOOL finished) {
											  [_imageViews objectAtIndex:1].hidden = YES;
											  
											  if (self.delegate) {
												  [self.delegate viewDidDismissed:self];
											  }
										  }];
					 }];
}

- (UIView*)createTitleView {
	ContentsInterface* cif = [ContentsInterface sharedInstance];
	
	NSMutableDictionary* attrs = [[NSMutableDictionary alloc] init];
	[attrs setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
	[attrs setObject:[UIFont fontWithName:cif.fontName size:kTitleTextSize] forKey:NSFontAttributeName];
	
	UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	titleLabel.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"launcher_title", nil) attributes:attrs];
	[titleLabel sizeToFit];
	
	[attrs setObject:[UIFont fontWithName:cif.fontName size:kSubtitleTextSize] forKey:NSFontAttributeName];
	
	UILabel* subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	subtitleLabel.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"launcher_subtitle", nil) attributes:attrs];
	[subtitleLabel sizeToFit];
	
	CGRect frame = CGRectInset(self.bounds, 20.0f, 0.0f);
	frame.size.height = titleLabel.frame.size.height + subtitleLabel.frame.size.height + kDistanceOfTitleAndSubtitle;
	
	[subtitleLabel moveBy:CGSizeMake(frame.size.width - subtitleLabel.frame.size.width, titleLabel.frame.size.height + subtitleLabel.frame.size.height)];
	
	UIView* view = [[UIView alloc] initWithFrame:frame];
	[view addSubview:titleLabel];
	[view addSubview:subtitleLabel];
	
	return view;
}

- (void)showTitle {
	_titleView.hidden = NO;
	
	[UIView animateWithDuration:0.5f
						  delay:0.5f
						options:UIViewAnimationOptionCurveLinear
					 animations:^(void) {
						 _titleView.alpha = 1.0f;
					 }
					 completion:^(BOOL finished) {
						 _interactionLabel.hidden = NO;
						 
						 _enableInteraction = YES;
						 
						 if (self.delegate) {
							 [self.delegate viewDidShown:self];
						 }
						 
						 [UIView animateWithDuration:1.0f
											   delay:0.5f
											 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
										  animations:^(void) {
											  _interactionLabel.alpha = 1.0f;
										  }
										  completion:nil];
					 }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent*)event {}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent*)event {}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent*)event {}

@end

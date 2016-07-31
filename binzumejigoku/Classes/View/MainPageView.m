//
//  MainPageView
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/29.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "MainPageView.h"
#import "AppDelegate.h"

static const CGFloat kTitleFontSize		= 28.0f;
static const CGFloat kSummaryFontSize		= 20.0f;
static const CGFloat kSummaryMarginSide	= 14.0f;

@interface MainPageView ()

@property (nonatomic, readwrite)	id	identifier;

- (NSString*)title;
- (void)setTitle:(NSString *)title;
- (NSString*)summary;
- (void)setSummary:(NSString *)summary;
- (UIImage*)backgroundImage;
- (void)setBackgroundImage:(UIImage *)backgroundImage;

@end

@implementation MainPageView

- (id)initWithFrame:(CGRect)frame withTag:(NSInteger)tag {
    if (self = [super initWithFrame:frame]) {
		// 背景画像
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageView.center = self.center;
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.clipsToBounds = YES;
        [self addSubview:_backgroundImageView];
		
		// 章のタイトル。あとで文字列をセット&Resizeするのでここでは最低限の設定のみ
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
		_titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_NAME size:kTitleFontSize];
        _titleLabel.numberOfLines = 1;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:_titleLabel];
		
		// 章の概要。タイトルと同じくあとで文字列をセット&Resizeするのでここでは最低限の設定のみ
		UIEdgeInsets padding = UIEdgeInsetsMake(0.0f, kSummaryMarginSide, 0.0f, kSummaryMarginSide);
		_summaryLabel = [[UILabel alloc] initWithFrame:UIEdgeInsetsInsetRect(self.bounds, padding)];
		_summaryLabel.textAlignment = NSTextAlignmentLeft;
		_summaryLabel.backgroundColor = [UIColor clearColor];
		_summaryLabel.textColor = [UIColor blackColor];
		_summaryLabel.font = [UIFont fontWithName:DEFAULT_FONT_NAME size:kSummaryFontSize];
		_summaryLabel.numberOfLines = 0;
		[self addSubview:_summaryLabel];
		
		self.tag = tag;
    }
	
    return self;
}

- (NSString*)title {
	return _titleLabel.text;
}

- (void)setTitle:(NSString *)title {
	_titleLabel.text = title;
	[_titleLabel sizeToFit];
	_titleLabel.center = CGPointMake(self.bounds.size.width * 0.5f, self.bounds.size.height * 0.2f);
}

- (NSString*)summary {
	return _summaryLabel.text;
}

- (void)setSummary:(NSString *)summary {
	_summaryLabel.text = summary;
	[_summaryLabel sizeToFit];
	
	CGRect frame = _summaryLabel.frame;
	frame.origin.y = self.bounds.size.height * 0.4f;
	_summaryLabel.frame = frame;
}

- (UIImage*)backgroundImage {
	return _backgroundImageView.image;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
	_backgroundImageView.image = backgroundImage;
}

- (void)touchesEnded:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event {
    if (event.type == UIEventTypeTouches) {
		if (self.delegate && [self.delegate respondsToSelector:@selector(viewDidTouch:)]) {
			[self.delegate viewDidTouch:self];
		}
    }
}

@end

//
//  OverlayViewController.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/10/14.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "OverlayViewController.h"
#import "ContentsInterface.h"

static const CGFloat kCloseButtonEdgeLength	= 36.0f;
static const CGFloat kCloseButtonMargin		= 24.0f;
static const CGFloat kTitleDefaultTextSize	= 28.0f;

@interface OverlayViewController ()

@property (nonatomic, readwrite)	UIButton*	closeButton;
@property (nonatomic, readwrite)	UIView*		contentView;

- (void)closeButtonDidPush:(UIButton*)sender;

@end

@implementation OverlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	ContentsInterface* cif = [ContentsInterface sharedInstance];
	
	self.view.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f];
	
	// 閉じるボタン
	self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.closeButton.frame = CGRectMake(self.view.bounds.size.width - (kCloseButtonEdgeLength + kCloseButtonMargin), kCloseButtonMargin, kCloseButtonEdgeLength, kCloseButtonEdgeLength);
	[self.closeButton setImage:[UIImage imageNamed:@"ic_cancel_white.png"] forState:UIControlStateNormal];
	[self.closeButton addTarget:self
						 action:@selector(closeButtonDidPush:)
			   forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.closeButton];

	// タイトルラベル
	_titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	_titleLabel.backgroundColor = [UIColor clearColor];
	_titleLabel.textColor = [UIColor whiteColor];
	_titleLabel.font = [UIFont fontWithName:cif.fontName size:kTitleDefaultTextSize];
	[self.view addSubview:_titleLabel];

	CGPoint contentTop = CGPointMake(0.0f, self.closeButton.frame.origin.y + self.closeButton.frame.size.height + kCloseButtonMargin);
	
	// サブクラスで表示したいものを配置するView
	// UITableViewCellのcontentViewみたいな感じ
	self.contentView = [[UIView alloc] initWithFrame:CGRectMake(contentTop.x, contentTop.y, self.view.bounds.size.width, self.view.bounds.size.height - contentTop.y)];
	[self.view addSubview:self.contentView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {}

- (void)closeButtonDidPush:(UIButton*)sender {
	[self dismissViewControllerAnimated:YES completion:^(void) {
		if (self.delegate) {
			[self.delegate overlayViewControllerDismissed:self];
		}
	}];
}

- (NSString*)titleText {
	return _titleLabel.text;
}

// タイトルが変更されたらラベルのサイズや位置も調節する
- (void)setTitleText:(NSString *)titleText {
	_titleLabel.text = titleText;
	[_titleLabel sizeToFit];
	_titleLabel.center = CGPointMake(self.view.bounds.size.width / 2.0f, self.closeButton.center.y);
}

- (UIModalPresentationStyle)modalPresentationStyle {
	return UIModalPresentationOverCurrentContext;
}

@end

//
//  OverlayViewController.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/10/14.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "OverlayViewController.h"

static const CGFloat kCloseButtonEdgeLength	= 36.0f;
static const CGFloat kCloseButtonMargin		= 24.0f;

@interface OverlayViewController ()

@property (nonatomic, readwrite)	UIButton*	closeButton;
@property (nonatomic, readwrite)	UIView*		contentView;

- (void)closeButtonDidPush:(UIButton*)sender;

@end

@implementation OverlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f];
	
	self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.closeButton.frame = CGRectMake(self.view.bounds.size.width - (kCloseButtonEdgeLength + kCloseButtonMargin), kCloseButtonMargin, kCloseButtonEdgeLength, kCloseButtonEdgeLength);
	[self.closeButton setImage:[UIImage imageNamed:@"ic_cancel_white.png"] forState:UIControlStateNormal];
	[self.closeButton addTarget:self
						 action:@selector(closeButtonDidPush:)
			   forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.closeButton];
	
	CGPoint contentTop = CGPointMake(0.0f, self.closeButton.frame.origin.y + self.closeButton.frame.size.height + kCloseButtonMargin);
	
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

- (UIModalPresentationStyle)modalPresentationStyle {
	return UIModalPresentationOverCurrentContext;
}

@end

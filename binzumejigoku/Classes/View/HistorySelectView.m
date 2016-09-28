//
//  HistorySelectView.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/09/28.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "HistorySelectView.h"
#import "ContentsInterface.h"
#import "UIView+Adjustment.h"

static const CGFloat kSaveButtonHeight			= 100.0f;
static const CGFloat kOptionalButtonSideLength	= 36.0f;
static const CGFloat kOptionalButtonMargin		= 12.0f;

@interface HistorySelectView ()

- (void)closeButtonDidPush:(UIImageView*)sender;
- (void)switchButtonDidPush:(UIImageView*)sender;
- (void)saveButtonDidPush:(UIButton*)sender;

@end

@implementation HistorySelectView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];

		ContentsInterface* cif = [ContentsInterface sharedInstance];
		
		CGRect closeFrame = CGRectMake(0.0f, 0.0f, kOptionalButtonSideLength, kOptionalButtonSideLength);
		closeFrame.origin.x = self.bounds.size.width - closeFrame.size.width - kOptionalButtonMargin;
		closeFrame.origin.y += [UIApplication sharedApplication].statusBarFrame.size.height + kOptionalButtonMargin;
		
		_closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_closeButton.frame = closeFrame;
		[_closeButton setImage:[UIImage imageNamed:@"ic_cancel_white.png"] forState:UIControlStateNormal];
		[_closeButton addTarget:self
						 action:@selector(closeButtonDidPush:)
			   forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_closeButton];
		
		_switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_switchButton.frame = closeFrame;
		[_switchButton moveBy:CGSizeMake((kOptionalButtonSideLength * 2 + kOptionalButtonMargin) * -1.0f, 0.0f)];
		[_switchButton setImage:[UIImage imageNamed:@"ic_swap_horiz_white.png"] forState:UIControlStateNormal];
		[_switchButton addTarget:self
						  action:@selector(switchButtonDidPush:)
				forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:_switchButton];
		
		CGRect buttonFrame = CGRectMake(0.0f, 0.0f, self.bounds.size.width * 0.8f, kSaveButtonHeight);
		
		for (NSInteger idx = 0 ; idx < cif.numberOfHistories ; idx++) {
			UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			button.titleLabel.font = [UIFont fontWithName:cif.fontName
													 size:cif.historyButtonTextSize];
			[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			[button setTitle:[NSString stringWithFormat:@"BUTTON %ld", idx] forState:UIControlStateNormal];
			[button setBackgroundImage:[UIImage imageNamed:@"save_button.png"] forState:UIControlStateNormal];
			button.frame = buttonFrame;
			button.center = CGPointMake(self.bounds.size.width / 2.0f, (self.bounds.size.height * 0.25f) * (idx + 1));
			button.tag = idx;
			[button addTarget:self action:@selector(saveButtonDidPush:) forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:button];
		}
	}
	return self;
}

- (void)closeButtonDidPush:(UIImageView*)sender {
	NSLog(@"CLOSE BUTTON DID PUSH");
}

- (void)switchButtonDidPush:(UIImageView*)sender {
	NSLog(@"SWITCH BUTTON DID PUSH");
}

- (void)saveButtonDidPush:(UIButton*)sender {
	if (self.delegate) {
		[self.delegate historyDidSelected:sender.tag];
	}
}

@end

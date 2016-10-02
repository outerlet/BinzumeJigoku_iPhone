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
static const CGFloat kOptionalButtonMargin		= 24.0f;
static const CGFloat kModeLabelTextSize			= 30.0f;
static const CGFloat kHistoryButtonTextSize		= 18.0f;

@interface HistorySelectView ()

@property (nonatomic, readonly)	CGFloat	marginTop;

- (void)closeButtonDidPush:(UIImageView*)sender;
- (void)switchButtonDidPush:(UIImageView*)sender;
- (void)saveButtonDidPush:(UIButton*)sender;

@end

@implementation HistorySelectView

- (id)initWithFrame:(CGRect)frame closable:(BOOL)closable loadOnly:(BOOL)loadOnly {
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
		
		ContentsInterface* cif = [ContentsInterface sharedInstance];
		
		_modeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_modeLabel.font = [UIFont fontWithName:cif.fontName size:kModeLabelTextSize];
		_modeLabel.textColor = [UIColor whiteColor];
		[self addSubview:_modeLabel];
		self.saveMode = YES;

		CGRect frm = CGRectMake(0.0f, self.marginTop, kOptionalButtonSideLength, kOptionalButtonSideLength);
		frm.origin.x = self.bounds.size.width - frm.size.width - kOptionalButtonMargin;
		
		if (closable) {
			_closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
			_closeButton.frame = frm;
			[_closeButton setImage:[UIImage imageNamed:@"ic_cancel_white.png"] forState:UIControlStateNormal];
			[_closeButton addTarget:self
							 action:@selector(closeButtonDidPush:)
				   forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:_closeButton];
			
			frm.origin.x -= (kOptionalButtonSideLength + kOptionalButtonMargin);
		}
		
		if (!loadOnly) {
			_switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
			_switchButton.frame = frm;
			[_switchButton setImage:[UIImage imageNamed:@"ic_swap_horiz_white.png"] forState:UIControlStateNormal];
			[_switchButton addTarget:self
							  action:@selector(switchButtonDidPush:)
					forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:_switchButton];
		}
		
		CGRect buttonFrame = CGRectMake(0.0f, 0.0f, self.bounds.size.width * 0.8f, kSaveButtonHeight);
		
		NSInteger numberOfHistories = [cif integerSetting:@"NumberOfHistories"];
		
		for (NSInteger idx = 0 ; idx < numberOfHistories ; idx++) {
			UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			button.titleLabel.font = [UIFont fontWithName:cif.fontName
													 size:kHistoryButtonTextSize];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {}

- (CGFloat)marginTop {
	return [UIApplication sharedApplication].statusBarFrame.size.height + kOptionalButtonMargin;
}

- (void)setSaveMode:(BOOL)saveMode {
	_isSaveMode = saveMode;
	
	_modeLabel.text = saveMode ? NSLocalizedString(@"phrase_save", nil) : NSLocalizedString(@"phrase_load", nil);
	[_modeLabel sizeToFit];
	[_modeLabel moveTo:CGPointMake((self.bounds.size.width - _modeLabel.frame.size.width) / 2.0f, self.marginTop)];
}

- (BOOL)saveMode {
	return _isSaveMode;
}

- (BOOL)shown {
	return (!self.hidden && self.alpha == 1.0f);
}

- (void)showAnimated:(BOOL)animated completion:(void (^)(void))completion {
	if (!self.hidden) {
		return;
	}

	self.alpha = 0.0f;
	self.hidden = NO;
	
	if (animated) {
		[UIView animateWithDuration:0.5f
						 animations:^(void) {
							 self.alpha = 1.0f;
						 }
						 completion:^(BOOL finished) {
							 if (completion) {
								 completion();
							 }
						 }];
	} else {
		self.alpha = 1.0f;
		if (completion) {
			completion();
		}
	}
}

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion {
	if (self.hidden) {
		return;
	}
	
	self.alpha = 1.0f;
	
	if (animated) {
		[UIView animateWithDuration:0.5f
						 animations:^(void) {
							 self.alpha = 0.0f;
						 }
						 completion:^(BOOL finished) {
							 self.hidden = YES;
							 
							 if (completion) {
								 completion();
							 }
						 }];
	} else {
		self.alpha = 0.0f;
		self.hidden = YES;
		
		if (completion) {
			completion();
		}
	}
}

- (void)closeButtonDidPush:(UIImageView*)sender {
	[self dismissAnimated:YES completion:nil];
}

- (void)switchButtonDidPush:(UIImageView*)sender {
	self.saveMode = !self.saveMode;
}

- (void)saveButtonDidPush:(UIButton*)sender {
	if (self.delegate) {
		SaveData* saveData = [[ContentsInterface sharedInstance] saveDataAtSlotNumber:sender.tag];
		[self.delegate historyDidSelected:saveData forSave:_isSaveMode];
	}
}

@end

//
//  HistorySelectView.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/09/28.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "HistorySelectView.h"
#import "ContentsInterface.h"
#import "SaveData.h"
#import "UIView+Adjustment.h"
#import "UIColor+CustomColor.h"

static const CGFloat kSaveButtonHeight				= 100.0f;
static const CGFloat kOptionalButtonSideLength		= 36.0f;
static const CGFloat kOptionalButtonMargin			= 24.0f;
static const CGFloat kModeLabelTextSize				= 30.0f;
static const CGFloat kHistoryButtonTitleTextSize	= 20.0f;
static const CGFloat kHistoryButtonDetailTextSize	= 16.0f;

@interface HistorySelectView ()

@property (nonatomic, readonly)	CGFloat	marginTop;

- (void)closeButtonDidPush:(UIImageView*)sender;
- (void)switchButtonDidPush:(UIImageView*)sender;
- (void)saveButtonDidPush:(UIButton*)sender;

@end

@implementation HistorySelectView

- (id)initWithFrame:(CGRect)frame closable:(BOOL)closable loadOnly:(BOOL)loadOnly autoSave:(BOOL)autoSave {
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor translucentBlackColor];
		
		ContentsInterface* cif = [ContentsInterface sharedInstance];
		
		_modeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_modeLabel.font = [UIFont fontWithName:cif.fontName size:kModeLabelTextSize];
		_modeLabel.textColor = [UIColor whiteColor];
		[self addSubview:_modeLabel];
		
		self.saveMode = !loadOnly;

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
		
		BOOL containsAutoSave = (loadOnly && autoSave);
		NSInteger firstIndex = containsAutoSave ? 0 : 1;
		NSInteger numberOfHistories = [cif integerSetting:@"NumberOfHistories"];
		
		CGFloat marginTop = _modeLabel.frame.origin.y + _modeLabel.frame.size.height;
		CGRect frame = CGRectMake(0.0f, 0.0f, self.bounds.size.width * 0.8f, kSaveButtonHeight);
		CGFloat interval = (self.bounds.size.height - marginTop * 2) / ((numberOfHistories - firstIndex + 1) * 2);
		
		NSMutableArray* buttons = [[NSMutableArray alloc] init];
		
		for (NSInteger idx = firstIndex ; idx <= numberOfHistories ; idx++) {
			CGPoint center = CGPointZero;
			center.x = self.bounds.size.width / 2.0f;
			center.y = marginTop + (interval * 2 * (idx - firstIndex)) + interval;
			
			UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
			button.titleLabel.numberOfLines = 3;
			button.titleLabel.textAlignment = NSTextAlignmentCenter;
			[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			[button setBackgroundImage:[UIImage imageNamed:@"save_button_normal.png"]
							  forState:UIControlStateNormal];
			[button setBackgroundImage:[UIImage imageNamed:@"save_button_press.png"]
							  forState:UIControlStateHighlighted];
			[button setBackgroundImage:[UIImage imageNamed:@"save_button_press.png"]
							  forState:UIControlStateDisabled];
			button.frame = frame;
			button.center = center;
			button.tag = idx;
			[button addTarget:self action:@selector(saveButtonDidPush:) forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:button];
			
			[buttons addObject:button];
		}
		
		_historyButtons = [NSArray arrayWithArray:buttons];
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

	for (NSInteger idx = 0 ; idx < _historyButtons.count ; idx++) {
		SaveData* saveData = [[ContentsInterface sharedInstance] saveDataAt:idx];
		[_historyButtons objectAtIndex:idx].enabled = self.saveMode || saveData.isSaved;
	}
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

- (void)refresh {
	for (UIButton* button in _historyButtons) {
		ContentsInterface* cif = [ContentsInterface sharedInstance];
		
		SaveData* saveData = [cif saveDataAt:button.tag];

		NSString* title = nil;
		
		if (saveData.isSaved) {
			NSString* key = [NSString stringWithFormat:@"section_name_%ld", (long)saveData.sectionIndex];
			
			NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
			formatter.dateFormat = @"yyyy/MM/dd hh:mm:ss";
			formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
			NSString* datestr = [formatter stringFromDate:saveData.date];
			
			title = [NSString stringWithFormat:@"%@\n%@\n(%@)", saveData.title, NSLocalizedString(key, nil), datestr];
		} else {
			title = [NSString stringWithFormat:@"%@\n%@", saveData.title, NSLocalizedString(@"save_data_title_not_saved", nil)];
		}
		
		UIFont* titleFont = [UIFont fontWithName:cif.fontName size:kHistoryButtonTitleTextSize];
		UIFont* detailFont = [UIFont fontWithName:cif.fontName size:kHistoryButtonDetailTextSize];
		
		NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
		style.paragraphSpacing = titleFont.lineHeight * 0.5f;
		style.alignment = NSTextAlignmentCenter;
		
		NSMutableAttributedString* attributed = [[NSMutableAttributedString alloc] initWithString:title];
		[attributed addAttribute:NSFontAttributeName value:titleFont range:NSMakeRange(0, saveData.title.length)];
		[attributed addAttribute:NSFontAttributeName value:detailFont range:NSMakeRange(saveData.title.length, title.length - saveData.title.length)];
		[attributed addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, title.length)];
		[attributed addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, title.length)];

		[button setAttributedTitle:attributed forState:UIControlStateNormal];
		button.enabled = self.saveMode || saveData.isSaved;
	}
}

- (void)closeButtonDidPush:(UIImageView*)sender {
	[self dismissAnimated:YES completion:nil];
}

- (void)switchButtonDidPush:(UIImageView*)sender {
	self.saveMode = !self.saveMode;
	[self refresh];
}

- (void)saveButtonDidPush:(UIButton*)sender {
	if (self.delegate) {
		SaveData* saveData = [[ContentsInterface sharedInstance] saveDataAt:sender.tag];
		[self.delegate historyDidSelected:saveData forSave:_isSaveMode];
	}
}

@end

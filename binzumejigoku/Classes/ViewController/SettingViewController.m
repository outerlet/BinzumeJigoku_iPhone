//
//  SettingViewController.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/29.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "SettingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ContentsInterface.h"
#import "SettingTableViewCell.h"
#import "TutorialViewController.h"
#import "UIView+Adjustment.h"

static NSString* const kCellIdPrefix = @"CELL-ID_%02ld_%02ld";

static const CGFloat kHeightForSectionHeader	= 40.0f;
static const CGFloat kHeightForRow				= 80.0f;
static const CGFloat kSettingSubviewTextSize	= 18.0f;

static const NSInteger kAlertTagTextSpeed				= 10001;
static const NSInteger kAlertActionTagTextSpeedSlow		= 2;
static const NSInteger kAlertActionTagTextSpeedNormal	= 1;
static const NSInteger kAlertActionTagTextSpeedFast		= 0;

static const NSInteger kAlertTagTextSize				= 10002;
static const NSInteger kAlertActionTagTextSizeSmall		= 0;
static const NSInteger kAlertActionTagTextSizeNormal	= 1;
static const NSInteger kAlertActionTagTextSizeLarge		= 2;

// 青空文庫の図書カードを表示させるためのView
@interface AboutWorkView : UIView

@end

@implementation AboutWorkView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];
		
		UIView* baseView = [[UIView alloc] initWithFrame:self.bounds];
		baseView.backgroundColor = [UIColor whiteColor];
		baseView.layer.borderWidth = 1.0f;
		baseView.layer.borderColor = [UIColor blackColor].CGColor;
		baseView.layer.cornerRadius = 4.0f;
		[self addSubview:baseView];

		NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
		style.minimumLineHeight = style.maximumLineHeight = 22.0f;

		UIFont* font = [UIFont fontWithName:[ContentsInterface sharedInstance].fontName size:kSettingSubviewTextSize];
		NSDictionary* attrs = @{ NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor blackColor], NSParagraphStyleAttributeName: style };
		
		UILabel* label = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 10.0f, 0.0f)];
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentLeft;
		label.numberOfLines = 0;
		label.userInteractionEnabled = NO;
		label.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"setting_detail_about_work", nil) attributes:attrs];
		[label sizeToFit];
		[label moveTo:CGPointMake((self.bounds.size.width - label.frame.size.width) / 2.0f, (self.bounds.size.height - label.frame.size.height) / 2.0f)];
		[self addSubview:label];
	}
	return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	if (!self.hidden) {
		self.hidden = YES;
	}
}

@end

@interface SettingViewController ()

@property (nonatomic) UITableView*	tableView;

- (NSString*)cellIdentifierForIndexPath:(NSIndexPath*)indexPath;
- (NSString*)cellSubjectForIndexPath:(NSIndexPath*)indexPath;
- (NSString*)cellDescriptionForIndexPath:(NSIndexPath*)indexPath;

@end

@implementation SettingViewController

#pragma mark - Initializer

- (id)init {
	if (self = [super init]) {
		// iOS7以降(?)ではUITableViewControllerを使うとステータスバーの下にセルが潜り込んで表示されてしまう
		// StoryBoardでないとそれを解消するのが容易ではなさそうなので、ここでは敢えてUITableViewを使っている
		// (StoryBoard使えばええやん、とか野暮なことは言わない方向でひとつ...)
		CGRect tblFrame = UIEdgeInsetsInsetRect(self.view.bounds, UIEdgeInsetsMake([UIApplication sharedApplication].statusBarFrame.size.height, 0.0f, 0.0f, 0.0f));
		self.tableView = [[UITableView alloc] initWithFrame:tblFrame];
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
		self.tableView.sectionHeaderHeight = kHeightForSectionHeader;
		self.tableView.rowHeight = kHeightForRow;
		self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
		[self.view addSubview:self.tableView];

		// 青空文庫の図書カードを表示するためのView
		// Bottom=49.0fをとっているのはタブバーの高さぶん
		CGRect wkFrame = UIEdgeInsetsInsetRect(self.view.bounds, UIEdgeInsetsMake([UIApplication sharedApplication].statusBarFrame.size.height, 0.0f, 49.0f, 0.0f));
		_aboutWorkView = [[AboutWorkView alloc] initWithFrame:CGRectInset(wkFrame, 10.0f, 10.0f)];
		[self.view addSubview:_aboutWorkView];
		_aboutWorkView.hidden = YES;
	}
	return self;
}

#pragma mark - UITableView & UITableViewDataSource Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// 設定項目とその他の2セクション
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// セクションごとに2項目ずつ
	return 2;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return NSLocalizedString(@"setting_section_title_settings", nil);
		case 1:
			return NSLocalizedString(@"setting_section_title_other", nil);
		default:
			break;
	}
	
	return nil;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString* cellId = [self cellIdentifierForIndexPath:indexPath];
	SettingTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
	
	if (!cell) {
		cell = [[SettingTableViewCell alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.bounds.size.width, kHeightForRow) reuseIdentifier:cellId];
		cell.subjectLabel.text = [self cellSubjectForIndexPath:indexPath];
		cell.descriptionLabel.text = [self cellDescriptionForIndexPath:indexPath];
		cell.selectionStyle = UITableViewCellSelectionStyleDefault;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	// 設定
	if (indexPath.section == 0) {
		// テキスト速度
		if (indexPath.row == 0) {
			AlertControllerHandler* handler = [[AlertControllerHandler alloc] initWithTitle:NSLocalizedString(@"setting_subject_text_speed", @"SETTING:TEXT-SPEED") message:nil preferrdStyle:UIAlertControllerStyleActionSheet tag:kAlertTagTextSpeed];
			[handler addAction:NSLocalizedString(@"phrase_slow", @"TEXT-SPEED:SLOW") style:UIAlertActionStyleDefault tag:kAlertActionTagTextSpeedSlow];
			[handler addAction:NSLocalizedString(@"phrase_normal", @"TEXT-SPEED:NORMAL") style:UIAlertActionStyleDefault tag:kAlertActionTagTextSpeedNormal];
			[handler addAction:NSLocalizedString(@"phrase_fast", @"TEXT-SPEED:FAST") style:UIAlertActionStyleDefault tag:kAlertActionTagTextSpeedFast];
			handler.delegate = self;
			
			[self presentViewController:[handler build] animated:YES completion:nil];
		// テキストサイズ
		} else if (indexPath.row == 1) {
			AlertControllerHandler* handler = [[AlertControllerHandler alloc] initWithTitle:NSLocalizedString(@"setting_description_text_size", @"SETTING:TEXT-SIZE") message:nil preferrdStyle:UIAlertControllerStyleActionSheet tag:kAlertTagTextSize];
			[handler addAction:NSLocalizedString(@"phrase_small", @"TEXT-SIZE:SMALL") style:UIAlertActionStyleDefault tag:kAlertActionTagTextSizeSmall];
			[handler addAction:NSLocalizedString(@"phrase_normal", @"TEXT-SIZE:NORMAL") style:UIAlertActionStyleDefault tag:kAlertActionTagTextSizeNormal];
			[handler addAction:NSLocalizedString(@"phrase_large", @"TEXT-SIZE:LARGE") style:UIAlertActionStyleDefault tag:kAlertActionTagTextSizeLarge];
			handler.delegate = self;
			
			[self presentViewController:[handler build] animated:YES completion:nil];
		}
	// その他
	} else if (indexPath.section == 1) {
		// チュートリアル
		if (indexPath.row == 0) {
			TutorialViewController* vc = [[TutorialViewController alloc] initWithTutorialType:TutorialTypeAll];
			[self presentViewController:vc animated:YES completion:nil];
		// このアプリについて
		} else if (indexPath.row == 1) {
			_aboutWorkView.hidden = NO;
		}
	}
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	// 以下、UITableViewのseparatorでseparatorにマージンができてしまうのを防ぐための設定
	if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
		[cell setSeparatorInset:UIEdgeInsetsZero];
	}
	
	if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
		[cell setPreservesSuperviewLayoutMargins:NO];
	}
	
	if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
		[cell setLayoutMargins:UIEdgeInsetsZero];
	}
}

#pragma mark - AlertControllerHandler Delegate
	
- (void)alertDidConfirmAt:(NSInteger)alertTag action:(NSInteger)actionTag {
	ContentsInterface* cif = [ContentsInterface sharedInstance];
	
	if (alertTag == kAlertTagTextSpeed) {
		CGFloat speed = (CGFloat)[[[cif.settings objectForKey:@"TextSpeed"] objectAtIndex:actionTag] floatValue];
		cif.textSpeedInterval = speed;
	} else if (alertTag == kAlertTagTextSize) {
		CGFloat size = (CGFloat)[[[cif.settings objectForKey:@"TextSize"] objectAtIndex:actionTag] floatValue];
		cif.textSize = size;
	}
}

#pragma mark - Original Convenience Method

- (NSString*)cellIdentifierForIndexPath:(NSIndexPath*)indexPath {
	return [NSString stringWithFormat:@"%@_%02ld_%02ld", kCellIdPrefix, (long)indexPath.section, (long)indexPath.row];
}

- (NSString*)cellSubjectForIndexPath:(NSIndexPath*)indexPath {
	if (indexPath.section == 0) {
		switch (indexPath.row) {
			case 0:
				return NSLocalizedString(@"setting_subject_text_speed", nil);
			case 1:
				return NSLocalizedString(@"setting_subject_text_size", nil);
		}
	} else if (indexPath.section == 1) {
		switch (indexPath.row) {
			case 0:
				return NSLocalizedString(@"setting_subject_tutorial", nil);
			case 1:
				return NSLocalizedString(@"setting_subject_about_work", nil);
		}
	}
	
	return nil;
}

- (NSString*)cellDescriptionForIndexPath:(NSIndexPath*)indexPath {
	if (indexPath.section == 0) {
		switch (indexPath.row) {
			case 0:
				return NSLocalizedString(@"setting_description_text_speed", nil);
			case 1:
				return NSLocalizedString(@"setting_description_text_size", nil);
		}
	} else if (indexPath.section == 1) {
		switch (indexPath.row) {
			case 0:
				return NSLocalizedString(@"setting_description_tutorial", nil);
			case 1:
				return NSLocalizedString(@"setting_description_about_work", nil);
		}
	}
	
	return nil;
}

@end

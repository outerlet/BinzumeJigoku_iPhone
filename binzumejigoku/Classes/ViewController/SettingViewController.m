//
//  SettingViewController.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/29.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"
#import "CoreDataHandler.h"

static NSString* const kCellIdPrefix			= @"CELL-ID_%02ld_%02ld";
static const CGFloat kHeightForSectionHeader	= 40.0f;
static const CGFloat kHeightForRow				= 80.0f;

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
		CGRect tf = UIEdgeInsetsInsetRect(self.view.bounds, UIEdgeInsetsMake([UIApplication sharedApplication].statusBarFrame.size.height, 0.0f, 0.0f, 0.0f));
		
		// iOS7以降(?)ではUITableViewControllerを使うとステータスバーの下にセルが潜り込んで表示されてしまう
		// StoryBoardでないとそれを解消するのが容易ではなさそうなので、ここでは敢えてUITableViewを使っている
		self.tableView = [[UITableView alloc] initWithFrame:tf];
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
		self.tableView.sectionHeaderHeight = kHeightForSectionHeader;
		self.tableView.rowHeight = kHeightForRow;
		self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
		[self.view addSubview:self.tableView];
	}
	return self;
}

#pragma mark - UITableView & UITableViewDataSource Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// 設定項目2、課金1、アプリの紹介1
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// 設定項目だけ2行、その他は1行
	return (section != 0) ? 1 : 2;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return NSLocalizedString(@"setting_section_title_settings", nil);
		case 1:
			return NSLocalizedString(@"setting_section_title_purchase", nil);
		case 2:
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
	
	NSArray* results = [[CoreDataHandler sharedInstance] newFetchedResultController].fetchedObjects;
	for (NSManagedObject* obj in results) {
		NSNumber* sec = [obj valueForKey:@"section"];
		NSNumber* seq = [obj valueForKey:@"sequence"];
		NSString* type = [obj valueForKey:@"type"];
		
		NSLog(@"section = %ld, sequence = %ld, type = %@", [sec integerValue], [seq integerValue], type);
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

#pragma mark - Original Convenience Method

- (NSString*)cellIdentifierForIndexPath:(NSIndexPath*)indexPath {
	return [NSString stringWithFormat:@"%@_%02ld_%02ld", kCellIdPrefix, indexPath.section, indexPath.row];
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
		return NSLocalizedString(@"setting_subject_purchase", nil);
	} else if (indexPath.section == 2) {
		return NSLocalizedString(@"setting_subject_about_work", nil);
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
		return NSLocalizedString(@"setting_description_purchase", nil);
	} else if (indexPath.section == 2) {
		return NSLocalizedString(@"setting_description_about_work", nil);
	}
	
	return nil;
}

@end

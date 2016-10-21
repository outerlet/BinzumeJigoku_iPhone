//
//  HistoryViewController.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/29.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "HistoryViewController.h"
#import "AppDelegate.h"
#import "AlertControllerHandler.h"
#import "ContentsViewController.h"
#import "SaveData.h"
#import "ContentsInterface.h"

static const NSInteger kAlertTagConfirm		= 0;
static const NSInteger kAlertActionTagYes	= 11;
static const NSInteger kAlertActionTagNo	= 12;

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
	imageView.contentMode = UIViewContentModeScaleAspectFill;
	imageView.image = [UIImage imageNamed:@"title_00.jpg"];
	[self.view addSubview:imageView];
	
	_historyView = [[HistorySelectView alloc] initWithFrame:self.view.bounds closable:NO loadOnly:YES autoSave:YES];
	_historyView.saveMode = NO;
	_historyView.delegate = self;
	[self.view addSubview:_historyView];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[_historyView refresh];
}

- (void)historyDidSelected:(SaveData*)saveData forSave:(BOOL)forSave {
	_selectedData = saveData;
	
	AlertControllerHandler* alert = [[AlertControllerHandler alloc] initWithTitle:nil message:NSLocalizedString(@"history_confirm_load", nil) preferrdStyle:UIAlertControllerStyleAlert tag:kAlertTagConfirm];
	alert.delegate = self;
	[alert addAction:NSLocalizedString(@"phrase_ok", nil) style:UIAlertActionStyleDefault tag:kAlertActionTagYes];
	[alert addAction:NSLocalizedString(@"phrase_cancel", nil) style:UIAlertActionStyleCancel tag:kAlertActionTagNo];
	
	[self presentViewController:[alert build] animated:YES completion:nil];
}

- (void)alertDidConfirmAt:(NSInteger)alertTag action:(NSInteger)actionTag {
	if (alertTag == kAlertTagConfirm && actionTag == kAlertActionTagYes && _selectedData) {
		ContentsViewController* vc = [[ContentsViewController alloc] initWithSaveData:_selectedData];
		[self presentViewController:vc animated:YES completion:nil];
	}
}

@end

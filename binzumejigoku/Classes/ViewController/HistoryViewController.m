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

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
	imageView.contentMode = UIViewContentModeScaleAspectFill;
	imageView.image = [UIImage imageNamed:@"title_00.jpg"];
	[self.view addSubview:imageView];
	
	HistorySelectView* historyView = [[HistorySelectView alloc] initWithFrame:self.view.bounds closable:NO loadOnly:YES autoSave:YES];
	historyView.saveMode = NO;
	historyView.delegate = self;
	[self.view addSubview:historyView];
}

- (void)historyDidSelected:(SaveData*)saveData forSave:(BOOL)forSave {
	_selected = saveData;
	
	AlertControllerHandler* alert = [[AlertControllerHandler alloc] initWithTitle:nil message:NSLocalizedString(@"history_confirm_load", nil) preferrdStyle:UIAlertControllerStyleAlert tag:0];
	alert.delegate = self;
	[alert addAction:NSLocalizedString(@"phrase_ok", nil) style:UIAlertActionStyleDefault tag:0];
	[alert addAction:NSLocalizedString(@"phrase_cancel", nil) style:UIAlertActionStyleCancel tag:1];
	
	[self presentViewController:[alert build] animated:YES completion:nil];
}

- (void)alertDidConfirmAt:(NSInteger)alertTag action:(NSInteger)actionTag {
	if (alertTag == 0) {
		NSLog(actionTag == 0 ? @"OK" : @"Cancel");
		NSLog(@"selected : %ld", _selected.slotNumber);
		
		SaveData* saveData = [[ContentsInterface sharedInstance] saveDataAtSlotNumber:0];
		
		NSLog(@"Slot = %ld, Section = %ld, Sequence = %ld", saveData.slotNumber, saveData.sectionIndex, saveData.sequence);
		
		ContentsViewController* vc = [[ContentsViewController alloc] initWithSaveData:saveData];
		[self presentViewController:vc animated:YES completion:nil];
	}
}

@end

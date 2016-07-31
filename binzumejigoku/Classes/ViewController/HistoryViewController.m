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

static const NSInteger kNumberOfSaveSlot	= 3;
static const CGFloat kButtonHeight			= 100.0f;

@interface HistoryViewController ()

- (void)buttonDidPush:(UIButton*)sender;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
	imageView.contentMode = UIViewContentModeScaleAspectFill;
	imageView.image = [UIImage imageNamed:@"title_00.jpg"];
	[self.view addSubview:imageView];
	
	CGRect buttonFrame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width * 0.8f, kButtonHeight);
	
	for (NSInteger idx = 0 ; idx < kNumberOfSaveSlot ; idx++) {
		UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		button.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_NAME size:20.0f];
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[button setTitle:[NSString stringWithFormat:@"BUTTON %ld", idx] forState:UIControlStateNormal];
		[button setBackgroundImage:[UIImage imageNamed:@"save_button.png"] forState:UIControlStateNormal];
		button.frame = buttonFrame;
		button.center = CGPointMake(self.view.bounds.size.width / 2.0f, (self.view.bounds.size.height * 0.25f) * (idx + 1));
		button.tag = idx;
		[button addTarget:self action:@selector(buttonDidPush:) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:button];
	}
}

- (void)buttonDidPush:(UIButton*)sender {
	AlertControllerHandler* alert = [[AlertControllerHandler alloc] initWithTitle:nil message:NSLocalizedString(@"history_confirm_load", nil) preferrdStyle:UIAlertControllerStyleAlert tag:0];
	alert.delegate = self;
	[alert addAction:NSLocalizedString(@"phrase_ok", nil) style:UIAlertActionStyleDefault tag:0];
	[alert addAction:NSLocalizedString(@"phrase_cancel", nil) style:UIAlertActionStyleCancel tag:1];
	
	[self presentViewController:[alert build] animated:YES completion:nil];
}

- (void)alertDidConfirmAt:(NSInteger)alertTag action:(NSInteger)actionTag {
	if (alertTag == 0) {
		NSLog(actionTag == 0 ? @"OK" : @"Cancel");
	}
}

@end

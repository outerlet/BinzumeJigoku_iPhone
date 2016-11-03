//
//  MainMenuTabBarController.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/10/16.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "MainMenuTabBarController.h"
#import "ContentsInterface.h"
#import "ContentsSelectViewController.h"
#import "HistoryViewController.h"
#import "SettingViewController.h"

@implementation MainMenuTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 物語を選択する、メインとなるViewController
    ContentsSelectViewController* selectController = [[ContentsSelectViewController alloc] init];
    selectController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"tab_name_story", nil) image:[UIImage imageNamed:@"ic_play.png"] tag:0];
    [self addChildViewController:selectController];
    
    // セーブ&ロードを担当するViewController
    HistoryViewController* historyController = [[HistoryViewController alloc] init];
    historyController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"tab_name_load", nil) image:[UIImage imageNamed:@"ic_save.png"] tag:1];
    [self addChildViewController:historyController];
    
    // 設定画面を表示するViewController
    SettingViewController* settingController = [[SettingViewController alloc] init];
    settingController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"tab_name_settings", nil) image:[UIImage imageNamed:@"ic_settings.png"] tag:2];
    [self addChildViewController:settingController];
    
    self.selectedIndex = 0;
	
	_launcherView = [[LauncherView alloc] initWithFrame:self.view.bounds];
	_launcherView.delegate = self;
	[self.view addSubview:_launcherView];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	[_launcherView showWithDuration:1.0f delay:1.0f];
}

- (void)parseDidFinished:(BOOL)executed {
	[_launcherView dismissWithDuration:1.0f delay:1.0f];
}

- (void)parseErrorDidOccurred:(NSError*)error {
    NSLog(@"XML parse error : %@", error);
}

- (void)overlayViewControllerDismissed:(id)sender {
	[ContentsInterface sharedInstance].tutorialStatus = TutorialStatusAboutApplication;
}

- (void)viewDidShown:(LauncherView*)sender {
	// Do nothing.
}

- (void)viewDidDismissed:(LauncherView *)sender {
	_launcherView.hidden = YES;
	
	// チュートリアルを表示したことがなければ表示する
	if ([ContentsInterface sharedInstance].tutorialStatus == TutorialStatusNotStarted) {
		TutorialViewController* vc = [[TutorialViewController alloc] initWithTutorialType:TutorialTypeAboutApplication];
		vc.delegate = self;
		[self presentViewController:vc animated:YES completion:nil];
	}
}

- (void)viewDidTouched:(LauncherView*)sender {
	ContentsParser* parser = [[ContentsParser alloc] init];
	parser.delegate = self;
	[parser parse];
}

@end

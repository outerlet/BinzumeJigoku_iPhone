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

@interface LaunchImageView : UIView {
	@private
	UIImageView*	_imageViewFirst;
	UIImageView*	_imageViewSecond;
}

- (void)show:(void (^)(void))completion;
- (void)dismiss:(void (^)(void))completion;

@end

@implementation LaunchImageView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		_imageViewSecond = [[UIImageView alloc] initWithFrame:self.bounds];
		_imageViewSecond.contentMode = UIViewContentModeScaleAspectFill;
		_imageViewSecond.image = [UIImage imageNamed:@"launch_01.jpg"];
		[self addSubview:_imageViewSecond];
		
		_imageViewFirst = [[UIImageView alloc] initWithFrame:self.bounds];
		_imageViewFirst.contentMode = UIViewContentModeScaleAspectFill;
		_imageViewFirst.image = [UIImage imageNamed:@"launch_00.jpg"];
		[self addSubview:_imageViewFirst];
	}
	return self;
}

- (void)show:(void (^)(void))completion {
	_imageViewSecond.hidden = NO;
	
	[UIView animateWithDuration:2.0f
						  delay:1.0f
						options:UIViewAnimationOptionCurveLinear
					 animations:^(void) {
						 _imageViewFirst.alpha = 0.0f;
					 }
					 completion:^(BOOL finished) {
						 _imageViewFirst.hidden = YES;
						 
						 if (completion) {
							 completion();
						 }
					 }];
}

- (void)dismiss:(void (^)(void))completion {
	[UIView animateWithDuration:2.0f
					 animations:^(void) {
						 _imageViewSecond.alpha = 0.0f;
					 }
					 completion:^(BOOL finished) {
						 _imageViewSecond.hidden = YES;
						 
						 if (completion) {
							 completion();
						 }
					 }];
}

@end

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
	
	_imageView = [[LaunchImageView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:_imageView];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	ContentsParser* parser = [[ContentsParser alloc] init];
	parser.delegate = self;

	[_imageView show:^(void) {
		[parser parse];
	}];
}

- (void)parseDidFinished:(BOOL)executed {
	// チュートリアルを表示したことがなければ表示する
	if ([ContentsInterface sharedInstance].tutorialStatus == TutorialStatusNotStarted) {
		TutorialViewController* vc = [[TutorialViewController alloc] initWithTutorialType:TutorialTypeAboutApplication];
		vc.delegate = self;
		[self presentViewController:vc animated:YES completion:nil];
	} else {
		[_imageView dismiss:^(void) {
			_imageView.hidden = YES;
		}];
	}
}

- (void)parseErrorDidOccurred:(NSError *)error {
    NSLog(@"XML parse error : %@", error);
}

- (void)overlayViewControllerDismissed:(id)sender {
	[ContentsInterface sharedInstance].tutorialStatus = TutorialStatusAboutApplication;
	
	[_imageView dismiss:^(void) {
		_imageView.hidden = YES;
	}];
}

@end

//
//  MainMenuTabBarController.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/10/16.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "MainMenuTabBarController.h"
#import "ContentsInterface.h"

@interface MainMenuTabBarController ()

@end

@implementation MainMenuTabBarController

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if ([ContentsInterface sharedInstance].tutorialStatus == TutorialStatusNotStarted) {
		TutorialViewController* vc = [[TutorialViewController alloc] initWithTutorialType:TutorialTypeAboutApplication];
		vc.delegate = self;
		[self presentViewController:vc animated:YES completion:nil];
	}
}

- (void)overlayViewControllerDismissed:(id)sender {
	[ContentsInterface sharedInstance].tutorialStatus = TutorialStatusAboutApplication;
}

@end

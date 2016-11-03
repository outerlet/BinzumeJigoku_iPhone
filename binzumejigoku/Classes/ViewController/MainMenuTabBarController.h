//
//  MainMenuTabBarController.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/10/16.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentsParser.h"
#import "TutorialViewController.h"
#import "LauncherView.h"

/**
 * アプリのメインメニューをタブで表示するTabBarController
 */
@interface MainMenuTabBarController : UITabBarController <ContentsParserDelegate, OverlayViewControllerDelegate, LauncherViewDelegate> {
    @private
	LauncherView*				_launcherView;
    UIActivityIndicatorView*    _indicator;
}

@end

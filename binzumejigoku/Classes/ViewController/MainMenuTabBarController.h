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

@class LaunchImageView;

/**
 * アプリのメインメニューをタブで表示するTabBarController
 */
@interface MainMenuTabBarController : UITabBarController <ContentsParserDelegate, OverlayViewControllerDelegate> {
    @private
	LaunchImageView*			_imageView;
    UIActivityIndicatorView*    _indicator;
}

@end

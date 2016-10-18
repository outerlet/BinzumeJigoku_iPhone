//
//  MainViewController.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/29.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainPageView.h"

/**
 * 読む章を選択するためのViewController<br />
 * アプリケーションのメイン画面
 */
@interface ContentsSelectViewController : UIViewController <MainPageViewDelegate> {
    @private
    UIScrollView*   _scrollView;
}

@end
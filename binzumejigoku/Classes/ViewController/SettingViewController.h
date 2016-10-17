//
//  SettingViewController.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/29.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertControllerHandler.h"

@class AboutWorkView;

@interface SettingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AlertControllerHandlerDelegate> {
	@private
	AboutWorkView*	_aboutWorkView;
}

@end

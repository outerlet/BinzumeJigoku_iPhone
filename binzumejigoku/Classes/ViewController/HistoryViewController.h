//
//  HistoryViewController.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/29.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertControllerHandler.h"
#import "HistorySelectView.h"

@class SaveData;

/**
 * 任意の箇所から再開するためにセーブデータを選択させるViewController
 */
@interface HistoryViewController : UIViewController <HistorySelectViewDelegate, AlertControllerHandlerDelegate> {
	@private
	HistorySelectView*	_historyView;
	SaveData*			_selectedData;
}

@end

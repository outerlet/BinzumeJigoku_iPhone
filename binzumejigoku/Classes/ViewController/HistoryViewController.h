//
//  HistoryViewController.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/29.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertControllerHandler.h"

typedef NS_ENUM(NSUInteger, HistoryBackgroundType) {
	HistoryBackgroundTypeBlackTranslucent = 0,
	HistoryBackgroundTypeLaunchImage,
};

@interface HistoryViewController : UIViewController <AlertControllerHandlerDelegate> {
	@private
	HistoryBackgroundType _backgroundType;
}

- (id)initWithBackgroundType:(HistoryBackgroundType)backgroundType;

@end

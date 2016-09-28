//
//  HistorySelectView.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/09/28.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HistorySelectViewDelegate <NSObject>

- (void)historyDidSelected:(NSInteger)slotNumber;

@end

@interface HistorySelectView : UIView {
	@private
	NSArray<UIButton*>*	_historyButtons;
	UIButton*			_closeButton;
	UIButton*			_switchButton;
}

@property (nonatomic)	id<HistorySelectViewDelegate>	delegate;

@end

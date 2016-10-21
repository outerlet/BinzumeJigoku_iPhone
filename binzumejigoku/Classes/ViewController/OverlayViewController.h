//
//  OverlayViewController.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/10/14.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * OverlayViewControllerで発生したイベントを捕捉するためのデリゲート
 */
@protocol OverlayViewControllerDelegate <NSObject>

/**
 * ViewControllerが閉じたというイベントを捉える
 * @param	sender	閉じたViewController自身
 */
- (void)overlayViewControllerDismissed:(id)sender;

@end

/**
 * チュートリアルやテキスト履歴など、他のViewControllerの上に被さって表示などするViewController<br />
 * このクラスを継承すれば背景はUIColor.translucentBlackColorで、かつ閉じるボタンが配置された画面となる
 */
@interface OverlayViewController : UIViewController {
	@private
	UILabel*	_titleLabel;
}

@property (nonatomic)	id<OverlayViewControllerDelegate>	delegate;

/** 閉じるボタン */
@property (nonatomic, readonly)	UIButton*	closeButton;

/** タイトル */
@property (nonatomic)	NSString*	titleText;

/** 閉じるボタンの直下から画面下端までの領域を占めるView */
@property (nonatomic, readonly)	UIView*		contentView;

@end

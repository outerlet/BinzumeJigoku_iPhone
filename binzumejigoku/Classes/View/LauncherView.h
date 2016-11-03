//
//  LaunchImageView.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/11/03.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LauncherView;

/**
 * LauncherViewに発生した諸々のイベントを捕捉するためのデリゲート
 */
@protocol LauncherViewDelegate <NSObject>

/**
 * Viewが表示されたタイミングで呼び出される
 * @param	sender	イベントの発生元であるLauncherView
 */
- (void)viewDidShown:(LauncherView*)sender;

/**
 * Viewが非表示になったタイミングで呼び出される
 * @param	sender	イベントの発生元であるLauncherView
 */
- (void)viewDidDismissed:(LauncherView*)sender;

/**
 * Viewがタッチされたタイミングで呼び出される
 * @param	sender	イベントの発生元であるLauncherView
 */
- (void)viewDidTouched:(LauncherView*)sender;

@end

/**
 * アプリ起動後、スプラッシュスクリーンのあとに表示されるタイトル表示用のView<br />
 * ContentsImageViewと構造は似通っているが、起動時の挙動だけを色々弄りたいので継承関係などの無い独立したクラスで作成
 */
@interface LauncherView : UIView {
	@private
	UIView*					_titleView;
	UILabel*				_interactionLabel;
	NSArray<UIImageView*>*	_imageViews;
	
	BOOL	_enableInteraction;
}

/**
 * このViewに対して随時発生したアクションを捕捉するデリゲートオブジェクト
 */
@property (nonatomic)	id<LauncherViewDelegate>	delegate;

/**
 * 指定した任意の時間をかけてViewを表示する
 * @param	duration	Viewの表示にかける時間
 * @param	delay		表示を開始するまでに設ける遅延時間
 * @param	completion	表示されたあとに実行されるブロック
 */
- (void)showWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay;

/**
 * 指定した任意の時間をかけてViewを非表示にする
 * @param	duration	Viewを非表示にするのにかける時間
 * @param	delay		非表示を開始するまでに設ける遅延時間
 * @param	completion	表示されたあとに実行されるブロック
 */
- (void)dismissWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay;

@end

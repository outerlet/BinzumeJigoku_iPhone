//
//  AlertControllerHandler.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/31.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * AlertControllerHandlerを使って表示したアラートに対してインタラクションが
 * 発生した時にそのイベントを受け取るデリゲートメソッド
 */
@protocol AlertControllerHandlerDelegate <NSObject>

/**
 * AlertControllerHandlerで生成したアラートに対してインタラクションが発生した、というイベントを受け取る
 * @param	alertTag	AlertControllerHandlerのイニシャライザで指定した、アラートを一意に特定するためのタグ
 * @param	actionTag	AlertControllerHandlerのaddAction:style:tag:で指定した、インタラクションを一意に特定するためのタグ
 */
- (void)alertDidConfirmAt:(NSInteger)alertTag action:(NSInteger)actionTag;

@end

/**
 * UIAlertControllerを使用するためのインターフェイス
 */
@interface AlertControllerHandler : NSObject {
	@private
	NSInteger				_tag;
	NSString*				_title;
	NSString*				_message;
	UIAlertControllerStyle	_style;
	NSMutableArray*			_alertActions;
}

@property (nonatomic)	id<AlertControllerHandlerDelegate>	delegate;

/**
 * イニシャライザ
 * @param	title	アラートのタイトル
 * @param	message	アラートのメッセージ
 * @param	style	アラートのスタイル
 * @param	tag		アラートを一意に特定するためのタグ
 * @return	インスタンス
 */

- (id)initWithTitle:(NSString*)title message:(NSString*)message preferrdStyle:(UIAlertControllerStyle)style tag:(NSInteger)tag;

/**
 * アラートにアクションを追加する
 * @param	title	アクションのタイトル
 * @param	style	アクションのスタイル
 * @param	tag		アクションを一意に特定するためのタグ
 */
- (void)addAction:(NSString*)title style:(UIAlertActionStyle)style tag:(NSInteger)tag;

/**
 * イニシャライザとaddAction:style:tag:で指定したパラメータをもとにUIAlertControllerの
 * インスタンスを生成する
 * @return	UIAlertControllerのインスタンス
 */
- (UIAlertController*)build;

@end

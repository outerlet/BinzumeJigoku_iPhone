//
//  ContentsInterface.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/09/20.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * コンテンツの表示に関係する共通機能やプロパティを提供するシングルトンクラス
 */
@interface ContentsInterface : NSObject {
	@private
	NSString*	_rubyClosure;
	NSString*	_rubyDelimiter;
}

/** ルビ無しテキストとルビありテキストを区別するための区切り文字 */
@property (nonatomic)	NSString*	rubyClosure;

/** ルビありテキストで、ルビとテキストを区別するための区切り文字 */
@property (nonatomic)	NSString*	rubyDelimiter;

/**
 * アプリに唯一のContentsInterfaceのオブジェクトを取得する<br />
 * このクラスのオブジェクトを使う場合はこれを使う。alloc+initで初期化して使わないこと
 * @return	ContentsInterfaceオブジェクト
 */
+ (ContentsInterface*)sharedInstance;

/**
 * オブジェクトを初期する
 */
- (void)initialize;

@end

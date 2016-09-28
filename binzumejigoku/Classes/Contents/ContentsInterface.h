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
	NSInteger	_maxSectionIndex;
	NSString*	_rubyClosure;
	NSString*	_rubyDelimiter;
	CGFloat		_textSpeedInterval;
	CGFloat		_textSize;
}

@property (nonatomic, readonly)	NSDictionary*	settings;

/** 最後のセクションを特定するインデックス値 */
@property (nonatomic)	NSInteger	maxSectionIndex;

/** ルビ無しテキストとルビありテキストを区別するための区切り文字 */
@property (nonatomic)	NSString*	rubyClosure;

/** ルビありテキストで、ルビとテキストを区別するための区切り文字 */
@property (nonatomic)	NSString*	rubyDelimiter;

/** コンテンツを記録したXMLファイルの場所を示すURL */
@property (nonatomic, readonly)	NSURL*	contentsFileUrl;

/** フォント名 */
@property (nonatomic, readonly)	NSString*	fontName;

/** 章タイトルのテキストサイズ(pt) */
@property (nonatomic, readonly)	CGFloat	titleTextSize;

/** セーブデータ選択ボタンのテキストサイズ */
@property (nonatomic, readonly)	CGFloat	historyButtonTextSize;

@property (nonatomic, readonly)	CGFloat	summaryTitleTextSize;
@property (nonatomic, readonly)	CGFloat	summaryDescriptionTextSize;

@property (nonatomic, readonly)	CGFloat	settingSubjectTextSize;
@property (nonatomic, readonly)	CGFloat	settingDescriptionTextSize;
@property (nonatomic, readonly)	CGFloat	settingSubviewTextSize;

@property (nonatomic, readonly)	NSInteger	numberOfHistories;

/** 1文字あたりのテキスト送り早さ(sec) */
@property (nonatomic)	CGFloat	textSpeedInterval;

/** テキストサイズ(pt) */
@property (nonatomic)	CGFloat	textSize;

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

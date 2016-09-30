//
//  ContentsInterface.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/09/20.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SaveData;

/**
 * コンテンツの表示に関係する共通機能やプロパティを提供するシングルトンクラス
 */
@interface ContentsInterface : NSObject {
	@private
	NSInteger			_maxSectionIndex;
	NSString*			_rubyClosure;
	NSString*			_rubyDelimiter;
	CGFloat				_textSpeedInterval;
	CGFloat				_textSize;
	NSArray<SaveData*>*	_saveDatas;
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

/**
 * 任意のセーブスロット番号にあるセーブデータを返却する
 * @param	slotNumber	セーブスロット番号
 * @return	スロット番号に対応するセーブデータ
 */
- (SaveData*)saveDataAtSlotNumber:(NSInteger)slotNumber;

/**
 * AppSetting.plistから任意のキー文字列に対応するNSInteger値を取得する
 * @param	key	plistから値を取得するためのキー文字列
 * @return	plistに記録されているNSInteger値
 */
- (NSInteger)integerSetting:(NSString*)key;

/**
 * AppSetting.plistから任意のキー文字列に対応するCGFloat値を取得する
 * @param	key	plistから値を取得するためのキー文字列
 * @return	plistに記録されているCGFloat値
 */
- (CGFloat)floatSetting:(NSString*)key;

@end

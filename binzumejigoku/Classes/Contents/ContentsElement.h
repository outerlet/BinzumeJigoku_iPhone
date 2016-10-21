//
//  ContentsElement.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/01.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ContentsType.h"
#import "ChainType.h"

// Core Dataにデータを挿入するときのカラム名
static NSString* const AttributeNameSection		= @"section";
static NSString* const AttributeNameSequence	= @"sequence";
static NSString* const AttributeNameType		= @"type";
static NSString* const AttributeNameCommon0		= @"common0";
static NSString* const AttributeNameCommon1		= @"common1";
static NSString* const AttributeNameCommon2		= @"common2";
static NSString* const AttributeNameValue0		= @"value0";
static NSString* const AttributeNameValue1		= @"value1";
static NSString* const AttributeNameValue2		= @"value2";
static NSString* const AttributeNameValue3		= @"value3";
static NSString* const AttributeNameValue4		= @"value4";
static NSString* const AttributeNameValue5		= @"value5";
static NSString* const AttributeNameValue6		= @"value6";
static NSString* const AttributeNameValue7		= @"value7";
static NSString* const AttributeNameValue8		= @"value8";
static NSString* const AttributeNameValue9		= @"value9";
static NSString* const AttributeNameText		= @"text";

/**
 * コンテンツの各要素が共通で継承する基底クラス
 */
@interface ContentsElement : NSObject {
	@private
	NSString*	_chainString;
}

/** セクション(=章)番号 */
@property (nonatomic, readonly)	NSInteger section;

/** セクションを構成する要素の通し番号 */
@property (nonatomic, readonly)	NSInteger sequence;

/** ユーザーの操作を待つことなく次の要素に進むかどうかを示すchain属性の種類 */
@property (nonatomic, readonly) ChainType chainType;

/** 「テキスト」や「画像」など要素の種類 */
@property (nonatomic, readonly) ContentsType contentsType;

/**
 * Core DataのManaged Objectから、コンテンツの種類に見合ったインスタンスを生成する
 * @param	managedObject	CoreDataから取得したManaged Object
 */
+ (ContentsElement*)contentsElementWithManagedObject:(NSManagedObject*)managedObject;

/**
 * イニシャライザ<br />
 * XMLをパースした結果からオブジェクトを生成するときはこちらを使う
 */
- (id)initWithSection:(NSInteger)section sequence:(NSInteger)sequence attribute:(NSDictionary*)attrs object:(id)obj;

/**
 * イニシャライザ<br />
 * Core Dataを使ってfetchした結果得られたManaged Objectからオブジェクトを生成するときはこちらを使う
 */
- (id)initWithManagedObject:(NSManagedObject*)managedObject;

/**
 * オブジェクトを表現する文字列を返却する
 */
- (NSString*)stringValue;

/**
 * "Contents"エンティティにデータを保存するためのManaged Objectを生成する
 */
- (NSManagedObject*)createManagedObject;

@end

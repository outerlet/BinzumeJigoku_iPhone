//
//  SaveData.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/09/25.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContentsElement;

/**
 * セーブデータの保存や読み出しを担当する
 */
@interface SaveData : UIView <NSCoding>

/** スロット番号 */
@property (nonatomic, readonly)	NSInteger									slotNumber;

/** タイトル文字列 */
@property (nonatomic)			NSString*									title;

/** セーブが作成された日付(UTC) */
@property (nonatomic, readonly)	NSDate*										date;

/** セーブされた時点まで進行していたセクション番号 */
@property (nonatomic)			NSInteger									sectionIndex;

/** セーブされた時点まで進行していたセクション中の通し番号 */
@property (nonatomic, readonly)	NSInteger									sequence;

/** セーブされた時点で復元すべきコンテンツの要素とその通し番号 */
@property (nonatomic, readonly)	NSMutableDictionary<NSNumber*, NSNumber*>*	elementSequences;

/** セーブされた時点までのテキスト履歴 */
@property (nonatomic, readonly)	NSMutableArray<NSString*>*					textHistories;

/** このオブジェクトにセーブデータが存在するかどうか */
@property (nonatomic, readonly)	BOOL										isSaved;

/**
 * イニシャライザ<br />
 * セーブスロット番号を与えてインスタンスを初期化する
 * @param	slotNumber	セーブスロット番号
 * @return	初期化されたインスタンス
 */
- (id)initWithSlotNumber:(NSInteger)slotNumber;

/**
 * セーブの対象にしたいコンテンツ(の要素)を追加する<br />
 * elementを順番にaddElementしていけば、最後がセーブ時点で読み込むべき箇所となる
 * @param	element	セーブの対象にしたいコンテンツ要素
 */
- (void)addElement:(ContentsElement*)element;

/**
 * otherに保存されているものをこのセーブデータにコピーする
 * @param	other			コピー元となるセーブデータ
 * @param	includeTitle	コピーするものの中にタイトル文字列(titleプロパティ)も含めるならYES
 */
- (void)copyFrom:(SaveData*)other includeTitle:(BOOL)includeTitle;

/**
 * 端末にセーブデータをシリアライズして保存する
 */
- (void)save;

/**
 * シリアライズされたセーブデータを端末からロードする
 * @return	ロードが行われたならYES
 */
- (BOOL)load;

/**
 * セーブデータをリセットする<br />
 * スロット番号、タイトル文字列以外がすべて失われる
 */
- (void)reset;

@end

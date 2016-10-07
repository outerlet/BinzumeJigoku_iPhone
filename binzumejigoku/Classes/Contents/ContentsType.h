//
//  ContentsType.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/20.
//  Copyright © 2016年 1-Take. All rights reserved.
//

/**
 * コンテンツの種類を示す列挙値
 */
typedef NS_ENUM(NSUInteger, ContentsType) {
	/** 便宜上の値であり使用されない */
	ContentsTypeUnknown = 0,
	/** コンテンツを表示する上で必要なメタデータ */
	ContentsTypeMetaData,
	/** セクション(章) */
	ContentsTypeSection,
	/** 区切り。これ以降がコンテンツを表現するために使われる値 */
	ContentsTypeContentsValue,
	/** 画像表示または切り替え */
	ContentsTypeImage = ContentsTypeContentsValue,
	/** 一定時間待機 */
	ContentsTypeWait,
	/** タイトル表示 */
	ContentsTypeTitle,
	/** テキスト表示 */
	ContentsTypeText,
	/** テキスト消去 */
	ContentsTypeClearText,
	/** 他のコンテンツタイプに包含されるサブタイプ */
	ContentsTypeContentsSubtype,
	/** テキスト表示(ルビ) */
	ContentsTypeTextRuby = ContentsTypeContentsSubtype,
	/** テキスト表示(UTF-16文字列) */
	ContentsTypeTextUTF16,
};

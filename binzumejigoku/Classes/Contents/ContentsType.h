//
//  ContentsType.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/20.
//  Copyright © 2016年 1-Take. All rights reserved.
//

typedef NS_ENUM(NSUInteger, ContentsType) {
	ContentsTypeUnknown = 0,							// 便宜上の値であり使用されない
	ContentsTypeMetaData,								// コンテンツを表示する上で必要なメタデータ
	ContentsTypeSection,								// セクション(章)
	ContentsTypeContentsValue,							// 区切り。これ以降がコンテンツを表現するために使われる値
	ContentsTypeImage = ContentsTypeContentsValue,		// 画像表示または切り替え
	ContentsTypeWait,									// 一定時間待機
	ContentsTypeTitle,									// タイトル表示
	ContentsTypeText,									// テキスト表示
	ContentsTypeClearText,								// テキスト消去
	ContentsTypeContentsSubtype,						// 他のコンテンツタイプに包含されるサブタイプ
	ContentsTypeTextRuby = ContentsTypeContentsSubtype,	// テキスト表示(ルビ)
	ContentsTypeTextUTF16,								// テキスト表示(UTF-16文字列)
};

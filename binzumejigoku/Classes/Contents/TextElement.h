//
//  TextElement.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/08.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "ContentsElement.h"

/**
 * テキストと、それに振られるルビをセットで保持する
 */
@interface TextRubyPair : NSObject

/** テキスト */
@property (nonatomic, readonly) NSString*	text;

/** ルビ */
@property (nonatomic, readonly) NSString*	ruby;

/**
 * コンビニエンスコンストラクタ
 * @param	text	テキスト
 * @param	ruby	ルビ
 * @return	生成・初期化済みのオブジェクト
 */
+ (id)pairWithText:(NSString*)text ruby:(NSString*)ruby;

@end

/**
 * テキストの表示を制御する要素オブジェクト
 */
@interface TextElement : ContentsElement {
	@private
	NSString*	_alignmentString;
	NSString*	_indentString;
	NSString*	_colorString;
}

/** テキストの寄せ方 */
@property (nonatomic, readonly) NSTextAlignment alignment;

/** インデント。文字数で指定 */
@property (nonatomic, readonly) NSInteger indent;

/** テキストカラー */
@property (nonatomic, readonly) UIColor* color;

/** テキスト */
@property (nonatomic, readonly) NSString* text;

@end

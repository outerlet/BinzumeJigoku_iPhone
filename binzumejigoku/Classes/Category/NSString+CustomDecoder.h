//
//  UIColor+HexString.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/08.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ContentsType.h"
#import "ImageElement.h"

/**
 * このアプリで使う様々なオブジェクトを生成するためにNSStringを拡張したカテゴリ
 */
@interface NSString (CustomDecoder)

/**
 * ContentsType列挙値から要素名を生成する
 */
+ (NSString*)stringWithContentsType:(ContentsType)contentsType;

/**
 * 8桁のHEX値(#ffffffff)からUIColorオブジェクトを生成する
 */
- (UIColor*)decodeToColor;

/**
 * UTF16文字列からデコードされたNSStringオブジェクトを生成する
 */
- (NSString*)decodeUTF16String;

/**
 * "chain"属性の値からChainType列挙値を生成する
 */
- (ChainType)decodeToChainType;

/**
 * 要素名からContentsType列挙値を生成する
 */
- (ContentsType)decodeToContentsType;

/**
 * ImageEffectに対応する文字列からImageEffect列挙値を生成する
 */
- (ImageEffect)decodeToImageEffect;

/**
 * 画像のプレフィックス(=拡張子なし)からUIImageオブジェクトを生成する
 */
- (UIImage*)decodeToUIImage;

/**
 * "align"属性に相当するNSTextAlignmentの値を返却する
 */
- (NSTextAlignment)decodeToTextAlignment;

@end

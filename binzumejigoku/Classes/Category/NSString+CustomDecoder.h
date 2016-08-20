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

@interface NSString (CustomDecoder)

/**
 * 8桁のHEX値(#ffffffff)からUIColorオブジェクトを生成する
 */
- (UIColor*)decodeToColor;

/**
 * UTF16文字列からデコードされたNSStringオブジェクトを生成する
 */
- (NSString*)decodeUTF16String;

/**
 * 要素名からContentsType列挙値を生成する
 */
- (ContentsType)decodeToContentsType;

@end

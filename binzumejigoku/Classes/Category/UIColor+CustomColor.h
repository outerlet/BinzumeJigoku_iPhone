//
//  UIColor+CustomColor.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/10/19.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * このアプリで共通に使用する色をUIColorのクラスメソッドとして生成できるようにしたカテゴリ
 */
@interface UIColor (CustomColor)

/**
 * 透過状態の黒色を返却する
 * @return	幾つかのViewの背景色に使われている透過状態の黒
 */
+ (UIColor*)translucentBlackColor;

@end

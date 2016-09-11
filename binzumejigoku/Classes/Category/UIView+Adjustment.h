//
//  UIView+Positioning.h
//  SampleApp
//
//  Created by Shizuo Ichitake on 2016/09/11.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Adjustment)

/**
 * 移動先を指定してViewを移動する
 * @param destination	移動先
 */
- (void)moveTo:(CGPoint)destination;

/**
 * 移動距離(現在地からの差分)を指定してViewを移動する
 * @param distance	移動距離
 */
- (void)moveBy:(CGSize)distance;

/**
 * サイズを指定してViewをリサイズする
 * @param newSize	サイズ
 */
- (void)resizeTo:(CGSize)newSize;

/**
 * 現在の大きさからの差分を指定してViewをリサイズする
 * @param destination	現在の大きさからの差分
 */
- (void)resizeBy:(CGSize)increment;

@end

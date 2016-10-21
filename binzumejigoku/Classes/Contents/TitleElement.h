//
//  TitleElement.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/08.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "ContentsElement.h"

/**
 * セクションタイトルの表示を制御する要素オブジェクト
 */
@interface TitleElement : ContentsElement

/** タイトル文字列 */
@property (nonatomic, readonly) NSString*	title;

@end

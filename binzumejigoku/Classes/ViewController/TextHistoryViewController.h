//
//  TextHistoryViewController.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/10/04.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverlayViewController.h"

/**
 * テキスト履歴を表示するViewController
 */
@interface TextHistoryViewController : OverlayViewController {
	@private
	NSArray<NSString*>*	_textHistories;
}

/**
 * イニシャライザ
 * @param	textHistories	テキスト履歴を格納した配列
 * @return	初期化されたインスタンス
 */
- (id)initWithTextHistories:(NSArray<NSString*>*)textHistories;

@end

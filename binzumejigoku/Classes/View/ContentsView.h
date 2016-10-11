//
//  ContentsView.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/10/06.
//  Copyright © 2016年 1-Take. All rights reserved.
//

/**
 * Contents...で始まるViewクラスに適用されるプロトコル<br />
 * 共通の手続きで各ViewにContentsElementを処理させるための実装
 */
@protocol ContentsView <NSObject>

/**
 * 与えられたelementを処理する
 * @param	element		ContentsElementオブジェクト
 * @param	completion	処理した後に呼び出されるブロック
 */
- (void)handleElement:(id)element completion:(void (^)(void))completion;

@end

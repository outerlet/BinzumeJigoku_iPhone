//
//  Utility.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/09/25.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 便利メソッドを集めたユーティリティクラス
 */
@interface Utility : NSObject

/**
 * アプリが使用するドキュメントディレクトリの場所を示すURLオブジェクトを返却する
 * @return	ドキュメントディレクトリを示すURL
 */
+ (NSURL*)applicationDocumentDirectory;

@end

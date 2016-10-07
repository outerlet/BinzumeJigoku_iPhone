//
//  ChainType.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/20.
//  Copyright © 2016年 1-Take. All rights reserved.
//

/**
 * コンテンツを連続して再生するかどうかを示すchain属性値
 */
typedef NS_ENUM(NSUInteger, ChainType) {
	/** コンテンツを連続して再生しない */
	ChainTypeNone,
	/** コンテンツを連続して再生させる(前のコンテンツが完了するまで待機) */
	ChainTypeWait,
	/** コンテンツを連続して再生させる(前のコンテンツの完了を待たない) */
	ChainTypeImmediate,
};

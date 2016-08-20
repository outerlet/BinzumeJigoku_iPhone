//
//  ChainType.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/20.
//  Copyright © 2016年 1-Take. All rights reserved.
//

typedef NS_ENUM(NSUInteger, ChainType) {
	ChainTypeNone,		// コンテンツを連続して再生しない
	ChainTypeWait,		// コンテンツを連続して再生させる(前のコンテンツが完了するまで待機)
	ChainTypeImmediate,	// コンテンツを連続して再生させる(前のコンテンツの完了を待たない)
};

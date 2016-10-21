//
//  WaitElement.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/08.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "ContentsElement.h"

/**
 * コンテンツの進行を一定時間待機する要素オブジェクト
 */
@interface WaitElement : ContentsElement {
	@private
	NSString*	_durationString;
}

/** 待機時間 */
@property (nonatomic, readonly) double	duration;

@end

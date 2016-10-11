//
//  ContentsWaitingIndicatorView.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/09/22.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * テキスト送りを待っている間に点滅して、ユーザの入力を待っていることを示すView
 */
@interface ContentsWaitingIndicatorView : UIView {
	@private
	UIImageView*	_imageView;
}

/**
 * 点滅アニメーションを開始する
 */
- (void)startAnimation;

/**
 * 点滅アニメーションを終了する
 */
- (void)stopAnimation;

@end

//
//  ContentsImageView.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/27.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentsView.h"
#import "ImageElement.h"

@class ContentsImageView;

/**
 * 画像を表示するためのView
 */
@interface ContentsImageView : UIView <ContentsView> {
	@private
	NSArray*	_imageViews;
	UIImage*	_nextImage;
}

/**
 * 次に表示する画像をセットする。現在表示している画像を非表示にするだけならimageにnilを与える<br />
 * セットした画像はstartAnimationWithEffect:duration:が呼び出されるまで表示されない
 */
- (void)setNextImage:(UIImage*)image;

/**
 * setNextImageでセットした画像を表示させるアニメーションを、effectに指定した効果で開始する
 */
- (void)startAnimationWithEffect:(ImageEffect)effect duration:(NSTimeInterval)duration completion:(void (^)(void))completion;

- (void)showImmediate;

- (void)reset;

@end

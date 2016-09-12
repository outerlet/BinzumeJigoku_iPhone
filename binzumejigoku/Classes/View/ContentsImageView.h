//
//  ContentsImageView.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/27.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageElement.h"

@class ContentsImageView;

/**
 * ContentsImageViewで発生したイベント(=アニメーション)を捕捉するためのデリゲート
 */
@protocol ContentsImageViewDelegate <NSObject>

/**
 * ContentsImageViewのアニメーションが終了した
 */
- (void)imageViewAnimationDidFinish:(ContentsImageView*)imageView;

@end

/**
 * 画像を表示するためのView
 */
@interface ContentsImageView : UIView {
	@private
	NSArray*	_imageViews;
	UIImage*	_nextImage;
}

@property (nonatomic)	id<ContentsImageViewDelegate>	delegate;

/**
 * 次に表示する画像をセットする。現在表示している画像を非表示にするだけならimageにnilを与える<br />
 * セットした画像はstartAnimationWithEffect:duration:が呼び出されるまで表示されない
 */
- (void)setNextImage:(UIImage*)image;

/**
 * setNextImageでセットした画像を表示させるアニメーションを、effectに指定した効果で開始する
 */
- (void)startAnimationWithEffect:(ImageEffect)effect duration:(NSTimeInterval)duration;

@end
//
//  Image.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/08.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "ContentsElement.h"

/**
 * 画像を表示するときにかけるエフェクトの種類
 */
typedef NS_ENUM(NSUInteger, ImageEffect) {
	/** 不明(初期化などで便宜上使用する値。使用しない) */
	ImageEffectUnknown = 0,
	/** フェードイン・アウト */
	ImageEffectFade,
	/** カットイン・アウト */
	ImageEffectCut,
};

/**
 * 画像の表示を制御する要素オブジェクト
 */
@interface ImageElement : ContentsElement {
	@private
	NSString*	_imageName;
	NSString*	_durationString;
	NSString*	_effectString;
}

/** 表示する画像オブジェクト */
@property (nonatomic, readonly) UIImage* image;

/** 画像の表示にかける時間 */
@property (nonatomic, readonly) double duration;

/** 画像を表示するときにかけるエフェクト */
@property (nonatomic, readonly) ImageEffect imageEffect;

@end

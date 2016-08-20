//
//  Image.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/08.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "ContentsElement.h"

typedef NS_ENUM(NSUInteger, ImageEffect) {
	ImageEffectUnknown = 0,
	ImageEffectFade,
	ImageEffectCut,
};

@interface ImageElement : ContentsElement

@property (nonatomic, readonly) UIImage*	image;
@property (nonatomic, readonly) double		duration;
@property (nonatomic, readonly) ImageEffect	imageEffect;

@end

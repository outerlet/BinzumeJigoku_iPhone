//
//  Image.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/08.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "ImageElement.h"

@interface ImageElement () {
	NSString*	_src;
}

@property (nonatomic, readwrite) UIImage*		image;
@property (nonatomic, readwrite) double			duration;
@property (nonatomic, readwrite) ImageEffect	imageEffect;

- (ImageEffect)convertToImageEffect:(NSString*)str;

@end

@implementation ImageElement

- (id)initWithAttribute:(NSDictionary *)attrs object:(id)obj {
	if (self = [super initWithAttribute:attrs object:obj]) {
		// 画像
		_src = [attrs objectForKey:@"src"];
		UIImage* img = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", _src]];
		if (!img) {
			img = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", _src]];
		}
		self.image = img;
		
		// エフェクトを掛ける所要時間
		self.duration = [[attrs objectForKey:@"duration"] doubleValue];
		
		// エフェクトの種類(フェード or カット)
		self.imageEffect = [self convertToImageEffect:[attrs objectForKey:@"effect"]];
	}
	return self;
}

- (ContentsType)contentsType {
	return ContentsTypeImage;
}

- (NSString*)stringValue {
	return [NSString stringWithFormat:@"Image : src = %@", _src];
}

- (ImageEffect)convertToImageEffect:(NSString*)str {
	if ([[str lowercaseString] isEqualToString:@"fade"]) {
		return ImageEffectFade;
	} else if ([[str lowercaseString] isEqualToString:@"cut"]) {
		return ImageEffectCut;
	}
	
	return ImageEffectUnknown;
}

@end

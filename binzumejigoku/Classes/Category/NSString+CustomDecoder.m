//
//  UIColor+HexString.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/08.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "NSString+CustomDecoder.h"

@implementation NSString (CustomDecoder)

+ (NSString*)stringWithContentsType:(ContentsType)contentsType {
	switch (contentsType) {
		case ContentsTypeImage:
			return @"image";
		case ContentsTypeWait:
			return @"wait";
		case ContentsTypeTitle:
			return @"title";
		case ContentsTypeText:
			return @"text";
		case ContentsTypeClearText:
			return @"clear-text";
		default: ;
	}
	
	return nil;
}

- (UIColor*)decodeToColor {
	NSString* str = [self hasPrefix:@"#"] ? [self substringFromIndex:1] : self;
	
	unsigned int alphaInt = 0;
	NSScanner* alphaScan = [NSScanner scannerWithString:[str substringWithRange:NSMakeRange(0, 2)]];
	[alphaScan scanHexInt:&alphaInt];
	
	float alpha = (float)((alphaInt & 0x0000ff) >> 0) / 255.0f;
	
	unsigned int colorInt = 0;
	NSScanner* colorScan = [NSScanner scannerWithString:[str substringFromIndex:2]];
	[colorScan scanHexInt:&colorInt];
	
	float red = (float)((colorInt & 0xff0000) >> 16) / 255.0f;
	float green = (float)((colorInt & 0x00ff00) >> 8) / 255.0f;
	float blue = (float)((colorInt & 0x0000ff) >> 0) / 255.0f;
	
	return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (NSString*)decodeUTF16String {
	NSString* source = [self hasPrefix:@"\\u"] ? self : [NSString stringWithFormat:@"\\u%@", self];
	NSMutableString* converted = [source mutableCopy];
	CFStringTransform((CFMutableStringRef)converted, NULL, CFSTR("Any-Hex/Java"), YES);
	
	return [NSString stringWithString:converted];
}

- (ChainType)decodeToChainType {
	if ([[self lowercaseString] isEqualToString:@"wait"]) {
		return ChainTypeWait;
	} else if ([[self lowercaseString] isEqualToString:@"immediate"]) {
		return ChainTypeImmediate;
	}
	
	return ChainTypeNone;
}

- (ContentsType)decodeToContentsType {
	if ([self isEqualToString:@"meta-data"]) {
		return ContentsTypeMetaData;
	} else if ([self isEqualToString:@"section"]) {
		return ContentsTypeSection;
	} else if ([self isEqualToString:@"image"]) {
		return ContentsTypeImage;
	} else if ([self isEqualToString:@"wait"]) {
		return ContentsTypeWait;
	} else if ([self isEqualToString:@"title"]) {
		return ContentsTypeTitle;
	} else if ([self isEqualToString:@"text"]) {
		return ContentsTypeText;
	} else if ([self isEqualToString:@"ruby"]) {
		return ContentsTypeTextRuby;
	} else if ([self isEqualToString:@"u16"]) {
		return ContentsTypeTextUTF16;
	} else if ([self isEqualToString:@"clear-text"]) {
		return ContentsTypeClearText;
	}
	
	return ContentsTypeUnknown;
}

- (ImageEffect)decodeToImageEffect {
	if ([[self lowercaseString] isEqualToString:@"fade"]) {
		return ImageEffectFade;
	} else if ([[self lowercaseString] isEqualToString:@"cut"]) {
		return ImageEffectCut;
	}
	
	return ImageEffectUnknown;
}

- (UIImage*)decodeToUIImage {
	UIImage* img = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", self]];
	if (!img) {
		img = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", self]];
	}
	
	return img;
}

- (NSTextAlignment)decodeToTextAlignment {
	if ([[self lowercaseString] isEqualToString:@"right"]) {
		return NSTextAlignmentRight;
	}
	return NSTextAlignmentLeft;
}

@end

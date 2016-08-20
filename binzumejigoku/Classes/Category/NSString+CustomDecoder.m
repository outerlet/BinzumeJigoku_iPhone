//
//  UIColor+HexString.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/08.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "NSString+CustomDecoder.h"

@implementation NSString (CustomDecoder)

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
	NSMutableString* converted = [self mutableCopy];
	CFStringTransform((CFMutableStringRef)converted, NULL, CFSTR("Any-Hex/Java"), YES);
	
	return [NSString stringWithString:converted];
}


/**
 * selfに与えられた文字列から、それに合致するContentsTypeを返却する
 */
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

@end

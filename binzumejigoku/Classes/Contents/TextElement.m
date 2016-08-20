//
//  TextElement.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/08.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "TextElement.h"
#import "NSString+CustomDecoder.h"

@interface TextRubyPair ()

@property (nonatomic, readwrite) NSString*	text;
@property (nonatomic, readwrite) NSString*	ruby;

@end

@implementation TextRubyPair

+ (id)pairWithText:(NSString*)text ruby:(NSString*)ruby {
	TextRubyPair* obj = [[TextRubyPair alloc] init];
	obj.text = text;
	obj.ruby = ruby;
	
	return obj;
}

@end

@interface TextElement ()

@property (nonatomic, readwrite) NSTextAlignment	alignment;
@property (nonatomic, readwrite) NSInteger			indent;
@property (nonatomic, readwrite) UIColor*			color;
@property (nonatomic, readwrite) NSString*			text;

- (NSTextAlignment)convertToTextAlignment:(NSString*)str;

@end

@implementation TextElement

- (id)initWithAttribute:(NSDictionary *)attrs object:(id)obj {
	if (self = [super initWithAttribute:attrs object:obj]) {
		self.alignment = [self convertToTextAlignment:[attrs objectForKey:@"align"]];
		self.indent = [[attrs objectForKey:@"indent"] integerValue];
		self.color = [[attrs objectForKey:@"color"] decodeToColor];
		self.text = (NSString*)obj;
	}
	return self;
}

- (ContentsType)contentsType {
	return ContentsTypeText;
}

- (NSString*)stringValue {
	return [NSString stringWithFormat:@"Text : text = %@", self.text];
}

- (NSTextAlignment)convertToTextAlignment:(NSString*)str {
	if ([[str lowercaseString] isEqualToString:@"right"]) {
		return NSTextAlignmentRight;
	}
	return NSTextAlignmentLeft;
}

@end

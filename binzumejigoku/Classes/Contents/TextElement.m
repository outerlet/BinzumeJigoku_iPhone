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

@end

@implementation TextElement

- (id)initWithSection:(NSInteger)section sequence:(NSInteger)sequence attribute:(NSDictionary *)attrs object:(id)obj {
	if (self = [super initWithSection:section sequence:sequence attribute:attrs object:obj]) {
		_alignmentString = [attrs objectForKey:@"align"];
		_indentString = [attrs objectForKey:@"indent"];
		_colorString = [attrs objectForKey:@"color"];
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

- (NSManagedObject*)createManagedObject {
	NSManagedObject* obj = [super createManagedObject];
	
	[obj setValue:_alignmentString forKey:AttributeNameValue0];
	[obj setValue:_indentString forKey:AttributeNameValue1];
	[obj setValue:_colorString forKey:AttributeNameValue2];
	[obj setValue:self.text forKey:AttributeNameText];
	
	return obj;
}

@end

//
//  TextElement.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/08.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "ContentsElement.h"

@interface TextRubyPair : NSObject

@property (nonatomic, readonly) NSString*	text;
@property (nonatomic, readonly) NSString*	ruby;

+ (id)pairWithText:(NSString*)text ruby:(NSString*)ruby;

@end

@interface TextElement : ContentsElement {
	@private
	NSString*	_alignmentString;
	NSString*	_indentString;
	NSString*	_colorString;
}

@property (nonatomic, readonly) NSTextAlignment	alignment;
@property (nonatomic, readonly) NSInteger		indent;
@property (nonatomic, readonly) UIColor*		color;
@property (nonatomic, readonly) NSString*		text;

@end

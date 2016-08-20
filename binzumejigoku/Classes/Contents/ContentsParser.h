//
//  ContentsParser.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/01.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentsType.h"

@interface ContentsParser : NSObject <NSXMLParserDelegate> {
	@private
	NSXMLParser*	_parser;
	
	NSInteger		_section;
	NSString*		_rubyClosure;
	NSString*		_rubyDelimiter;
	
	NSMutableArray*	_mutableElements;
	NSInteger		_sequence;
	ContentsType	_currentType;
	NSDictionary*	_currentAttributes;
	id				_currentObject;
}

@property (nonatomic, readonly) NSArray*	elements;

- (void)parse;

@end

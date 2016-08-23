//
//  ContentsParser.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/01.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentsType.h"

@protocol ContentsParserDelegate <NSObject>

- (void)parseDidFinished;
- (void)parseErrorDidOccurred:(NSError*)error;

@end

@interface ContentsParser : NSObject <NSXMLParserDelegate> {
	@private
	NSXMLParser*	_parser;
	
	NSInteger		_section;
	NSString*		_rubyClosure;
	NSString*		_rubyDelimiter;
	
	NSInteger		_sequence;
	ContentsType	_currentType;
	NSDictionary*	_currentAttributes;
	id				_currentObject;
}

@property (nonatomic)	id<ContentsParserDelegate>	delegate;

/**
 *	XMLのパースを開始する
 */
- (void)parse;

@end

//
//  ContentsParser.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/01.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentsType.h"

/**
 * XMLをパースした後に呼び出されるデリゲート
 */
@protocol ContentsParserDelegate <NSObject>

/**
 * XMLのパース処理が完了した後に呼び出される
 * @param	executed	実際にXMLのパース処理が行われたかどうか.既にパース済みの場合はNOが入る
 */
- (void)parseDidFinished:(BOOL)executed;

/**
 * XMLのパースに失敗した際に呼び出される
 * @param	error	パース処理が失敗した際のエラー内容
 */
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

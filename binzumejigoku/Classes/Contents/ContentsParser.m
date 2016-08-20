//
//  ContentsParser.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/01.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "ContentsParser.h"
#import "TextElement.h"
#import "ContentsElement.h"
#import "ImageElement.h"
#import "WaitElement.h"
#import "TitleElement.h"
#import "TextElement.h"
#import "ClearTextElement.h"
#import "NSString+CustomDecoder.h"

static NSString* const kSettingPlistName	= @"AppSetting";

@interface ContentsParser ()

@property (nonatomic, readwrite) NSArray*	elements;

@end

@implementation ContentsParser

- (id)init {
	if (self = [super init]) {
		NSBundle* bundle = [NSBundle mainBundle];
		
		NSDictionary* settings = [NSDictionary dictionaryWithContentsOfFile:[bundle pathForResource:kSettingPlistName ofType:@"plist"]];
		
		NSString* path = [bundle pathForResource:[settings objectForKey:@"ContentsFilePrefix"]
										  ofType:[settings objectForKey:@"ContentsFileSuffix"]];
		
		_parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path]];
		_parser.delegate = self;
		
		_mutableElements = [[NSMutableArray alloc] init];
		
		_currentType = ContentsTypeUnknown;
	}
	
	return self;
}

/**
 *	XMLのパースを開始した
 */
- (void)parse {
	[_parser parse];
	
	self.elements = [NSArray arrayWithArray:_mutableElements];
}

#pragma mark - NSXMLParser Delegate

// 開始タグを検出した
- (void)parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName attributes:(NSDictionary<NSString*,NSString*>*)attributeDict {
	ContentsType type = [elementName decodeToContentsType];
	
	if (type != ContentsTypeUnknown) {
		_currentType = type;
		
		if (type >= ContentsTypeContentsValue) {
			_currentAttributes = attributeDict;
			
			if (type == ContentsTypeText) {
				_currentObject = [[NSMutableString alloc] init];
			}
		} else if (type == ContentsTypeMetaData) {
			_rubyClosure = [attributeDict objectForKey:@"ruby_closure"];
			_rubyDelimiter = [attributeDict objectForKey:@"ruby_delimiter"];
		} else if (type == ContentsTypeSection) {
			_section = [[attributeDict objectForKey:@"index"] integerValue];
		}
	}
}

// 文字列を検出した
- (void)parser:(NSXMLParser*)parser foundCharacters:(NSString*)string {
	switch (_currentType) {
 		case ContentsTypeTitle:
			_currentObject = string;
			break;
		case ContentsTypeText:
			[_currentObject appendString:string];
			break;
		case ContentsTypeTextRuby:
			[_currentObject appendString:[NSString stringWithFormat:@"%@%@%@", _rubyClosure, string, _rubyClosure]];
			break;
		case ContentsTypeTextUTF16:
			[_currentObject appendString:[string decodeUTF16String]];
			break;
		default:
			break;
	}
}

// 終了タグを検出した
- (void)parser:(NSXMLParser*)parser didEndElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName {
	ContentsType type = [elementName decodeToContentsType];
	
	// 開始タグと終了タグが合致しないというのはあっていい事態ではないのでASSERTでチェック
	// NSAssert(_currentType != type, @"XML START TAG NOT MATCHES END TAG");
	
	if (_currentType == ContentsTypeTextRuby || _currentType == ContentsTypeTextUTF16) {
		_currentType = ContentsTypeText;
	} else if (_currentType != ContentsTypeUnknown) {
		id cls = nil;
		
		switch (type) {
			case ContentsTypeImage:
				cls = [ImageElement class];
				break;
			case ContentsTypeWait:
				cls = [WaitElement class];
				break;
			case ContentsTypeTitle:
				cls = [TitleElement class];
				break;
			case ContentsTypeText:
				cls = [TextElement class];
				break;
			case ContentsTypeClearText:
				cls = [ClearTextElement class];
				break;
			default:
				break;
		}
		
		if (cls) {
			[_mutableElements addObject:[[cls alloc] initWithAttribute:_currentAttributes object:_currentObject]];
		}
		
		_currentType = ContentsTypeUnknown;
		_currentAttributes = nil;
		_currentObject = nil;
	}
}

@end

//
//  SaveData.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/09/25.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "SaveData.h"
#import "ContentsElement.h"
#import "TextElement.h"
#import "Utility.h"

static NSString* const kEncodeKeyForSaveData			= @"BINZUMEJIGOKU_SAVE_DATA";
static NSString* const kEncodeKeyForSection				= @"SECTION";
static NSString* const kEncodeKeyForLastSequence		= @"LAST_SEQUENCE";
static NSString* const kEncodeKeyForTextHistories		= @"TEXT_HISTORIES";
static NSString* const kEncodeKeyForElementSequences	= @"ELEMENT_SEQUENCES";
static NSString* const kFilePrefixOfSaveData			= @"binzumejigoku_save";

@interface SaveData ()

@property (nonatomic, readwrite)	NSInteger									slotNumber;
@property (nonatomic)				NSInteger									lastSequence;
@property (nonatomic)				NSMutableDictionary<NSNumber*, NSNumber*>*	elementSequences;
@property (nonatomic, readwrite)	NSMutableArray<NSString*>*					textHistories;

@end

@implementation SaveData

@synthesize section = _section;
@synthesize slotNumber = _slotNumber;
@synthesize lastSequence = _lastSequence;
@synthesize elementSequences = _elementSequences;
@synthesize textHistories = _textHistories;

- (id)initWithCoder:(NSCoder*)aDecoder {
	if (self = [super init]) {
		_section = [aDecoder decodeIntegerForKey:kEncodeKeyForSection];
		_lastSequence = [aDecoder decodeIntegerForKey:kEncodeKeyForLastSequence];
		_textHistories = [aDecoder decodeObjectForKey:kEncodeKeyForTextHistories];
		_elementSequences = [aDecoder decodeObjectForKey:kEncodeKeyForElementSequences];
	}
	return self;
}

- (id)initWithSlotNumber:(NSInteger)slotNumber {
	if (self = [super init]) {
		_slotNumber = slotNumber;
		
		[self reset];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeInteger:_section forKey:kEncodeKeyForSection];
	[aCoder encodeInteger:_lastSequence forKey:kEncodeKeyForLastSequence];
	[aCoder encodeObject:_textHistories forKey:kEncodeKeyForTextHistories];
	[aCoder encodeObject:_elementSequences forKey:kEncodeKeyForElementSequences];
}

- (void)addElement:(ContentsElement*)element {
	if (element.section == _section) {
		_lastSequence = element.sequence;

		if (element.contentsType == ContentsTypeImage) {
			
		} else if (element.contentsType == ContentsTypeText) {
			[_elementSequences setObject:[NSNumber numberWithInteger:element.sequence]
								  forKey:@(element.contentsType)];
			
			[_textHistories addObject:((TextElement*)element).text];
		}
	}
}

- (void)save {
	NSString* fileName = [NSString stringWithFormat:@"%@_%ld.dat", kFilePrefixOfSaveData, _slotNumber];
	NSURL* fileURL = [[Utility applicationDocumentDirectory] URLByAppendingPathComponent:fileName];
	
	NSMutableData* data = [[NSMutableData alloc] init];
	NSKeyedArchiver* encoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[encoder encodeObject:self forKey:kEncodeKeyForSaveData];
	[encoder finishEncoding];
	
	[data writeToURL:fileURL atomically:YES];
}

- (void)load {
	NSString* fileName = [NSString stringWithFormat:@"%@_%ld.dat", kFilePrefixOfSaveData, _slotNumber];
	NSURL* fileURL = [[Utility applicationDocumentDirectory] URLByAppendingPathComponent:fileName];
	
	NSMutableData* data = [NSMutableData dataWithContentsOfURL:fileURL];
	NSKeyedUnarchiver* decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	SaveData* saveData = [decoder decodeObjectForKey:kEncodeKeyForSaveData];
	[decoder finishDecoding];
	
	_section = saveData.section;
	_lastSequence = saveData.lastSequence;
	_textHistories = saveData.textHistories;
	_elementSequences = saveData.elementSequences;
}

- (void)reset {
	_section = -1;
	_lastSequence = -1;
	
	if (!_textHistories) {
		_textHistories = [[NSMutableArray alloc] init];
	} else {
		[_textHistories removeAllObjects];
	}
	
	if (!_elementSequences) {
		_elementSequences = [[NSMutableDictionary alloc] init];
	} else {
		[_elementSequences removeAllObjects];
	}
}

@end

//
//  SaveData.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/09/25.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "SaveData.h"
#import "ContentsElement.h"
#import "ImageElement.h"
#import "TextElement.h"
#import "Utility.h"

static NSString* const kEncodeKeyForSaveData			= @"BINZUMEJIGOKU_SAVE_DATA";
static NSString* const kEncodeKeyForSection				= @"SECTION";
static NSString* const kEncodeKeyForSequence			= @"SEQUENCE";
static NSString* const kEncodeKeyForTextHistories		= @"TEXT_HISTORIES";
static NSString* const kEncodeKeyForElementSequences	= @"ELEMENT_SEQUENCES";
static NSString* const kFilePrefixOfSaveData			= @"binzumejigoku_save";

@interface SaveData ()

@property (nonatomic, readwrite)	NSInteger									slotNumber;
@property (nonatomic, readwrite)	NSInteger									sequence;
@property (nonatomic, readwrite)	NSMutableDictionary<NSNumber*, NSNumber*>*	elementSequences;
@property (nonatomic, readwrite)	NSMutableArray<NSString*>*					textHistories;

@end

@implementation SaveData

@synthesize slotNumber = _slotNumber;
@synthesize section = _section;
@synthesize sequence = _sequence;
@synthesize elementSequences = _elementSequences;
@synthesize textHistories = _textHistories;

- (id)initWithSlotNumber:(NSInteger)slotNumber {
	if (self = [super init]) {
		_slotNumber = slotNumber;
		
		[self reset];
	}
	return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder {
	if (self = [super init]) {
		_section = [aDecoder decodeIntegerForKey:kEncodeKeyForSection];
		_sequence = [aDecoder decodeIntegerForKey:kEncodeKeyForSequence];
		_textHistories = [aDecoder decodeObjectForKey:kEncodeKeyForTextHistories];
		_elementSequences = [aDecoder decodeObjectForKey:kEncodeKeyForElementSequences];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeInteger:_section forKey:kEncodeKeyForSection];
	[aCoder encodeInteger:_sequence forKey:kEncodeKeyForSequence];
	[aCoder encodeObject:_textHistories forKey:kEncodeKeyForTextHistories];
	[aCoder encodeObject:_elementSequences forKey:kEncodeKeyForElementSequences];
}

- (void)addElement:(ContentsElement*)element {
	if (element.section == _section) {
		_sequence = element.sequence;

		if (element.contentsType == ContentsTypeImage) {
			if (((ImageElement*)element).image) {
				[_elementSequences setObject:[NSNumber numberWithInteger:element.sequence]
									  forKey:@(element.contentsType)];
			}
		} else if (element.contentsType == ContentsTypeText) {
			[_elementSequences setObject:[NSNumber numberWithInteger:element.sequence]
								  forKey:@(element.contentsType)];
			
			[_textHistories addObject:((TextElement*)element).text];
		}
	}
}

- (void)copyFrom:(SaveData*)other {
	[self reset];
	
	_section = other.section;
	_sequence = other.sequence;
	_textHistories = other.textHistories;
	_elementSequences = other.elementSequences;
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

- (BOOL)load {
	NSString* fileName = [NSString stringWithFormat:@"%@_%ld.dat", kFilePrefixOfSaveData, _slotNumber];
	NSURL* fileURL = [[Utility applicationDocumentDirectory] URLByAppendingPathComponent:fileName];
	
	NSData* data = [NSData dataWithContentsOfURL:fileURL];
	if (data) {
		NSKeyedUnarchiver* decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
		SaveData* saveData = [decoder decodeObjectForKey:kEncodeKeyForSaveData];
		[decoder finishDecoding];
		
		[self copyFrom:saveData];
		
		return YES;
	}
	
	return NO;
}

- (void)reset {
	_section = -1;
	_sequence = -1;
	
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

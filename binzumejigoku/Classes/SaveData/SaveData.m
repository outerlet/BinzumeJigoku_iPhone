//
//  SaveData.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/09/25.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "SaveData.h"
#import "ContentsInterface.h"
#import "ContentsElement.h"
#import "ImageElement.h"
#import "TextElement.h"
#import "Utility.h"

static NSString* const kEncodeKeyForSaveData			= @"BINZUMEJIGOKU_SAVE_DATA";
static NSString* const kEncodeKeyForTitle				= @"TITLE";
static NSString* const kEncodeKeyForDate				= @"DATE";
static NSString* const kEncodeKeyForSectionIndex		= @"SECTION_INDEX";
static NSString* const kEncodeKeyForSequence			= @"SEQUENCE";
static NSString* const kEncodeKeyForTextHistories		= @"TEXT_HISTORIES";
static NSString* const kEncodeKeyForElementSequences	= @"ELEMENT_SEQUENCES";
static NSString* const kFilePrefixOfSaveData			= @"binzumejigoku_save";

@interface SaveData ()

@property (nonatomic, readwrite)	NSInteger									slotNumber;
@property (nonatomic, readwrite)	NSDate*										date;
@property (nonatomic, readwrite)	NSInteger									sequence;
@property (nonatomic, readwrite)	NSMutableDictionary<NSNumber*, NSNumber*>*	elementSequences;
@property (nonatomic, readwrite)	NSMutableArray<NSString*>*					textHistories;

@end

@implementation SaveData

@synthesize title = _title;
@synthesize date = _date;
@synthesize slotNumber = _slotNumber;
@synthesize sectionIndex = _sectionIndex;
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
		_title = [aDecoder decodeObjectForKey:kEncodeKeyForTitle];
		_date = [aDecoder decodeObjectForKey:kEncodeKeyForDate];
		_sectionIndex = [aDecoder decodeIntegerForKey:kEncodeKeyForSectionIndex];
		_sequence = [aDecoder decodeIntegerForKey:kEncodeKeyForSequence];
		_textHistories = [aDecoder decodeObjectForKey:kEncodeKeyForTextHistories];
		_elementSequences = [aDecoder decodeObjectForKey:kEncodeKeyForElementSequences];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:_title forKey:kEncodeKeyForTitle];
	[aCoder encodeObject:_date forKey:kEncodeKeyForDate];
	[aCoder encodeInteger:_sectionIndex forKey:kEncodeKeyForSectionIndex];
	[aCoder encodeInteger:_sequence forKey:kEncodeKeyForSequence];
	[aCoder encodeObject:_textHistories forKey:kEncodeKeyForTextHistories];
	[aCoder encodeObject:_elementSequences forKey:kEncodeKeyForElementSequences];
}

- (BOOL)isSaved {
	return (_date != nil);
}

- (void)addElement:(ContentsElement*)element {
	if (element.section == _sectionIndex) {
		_sequence = element.sequence;

		if (element.contentsType == ContentsTypeImage) {
			if (((ImageElement*)element).image) {
				[_elementSequences setObject:[NSNumber numberWithInteger:element.sequence]
									  forKey:@(element.contentsType)];
			}
		} else if (element.contentsType == ContentsTypeText) {
			ContentsInterface* cif = [ContentsInterface sharedInstance];

			NSMutableString* history = [[NSMutableString alloc] init];
			
			NSString* text = ((TextElement*)element).text;
			for (NSString* str in [text componentsSeparatedByString:cif.rubyClosure]) {
				if ([str containsString:cif.rubyDelimiter]) {
					[history appendString:[[str componentsSeparatedByString:cif.rubyDelimiter] objectAtIndex:0]];
				} else {
					[history appendString:str];
				}
			}
			
			[_textHistories addObject:[NSString stringWithString:history]];
		}
		
		_date = [NSDate date];
	}
}

- (void)copyFrom:(SaveData*)other includeTitle:(BOOL)includeTitle {
	[self reset];
	
	if (includeTitle) {
		_title = other.title;
	}
	
	_date = other.date;
	_sectionIndex = other.sectionIndex;
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
		
		[self copyFrom:saveData includeTitle:YES];
		
		return YES;
	}
	
	return NO;
}

- (void)reset {
	_date = nil;
	_sectionIndex = -1;
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

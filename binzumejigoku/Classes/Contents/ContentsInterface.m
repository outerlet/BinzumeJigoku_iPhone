//
//  ContentsInterface.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/09/20.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "ContentsInterface.h"
#import "SaveData.h"

NSString* const kKeyOfMaxSectionIndex	= @"KEY_OF_MAX_SECTION_INDEX";		// NSUserDefaultsのキー文字列(maxSectionIndex)
NSString* const kKeyOfRubyClosure		= @"KEY_OF_RUBY_CLOSURE";			// NSUserDefaultsのキー文字列(rubyClosure)
NSString* const kKeyOfRubyDelimiter		= @"KEY_OF_RUBY_DELIMITER"; 		// NSUserDefaultsのキー文字列(rubyDelimiter)
NSString* const kKeyOfFontName			= @"KEY_OF_FONT_NAME";				// NSUserDefaultsのキー文字列(フォント名)
NSString* const kKeyOfTextSpeedInterval	= @"KEY_OF_TEXT_SPEED_INTERVAL";	// NSUserDefaultsのキー文字列(テキストスピード)
NSString* const kKeyOfTextSize			= @"KEY_OF_TEXT_SIZE";				// NSUserDefaultsのキー文字列(テキストサイズ)

static NSString* const SettingPlistName	= @"AppSetting";

@implementation ContentsInterface

static ContentsInterface*	_instance;

+ (ContentsInterface*)sharedInstance {
	@synchronized (self) {
		if (!_instance) {
			_instance = [[ContentsInterface alloc] init];
		}
	}
	return _instance;
}

- (void)initialize {
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	
	_maxSectionIndex = [defaults integerForKey:kKeyOfMaxSectionIndex];
	_rubyClosure = [defaults stringForKey:kKeyOfRubyClosure];
	_rubyDelimiter = [defaults stringForKey:kKeyOfRubyDelimiter];
	
	_textSpeedInterval = [defaults floatForKey:kKeyOfTextSpeedInterval];
	if (_textSpeedInterval == 0.0f) {
		self.textSpeedInterval = (CGFloat)[[[self.settings objectForKey:@"TextSpeed"] objectAtIndex:1] floatValue];
	}
	
	_textSize = [defaults floatForKey:kKeyOfTextSize];
	if (_textSize == 0.0f) {
		self.textSize = (CGFloat)[[[self.settings objectForKey:@"TextSize"] objectAtIndex:1] floatValue];
	}
	
	NSMutableArray* saveDatas = [[NSMutableArray alloc] init];
	for (NSInteger idx = 0 ; idx <= 3 ; idx++) {
		SaveData* saveData = [[SaveData alloc] initWithSlotNumber:idx];
		if (![saveData load]) {
			NSString* key = [NSString stringWithFormat:@"save_data_title_%ld", (long)idx];
			saveData.title = NSLocalizedString(key, nil);
		}
		
		[saveDatas addObject:saveData];
	}
	_saveDatas = [NSArray arrayWithArray:saveDatas];
}

- (SaveData*)saveDataAt:(NSInteger)slotNumber {
	return [_saveDatas objectAtIndex:slotNumber];
}

- (NSInteger)integerSetting:(NSString*)key {
	return [[self.settings objectForKey:key] integerValue];
}

- (CGFloat)floatSetting:(NSString*)key {
	return (CGFloat)[[self.settings objectForKey:key] floatValue];
}

- (NSInteger)maxSectionIndex {
	return _maxSectionIndex;
}
	
- (void)setMaxSectionIndex:(NSInteger)maxSectionIndex {
	_maxSectionIndex = maxSectionIndex;
	
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:maxSectionIndex forKey:kKeyOfMaxSectionIndex];
	[defaults synchronize];
}

- (NSString*)rubyClosure {
	return _rubyClosure;
}

- (void)setRubyClosure:(NSString*)rubyClosure {
	_rubyClosure = rubyClosure;
	
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:_rubyClosure forKey:kKeyOfRubyClosure];
	[defaults synchronize];
}

- (NSString*)rubyDelimiter {
	return _rubyDelimiter;
}

- (void)setRubyDelimiter:(NSString*)rubyDelimiter {
	_rubyDelimiter = rubyDelimiter;
	
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:_rubyDelimiter forKey:kKeyOfRubyDelimiter];
	[defaults synchronize];
}
	
- (NSURL*)contentsFileUrl {
	NSString* path = [[NSBundle mainBundle] pathForResource:[self.settings objectForKey:@"ContentsFilePrefix"]
													 ofType:[self.settings objectForKey:@"ContentsFileSuffix"]];
	
	return [NSURL fileURLWithPath:path];
}

- (NSString*)fontName {
	return [self.settings objectForKey:@"FontName"];
}

- (CGFloat)textSpeedInterval {
	return _textSpeedInterval;
}

- (void)setTextSpeedInterval:(CGFloat)textSpeedInterval {
	_textSpeedInterval = textSpeedInterval;
	
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults setFloat:_textSpeedInterval forKey:kKeyOfTextSpeedInterval];
	[defaults synchronize];
}

- (CGFloat)textSize {
	return _textSize;
}

- (void)setTextSize:(CGFloat)textSize {
	_textSize = textSize;
	
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults setFloat:_textSize forKey:kKeyOfTextSize];
	[defaults synchronize];
}

- (NSDictionary*)settings {
	return [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:SettingPlistName
																					  ofType:@"plist"]];
}

@end

//
//  ContentsInterface.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/09/20.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "ContentsInterface.h"

NSString* const kKeyOfRubyDelimiter	= @"KEY_OF_RUBY_DELIMITER";
NSString* const kKeyOfRubyClosure	= @"KEY_OF_RUBY_CLOSURE";

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
	_rubyClosure = [defaults stringForKey:kKeyOfRubyClosure];
	_rubyDelimiter = [defaults stringForKey:kKeyOfRubyClosure];
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

@end

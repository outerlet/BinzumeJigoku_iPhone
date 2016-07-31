//
//  AlertControllerHandler.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/31.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "AlertControllerHandler.h"

@interface AlertControllerHandler ()

- (void)actionDidOccur:(NSInteger)tag;

@end

@implementation AlertControllerHandler

- (id)initWithTitle:(NSString*)title message:(NSString*)message preferrdStyle:(UIAlertControllerStyle)style tag:(NSInteger)tag {
	if (self = [super init]) {
		_tag = tag;
		_title = title;
		_message = message;
		_style = style;
		_alertActions = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)addAction:(NSString*)title style:(UIAlertActionStyle)style tag:(NSInteger)tag {
	UIAlertAction* action = [UIAlertAction actionWithTitle:title
													 style:style
												   handler:^(UIAlertAction* action) {
													   [self actionDidOccur:tag];
												   }];
	[_alertActions addObject:action];
}

- (UIAlertController*)build {
	UIAlertController* alert = [UIAlertController alertControllerWithTitle:_title message:_message preferredStyle:_style];
	
	for (UIAlertAction *action in _alertActions) {
		[alert addAction:action];
	}
	
	return alert;
}

- (void)actionDidOccur:(NSInteger)tag {
	if (self.delegate && [self.delegate respondsToSelector:@selector(alertDidConfirmAt:action:)]) {
		[self.delegate alertDidConfirmAt:_tag action:tag];
	}
}

@end

//
//  AlertControllerHandler.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/31.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol AlertControllerHandlerDelegate <NSObject>

- (void)alertDidConfirmAt:(NSInteger)alertTag action:(NSInteger)actionTag;

@end

@interface AlertControllerHandler : NSObject {
	@private
	NSInteger				_tag;
	NSString*				_title;
	NSString*				_message;
	UIAlertControllerStyle	_style;
	NSMutableArray*			_alertActions;
}

@property (nonatomic)	id<AlertControllerHandlerDelegate>	delegate;

- (id)initWithTitle:(NSString*)title message:(NSString*)message preferrdStyle:(UIAlertControllerStyle)style tag:(NSInteger)tag;
- (void)addAction:(NSString*)title style:(UIAlertActionStyle)style tag:(NSInteger)tag;
- (UIAlertController*)build;

@end

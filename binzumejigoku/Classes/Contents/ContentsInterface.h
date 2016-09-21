//
//  ContentsInterface.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/09/20.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ContentsInterface : NSObject {
	@private
	NSString*	_rubyClosure;
	NSString*	_rubyDelimiter;
}

@property (nonatomic)	NSString*	rubyClosure;
@property (nonatomic)	NSString*	rubyDelimiter;

+ (ContentsInterface*)sharedInstance;
- (void)initialize;

@end

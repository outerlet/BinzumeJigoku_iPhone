//
//  TextHistoryViewController.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/10/04.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextHistoryViewController : UIViewController {
	@private
	NSArray<NSString*>*	_textHistories;
}

- (id)initWithTextHistories:(NSArray<NSString*>*)textHistories;

@end

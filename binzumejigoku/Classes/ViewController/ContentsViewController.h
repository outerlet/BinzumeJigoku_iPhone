//
//  ContentsViewController.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/31.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentsParser.h"

@interface ContentsViewController : UIViewController <ContentsParserDelegate> {
	@private
	ContentsParser*	_parser;
}

@property (nonatomic, readonly) NSInteger sectionIndex;

- (id)initWithSectionIndex:(NSInteger)sectionIndex;

@end

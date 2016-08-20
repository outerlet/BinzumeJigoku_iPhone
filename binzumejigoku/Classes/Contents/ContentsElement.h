//
//  ContentsElement.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/01.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ContentsType.h"
#import "ChainType.h"

@interface ContentsElement : NSObject

@property (nonatomic, readonly) ChainType		chainType;
@property (nonatomic, readonly) ContentsType	contentsType;

- (id)initWithAttribute:(NSDictionary*)attrs object:(id)obj;
- (NSString*)stringValue;

@end

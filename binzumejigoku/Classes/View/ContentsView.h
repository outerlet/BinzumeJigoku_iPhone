//
//  ContentsView.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/10/06.
//  Copyright © 2016年 1-Take. All rights reserved.
//

@protocol ContentsView <NSObject>

- (void)handleElement:(id)element completion:(void (^)(void))completion;

@end

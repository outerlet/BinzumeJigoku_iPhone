//
//  MainPageView
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/29.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "MainPageView.h"

@implementation MainPageView

- (id)initWithFrame:(CGRect)frame text:(NSString*)text textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor {
    if (self = [super initWithFrame:frame]) {
        UILabel* label = [[UILabel alloc] initWithFrame:self.bounds];
        label.backgroundColor = backgroundColor;
        label.textColor = textColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = text;
        
        [self addSubview:label];
    }
    
    return self;
}

- (void)touchesEnded:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event {
    if (event.type == UIEventTypeTouches) {
        NSLog(@"Touches detected!!!");
    }
}

@end

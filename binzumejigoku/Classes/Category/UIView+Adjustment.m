//
//  UIView+Positioning.m
//  SampleApp
//
//  Created by Shizuo Ichitake on 2016/09/11.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "UIView+Adjustment.h"

@implementation UIView (Adjustment)

- (void)moveTo:(CGPoint)destination {
	CGRect frame = self.frame;
	frame.origin.x = destination.x;
	frame.origin.y = destination.y;
	self.frame = frame;
}

- (void)moveBy:(CGSize)distance {
	CGRect frame = self.frame;
	frame.origin.x += distance.width;
	frame.origin.y += distance.height;
	self.frame = frame;
}

- (void)resizeTo:(CGSize)newSize {
	CGRect frame = self.frame;
	frame.size.width = newSize.width;
	frame.size.height = newSize.height;
	self.frame = frame;
}

- (void)resizeBy:(CGSize)increment {
	CGRect frame = self.frame;
	frame.size.width += increment.width;
	frame.size.height += increment.height;
	self.frame = frame;
}

@end

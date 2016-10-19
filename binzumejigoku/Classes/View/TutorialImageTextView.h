//
//  TutorialGestureView.h
//  SampleApp
//
//  Created by Shizuo Ichitake on 2016/10/14.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TutorialImageAlignment) {
	TutorialImageAlignmentLeft,
	TutorialImageAlignmentRight,
};

@interface TutorialImageTextView : UIView {
	@private
	NSMutableArray<NSDictionary*>*	_tutorials;
}

@property (nonatomic)	UIFont*		font;
@property (nonatomic)	UIColor*	textColor;

- (void)addTutorial:(NSString*)text image:(UIImage*)image imageAlignment:(TutorialImageAlignment)imageAlignment;
- (void)addTutorial:(NSString*)text;
- (void)compose;

@end

//
//  MainPageView.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/29.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainPageView;

@protocol MainPageViewDelegate <NSObject>

- (void)viewDidTouch:(MainPageView*)view;

@end

@interface MainPageView : UIView {
    @private
	UILabel*		_titleLabel;
	UILabel*		_summaryLabel;
	UIImageView*	_backgroundImageView;
}

@property (nonatomic) id<MainPageViewDelegate>	delegate;

@property (nonatomic, readwrite)	NSString*	title;
@property (nonatomic, readwrite)	NSString*	summary;
@property (nonatomic, readwrite)	UIImage*	backgroundImage;

- (id)initWithFrame:(CGRect)frame withTag:(NSInteger)tag;

@end

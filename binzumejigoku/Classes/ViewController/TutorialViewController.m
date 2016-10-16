//
//  TutorialViewController.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/10/14.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "TutorialViewController.h"
#import "ContentsInterface.h"
#import "TutorialImageTextView.h"
#import "UIView+Adjustment.h"

static const CGFloat kContentMarginVertical		= 4.0f;
static const CGFloat kContentMarginHorizontal	= 6.0f;
static const CGFloat kLineSpaceAboutApplication	= 12.0f;

@interface TutorialViewController ()

- (NSArray<UIView*>*)aboutApplicationViews:(UIView*)parent;
- (UIView*)howToControlView:(UIView*)parent;
- (UIFont*)commonFont;

@end

@implementation TutorialViewController

- (id)initWithTutorialType:(TutorialType)tutorialType {
	if (self = [super init]) {
		_tutorialType = tutorialType;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSString* key = (_tutorialType == TutorialTypeHowToControl) ? @"tutorial_title_how_to_control" : @"tutorial_title_about_application";
	self.titleText = NSLocalizedString(key, nil);
	
	CGRect frame = CGRectInset(self.contentView.bounds, kContentMarginHorizontal, kContentMarginVertical);
	UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:frame];
	scrollView.pagingEnabled = YES;
	scrollView.delegate = self;
	
	CGSize contentSize = CGSizeMake(0.0f, frame.size.height);
	
	NSMutableArray<UIView*>* tutorialViews = [[NSMutableArray alloc] init];
	CGFloat posX = 0.0f;
	
	if (_tutorialType == TutorialTypeAll || _tutorialType == TutorialTypeAboutApplication) {
		NSArray<UIView*>* views = [self aboutApplicationViews:scrollView];
		
		for (NSInteger idx = 0 ; idx < views.count ; idx++) {
			UIView* view = [views objectAtIndex:idx];
			[view moveTo:CGPointMake(posX, 0.0f)];
			[scrollView addSubview:view];
			
			contentSize.width += view.frame.size.width;
			
			posX += view.frame.size.width;
			
			[tutorialViews addObject:view];
		}
	}
	
	if (_tutorialType == TutorialTypeAll || _tutorialType == TutorialTypeHowToControl) {
		UIView* view = [self howToControlView:scrollView];
		[view moveTo:CGPointMake(posX, 0.0f)];
		[scrollView addSubview:view];
		
		contentSize.width += view.frame.size.width;
		
		[tutorialViews addObject:view];
	}
	
	_tutorialViews = [NSArray arrayWithArray:tutorialViews];
	
	scrollView.contentSize = contentSize;
	[self.contentView addSubview:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (_tutorialType == TutorialTypeAll) {
		NSString* key = (scrollView.contentOffset.x >= [_tutorialViews lastObject].frame.origin.x) ? @"tutorial_title_how_to_control" : @"tutorial_title_about_application";
		self.titleText = NSLocalizedString(key, nil);
	}
}

// このアプリに関する説明を表示するView
- (NSArray<UIView*>*)aboutApplicationViews:(UIView*)parent {
	NSMutableArray<UIView*>* views = [[NSMutableArray alloc] init];
	
	[views addObject:[[UIView alloc] initWithFrame:parent.bounds]];
	
	CGFloat posY = 0.0f;
	
	for (NSInteger idx = 1 ; idx <= 14 ; idx++) {
		UIView* currentView = [views lastObject];
		
		NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
		style.minimumLineHeight = style.maximumLineHeight = 32.0f;
		
		NSDictionary* attrs = @{ NSFontAttributeName: [self commonFont], NSForegroundColorAttributeName: [UIColor whiteColor], NSParagraphStyleAttributeName: style };
		NSString* key = [NSString stringWithFormat:@"tutorial_message_%ld", (long)idx];
		
		UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, currentView.bounds.size.width, 0.0f)];
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentLeft;
		label.numberOfLines = 0;
		label.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(key, nil)
															   attributes:attrs];
		[label sizeToFit];
		
		if (posY + label.frame.size.height + kLineSpaceAboutApplication > currentView.bounds.size.height || idx == 9) {
			currentView = [[UIView alloc] initWithFrame:parent.bounds];
			[views addObject:currentView];
			posY = 0.0f;
		}
		
		[label moveTo:CGPointMake(0.0f, posY)];
		[currentView addSubview:label];
		
		posY += (label.frame.size.height + kLineSpaceAboutApplication);
	}
	
	return views;
}

// 操作方法を説明するView
- (UIView*)howToControlView:(UIView*)parent {
	TutorialImageTextView* tutorialView = [[TutorialImageTextView alloc] initWithFrame:parent.bounds];
	tutorialView.backgroundColor = [UIColor clearColor];
	tutorialView.font = [self commonFont];
	tutorialView.textColor = [UIColor whiteColor];
	[tutorialView addTutorial:NSLocalizedString(@"tutorial_for_long_tap", nil)
						image:[UIImage imageNamed:@"tutorial_tap.png"]
			   imageAlignment:TutorialImageAlignmentRight];
	[tutorialView addTutorial:NSLocalizedString(@"tutorial_for_swipe", nil)
						image:[UIImage imageNamed:@"tutorial_swipe.png"]
			   imageAlignment:TutorialImageAlignmentLeft];
	[tutorialView compose];
	
	return tutorialView;
}

// このViewControllerで生成される文字に共通で適用されるフォント
- (UIFont*)commonFont {
	return [UIFont fontWithName:[ContentsInterface sharedInstance].fontName size:20.0f];
}

@end

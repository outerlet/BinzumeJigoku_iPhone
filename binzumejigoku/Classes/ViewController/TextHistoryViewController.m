//
//  TextHistoryViewController.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/10/04.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "TextHistoryViewController.h"
#import "ContentsInterface.h"

static const CGFloat kTitleTextSize			= 28.0f;
static const CGFloat kTextHistoryTextSize	= 20.0f;
static const CGFloat kTextHistoryLineSize	= 32.0f;
static const CGFloat kCloseButtonSideLength	= 36.0f;
static const CGFloat kCloseButtonMargin		= 24.0f;
static const CGFloat kLabelTopMargin		= 12.0f;
static const CGFloat kLabelSideMargin		= 8.0f;

@interface TextHistoryViewController ()

- (void)closeButtonDidPush:(id)sender;

@end

@implementation TextHistoryViewController

- (id)initWithTextHistories:(NSArray<NSString *> *)textHistories {
	if (self = [super init]) {
		_textHistories = textHistories;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	ContentsInterface* cif = [ContentsInterface sharedInstance];
	
	self.view.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f];
	
	UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	closeButton.frame = CGRectMake(self.view.bounds.size.width - (kCloseButtonSideLength + kCloseButtonMargin), kCloseButtonMargin, kCloseButtonSideLength, kCloseButtonSideLength);
	[closeButton setImage:[UIImage imageNamed:@"ic_cancel_white.png"] forState:UIControlStateNormal];
	[closeButton addTarget:self
					action:@selector(closeButtonDidPush:)
		  forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:closeButton];
	
	UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.font = [UIFont fontWithName:cif.fontName size:kTitleTextSize];
	titleLabel.text = NSLocalizedString(@"phrase_text_history", nil);
	[titleLabel sizeToFit];
	titleLabel.center = CGPointMake(self.view.bounds.size.width / 2.0f, closeButton.center.y);
	[self.view addSubview:titleLabel];
	
	CGFloat scrollOriginY = closeButton.frame.origin.y + closeButton.frame.size.height + kCloseButtonMargin;
	
	UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, scrollOriginY, self.view.bounds.size.width, self.view.bounds.size.height - scrollOriginY)];
	
	CGFloat height = kLabelTopMargin;
	
	for (NSInteger idx = 0 ; idx < _textHistories.count ; idx++) {
		NSString* history = [_textHistories objectAtIndex:idx];
		
		NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
		style.minimumLineHeight = kTextHistoryLineSize;
		style.maximumLineHeight = kTextHistoryLineSize;
		
		NSDictionary* attrs = @{ NSFontAttributeName: [UIFont fontWithName:cif.fontName size:kTextHistoryTextSize], NSForegroundColorAttributeName: [UIColor whiteColor], NSParagraphStyleAttributeName: style };
		
		UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(kLabelSideMargin, height, self.view.bounds.size.width - kLabelSideMargin * 2, 0.0f)];
		label.backgroundColor = [UIColor clearColor];
		label.numberOfLines = 0;
		label.attributedText = [[NSAttributedString alloc] initWithString:history attributes:attrs];
		[label sizeToFit];
		[scrollView addSubview:label];
		
		height += (label.frame.size.height + kLabelTopMargin);
	}
	
	CGSize contentSize = CGSizeMake(self.view.bounds.size.width, height);
	CGFloat offsetY = (contentSize.height <= scrollView.bounds.size.height) ? 0.0f : contentSize.height - scrollView.bounds.size.height;

	scrollView.contentSize = contentSize;
	[scrollView setContentOffset:CGPointMake(0.0f, offsetY) animated:NO];
	[self.view addSubview:scrollView];
}

- (UIModalPresentationStyle)modalPresentationStyle {
	return UIModalPresentationOverCurrentContext;
}

- (void)closeButtonDidPush:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end

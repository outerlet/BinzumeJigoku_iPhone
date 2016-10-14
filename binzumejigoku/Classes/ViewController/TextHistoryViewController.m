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
static const CGFloat kHistoryTextSize		= 20.0f;
static const CGFloat kHistoryLineSize		= 32.0f;
static const CGFloat kHistorySideMargin		= 8.0f;
static const CGFloat kSpaceBetweenHistories	= 12.0f;

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
	
	UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.font = [UIFont fontWithName:cif.fontName size:kTitleTextSize];
	titleLabel.text = NSLocalizedString(@"phrase_text_history", nil);
	[titleLabel sizeToFit];
	titleLabel.center = CGPointMake(self.view.bounds.size.width / 2.0f, self.closeButton.center.y);
	[self.view addSubview:titleLabel];
	
	UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.contentView.bounds.size.width, self.contentView.bounds.size.height)];
	
	CGFloat height = kSpaceBetweenHistories;
	
	for (NSInteger idx = 0 ; idx < _textHistories.count ; idx++) {
		NSString* history = [_textHistories objectAtIndex:idx];
		
		NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
		style.minimumLineHeight = kHistoryLineSize;
		style.maximumLineHeight = kHistoryLineSize;
		
		NSDictionary* attrs = @{ NSFontAttributeName: [UIFont fontWithName:cif.fontName size:kHistoryTextSize], NSForegroundColorAttributeName: [UIColor whiteColor], NSParagraphStyleAttributeName: style };
		
		UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(kHistorySideMargin, height, scrollView.bounds.size.width - kHistorySideMargin * 2, 0.0f)];
		label.backgroundColor = [UIColor clearColor];
		label.numberOfLines = 0;
		label.attributedText = [[NSAttributedString alloc] initWithString:history attributes:attrs];
		[label sizeToFit];
		[scrollView addSubview:label];
		
		height += (label.frame.size.height + kSpaceBetweenHistories);
	}
	
	CGSize contentSize = CGSizeMake(self.contentView.bounds.size.width, height);
	CGFloat offsetY = (contentSize.height <= scrollView.bounds.size.height) ? 0.0f : contentSize.height - scrollView.bounds.size.height;

	scrollView.contentSize = contentSize;
	[scrollView setContentOffset:CGPointMake(0.0f, offsetY) animated:NO];
	[self.contentView addSubview:scrollView];
}

@end

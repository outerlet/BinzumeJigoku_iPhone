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

@implementation TutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	ContentsInterface* cif = [ContentsInterface sharedInstance];
	
	TutorialImageTextView* tutorialView = [[TutorialImageTextView alloc] initWithFrame:self.contentView.bounds];
	tutorialView.backgroundColor = [UIColor clearColor];
	tutorialView.font = [UIFont fontWithName:cif.fontName size:20.0f];
	tutorialView.textColor = [UIColor whiteColor];
	[tutorialView addTutorial:NSLocalizedString(@"message_tutorial_for_long_tap", nil) image:[UIImage imageNamed:@"tutorial_tap.png"] imageAlignment:TutorialImageAlignmentRight];
	[tutorialView addTutorial:NSLocalizedString(@"message_tutorial_for_swipe", nil) image:[UIImage imageNamed:@"tutorial_swipe.png"] imageAlignment:TutorialImageAlignmentLeft];
	[tutorialView compose];
	[self.contentView addSubview:tutorialView];
}

@end

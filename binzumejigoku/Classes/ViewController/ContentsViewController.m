//
//  ContentsViewController.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/31.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "ContentsViewController.h"
#import "ContentsParser.h"
#import "ContentsElement.h"

@interface ContentsViewController ()

@property (nonatomic, readwrite) NSInteger	sectionIndex;

@end

@implementation ContentsViewController

@synthesize sectionIndex = _sectionIndex;

- (id)initWithSectionIndex:(NSInteger)sectionIndex {
	if (self = [super init]) {
		self.sectionIndex = sectionIndex;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UILabel* label = [[UILabel alloc] initWithFrame:self.view.bounds];
	label.center = self.view.center;
	label.backgroundColor = [UIColor whiteColor];
	label.textColor = [UIColor blackColor];
	label.textAlignment = NSTextAlignmentCenter;
	label.text = @"Contents View Controller";
	[self.view addSubview:label];
	
	_parser = [[ContentsParser alloc] init];
	_parser.delegate = self;
	[_parser parse];
}

- (void)touchesBegan:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)parseDidFinished {
	NSLog(@"Contents XML is parsed.");
}

@end

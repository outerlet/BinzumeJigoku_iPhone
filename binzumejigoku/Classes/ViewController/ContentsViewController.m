//
//  ContentsViewController.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/31.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "ContentsViewController.h"

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
	
	UILabel* label = [[UILabel alloc] initWithFrame:self.view.frame];
	label.textColor = [UIColor whiteColor];
	label.backgroundColor = [UIColor blackColor];
	label.textAlignment = NSTextAlignmentCenter;
	label.text = [NSString stringWithFormat:@"CONTENTS VIEW CONTROLLER : %02ld", _sectionIndex];
	label.center = self.view.center;
	
	[self.view addSubview:label];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end

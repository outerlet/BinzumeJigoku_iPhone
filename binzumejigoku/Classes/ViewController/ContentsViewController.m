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
	
	UILabel* label = [[UILabel alloc] initWithFrame:self.view.frame];
	label.textColor = [UIColor whiteColor];
	label.backgroundColor = [UIColor blackColor];
	label.textAlignment = NSTextAlignmentCenter;
	label.text = [NSString stringWithFormat:@"CONTENTS VIEW CONTROLLER : %02ld", _sectionIndex];
	label.center = self.view.center;
	
	[self.view addSubview:label];
	
	ContentsParser* parser = [[ContentsParser alloc] init];
	[parser parse];
	
	NSLog(@"ELEMENT COUNT = %lu", (unsigned long)parser.elements.count);
	
	for (ContentsElement* e in parser.elements) {
		NSLog(@"%@", [e stringValue]);
	}
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end

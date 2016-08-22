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
	
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	_tableView.center = self.view.center;
	[self.view addSubview:_tableView];
	
	_parser = [[ContentsParser alloc] init];
	[_parser parse];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	return _parser.elements.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	NSString* cellId = [NSString stringWithFormat:@"CELL_%02ld", indexPath.row];
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
	
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
		cell.textLabel.text = [[_parser.elements objectAtIndex:indexPath.row] stringValue];
	}
	
	return cell;
}

- (void)touchesBegan:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event {
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end

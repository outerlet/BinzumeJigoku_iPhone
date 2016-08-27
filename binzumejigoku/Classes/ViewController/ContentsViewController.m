//
//  ContentsViewController.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/31.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "ContentsViewController.h"
#import "CoreDataHandler.h"
#import "ContentsType.h"
#import "ContentsElement.h"
#import "ImageElement.h"
#import "WaitElement.h"
#import "TitleElement.h"
#import "TextElement.h"
#import "ClearTextElement.h"
#import "NSString+CustomDecoder.h"

@interface ContentsViewController ()

@property (nonatomic, readwrite) NSInteger	sectionIndex;

/**
 * NSManagedObjectからContentsElementオブジェクトを生成する
 */
- (ContentsElement*)elementByManagedObject:(NSManagedObject*)managedObject;

@end

@implementation ContentsViewController

@synthesize sectionIndex = _sectionIndex;

- (id)initWithSectionIndex:(NSInteger)sectionIndex {
	if (self = [super init]) {
		self.sectionIndex = sectionIndex;
		_touchCount = 0;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	_imageView = [[ContentsImageView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:_imageView];
	
	NSMutableArray* array = [[NSMutableArray alloc] init];
	CoreDataHandler* handler = [CoreDataHandler sharedInstance];
	NSFetchedResultsController* result = [handler fetch:self.sectionIndex];
	for (NSManagedObject* obj in result.fetchedObjects) {
		ContentsElement* e = [self elementByManagedObject:obj];
		if (e) {
			[array addObject:e];
		}
	}
	
	for (ContentsElement* e in array) {
		NSLog(@"%@", [e stringValue]);
	}
}

- (void)touchesBegan:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event {
	++_touchCount;
	
	switch (_touchCount) {
		case 1:
			[_imageView setNextImage:[UIImage imageNamed:@"section0_00.jpg"]];
			[_imageView startAnimationWithEffect:ImageEffectCut duration:1.0f];
			break;
		case 2:
			[_imageView setNextImage:[UIImage imageNamed:@"section0_01.jpg"]];
			[_imageView startAnimationWithEffect:ImageEffectCut duration:1.0f];
			break;
		default:
			[_imageView setNextImage:nil];
			[_imageView startAnimationWithEffect:ImageEffectCut duration:1.0f];
			_touchCount = 0;
			break;
	}
}

- (ContentsElement*)elementByManagedObject:(NSManagedObject*)managedObject {
	ContentsType type = [[managedObject valueForKey:AttributeNameType] decodeToContentsType];
	id cls = nil;
	switch (type) {
		case ContentsTypeImage:
			cls = [ImageElement class];
			break;
		case ContentsTypeWait:
			cls = [WaitElement class];
			break;
		case ContentsTypeTitle:
			cls = [TitleElement class];
			break;
		case ContentsTypeText:
			cls = [TextElement class];
			break;
		case ContentsTypeClearText:
			cls = [ClearTextElement class];
			break;
		default:
			return nil;
	}
	
	return [[cls alloc] initWithManagedObject:managedObject];
}

- (void)imageViewAnimationDidFinish:(ContentsImageView *)imageView {
	
}

@end

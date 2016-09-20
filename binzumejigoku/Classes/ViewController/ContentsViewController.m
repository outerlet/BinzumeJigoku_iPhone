//
//  ContentsViewController.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/31.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "ContentsViewController.h"

#import "AppDelegate.h"
#import "CoreDataHandler.h"
#import "ContentsType.h"
#import "ContentsElement.h"
#import "ImageElement.h"
#import "WaitElement.h"
#import "TitleElement.h"
#import "TextElement.h"
#import "ContentsTitleView.h"
#import "ContentsImageView.h"
#import "ClearTextElement.h"
#import "NSString+CustomDecoder.h"

@interface ContentsViewController ()

@property (nonatomic, readwrite) NSInteger	sectionIndex;

/**
 * NSManagedObjectからContentsElementオブジェクトを生成する
 */
- (ContentsElement*)elementByManagedObject:(NSManagedObject*)managedObject;

- (void)handleTitleElement:(TitleElement*)element;
- (void)handleImageElement:(ImageElement*)element;
- (void)handlerTextElement:(TextElement*)element;

@end

@implementation ContentsViewController

@synthesize sectionIndex = _sectionIndex;

- (id)initWithSectionIndex:(NSInteger)sectionIndex {
	if (self = [super init]) {
		_sectionIndex = sectionIndex;
		_currentIndex = -1;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	// 背景画像
	_imageView = [[ContentsImageView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:_imageView];
	
	// タイトル
	_titleView = [[ContentsTitleView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:_titleView];
	
	// CoreDataに保存したコンテンツを読み込む
	NSMutableArray* contents = [[NSMutableArray alloc] init];
	CoreDataHandler* handler = [CoreDataHandler sharedInstance];
	NSFetchedResultsController* result = [handler fetch:_sectionIndex];
	for (NSManagedObject* obj in result.fetchedObjects) {
		ContentsElement* e = [self elementByManagedObject:obj];
		if (e) {
			[contents addObject:e];
		}
	}
	
	_contents = [NSArray arrayWithArray:contents];
}

- (void)touchesBegan:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event {
	if (++_currentIndex < _contents.count) {
		ContentsElement* e = [_contents objectAtIndex:_currentIndex];
		
		switch (e.contentsType) {
			case ContentsTypeImage:
				[self handleImageElement:(ImageElement*)e];
				break;
			case ContentsTypeText:
				[self handlerTextElement:(TextElement*)e];
				break;
			case ContentsTypeTitle:
				[self handleTitleElement:(TitleElement*)e];
				break;
			case ContentsTypeWait:
				break;
			case ContentsTypeClearText:
				break;
			default:
				break;
		}
	} else {
		[self dismissViewControllerAnimated:YES completion:nil];
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

- (void)handleTitleElement:(TitleElement *)element {
	[_titleView setTitle:element.title font:[UIFont fontWithName:DEFAULT_FONT_NAME size:36.0f]];
	[_titleView startAnimationWithDuration:3.0f
								completion:^(void) {
									NSLog(@"TitleView Animation Did Finished.");
								}];
}

- (void)handleImageElement:(ImageElement*)element {
	[_imageView setNextImage:element.image];
	[_imageView startAnimationWithEffect:element.imageEffect
								duration:element.duration
							  completion:^(void) {
								  NSLog(@"ImageView Animation Did Finished.");
							  }];
}

- (void)handlerTextElement:(TextElement*)element {
	
}

@end

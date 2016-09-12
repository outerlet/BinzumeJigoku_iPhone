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
	_imageView.delegate = self;
	[self.view addSubview:_imageView];
	
	// テキスト
	_textView = [[RubyTextView alloc] initWithWidth:self.view.bounds.size.width];
	_textView.delegate = self;
	[self.view addSubview:_textView];
	
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
				break;
			case ContentsTypeTitle:
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

- (void)handleImageElement:(ImageElement*)element {
	[_imageView setNextImage:element.image];
	[_imageView startAnimationWithEffect:element.imageEffect duration:element.duration];
}

- (void)handlerTextElement:(TextElement*)element {
	
}

- (void)imageViewAnimationDidFinish:(ContentsImageView *)imageView {
	
}

- (void)rubyTextStreamingDidFinish:(RubyTextView *)textView {
	
}

@end

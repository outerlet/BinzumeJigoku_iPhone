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
#import "TitleElement.h"
#import "TextElement.h"
#import "WaitElement.h"
#import "ClearTextElement.h"
#import "ContentsTitleView.h"
#import "ContentsImageView.h"
#import "ContentsTextView.h"
#import "ContentsWaitingIndicatorView.h"
#import "NSString+CustomDecoder.h"

const CGFloat kHeightOfIndicator	= 40.0f;
const CGFloat kSideMarginOfViews	= 10.0f;

@interface ContentsViewController ()

@property (nonatomic, readwrite) NSInteger	sectionIndex;

- (void)advanceContents:(ContentsElement*)element;

// NSManagedObjectからContentsElementオブジェクトを生成する
- (ContentsElement*)elementByManagedObject:(NSManagedObject*)managedObject;

// handle~で始まるメソッド群ではそれぞれのContentsElementに対応した処理を実行する
- (void)handleTitleElement:(TitleElement*)titleElement;
- (void)handleImageElement:(ImageElement*)imageElement;
- (void)handleTextElement:(TextElement*)textElement;
- (void)handleWaitElement:(WaitElement*)waitElement;

// handle~で始まるメソッドが、その中で呼び出す共通処理
- (void)commonElementHandle:(ContentsElement*)element;

// handle~で始まるメソッド群がそれぞれの処理を終了した時に共通で呼び出すメソッド
// 各メソッドにある完了ブロックで定義すると同じ処理が複数箇所に分散してしまうので
- (void)contentsElementDidConsume:(ContentsElement*)element;

@end

@implementation ContentsViewController

@synthesize sectionIndex = _sectionIndex;

- (id)initWithSectionIndex:(NSInteger)sectionIndex {
	if (self = [super init]) {
		_sectionIndex = sectionIndex;
		_currentIndex = -1;
		_isContentsOngoing = NO;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	// 背景画像
	_imageView = [[ContentsImageView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:_imageView];
	
	// テキスト
	CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;

	CGRect textFrame = CGRectInset(self.view.bounds, kSideMarginOfViews, 0.0f);
	textFrame.size.height -= (statusHeight + kHeightOfIndicator);
	textFrame.origin.y = statusHeight;
	_textView = [[ContentsTextView alloc] initWithFrame:textFrame];
	[self.view addSubview:_textView];

	// テキスト送り待ちのインジケータ
	CGRect indicatorFrame = CGRectMake(kSideMarginOfViews, self.view.bounds.size.height - kHeightOfIndicator, textFrame.size.width, kHeightOfIndicator);
	_indicatorView = [[ContentsWaitingIndicatorView alloc] initWithFrame:indicatorFrame];
	_indicatorView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:_indicatorView];
	
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

- (void)viewDidAppear:(BOOL)animated {
	[self advanceContents:nil];
}

- (void)touchesBegan:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event {
	[self advanceContents:nil];
}

- (void)advanceContents:(ContentsElement*)element {
	if (!_isContentsOngoing || (element && element.chainType != ChainTypeNone)) {
		if (++_currentIndex < _contents.count) {
			[_indicatorView stopAnimation];
			
			ContentsElement* e = [_contents objectAtIndex:_currentIndex];
			
			switch (e.contentsType) {
				case ContentsTypeImage:
					[self handleImageElement:(ImageElement*)e];
					break;
				case ContentsTypeText:
					[self handleTextElement:(TextElement*)e];
					break;
				case ContentsTypeTitle:
					[self handleTitleElement:(TitleElement*)e];
					break;
				case ContentsTypeWait:
					[self handleWaitElement:(WaitElement*)e];
					break;
				case ContentsTypeClearText:
					[_textView clearAllTexts];
					[self contentsElementDidConsume:e];
					return;
				default:
					return;
			}
			
			_isContentsOngoing = YES;
		} else {
			[self dismissViewControllerAnimated:YES completion:nil];
		}
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

- (void)handleTitleElement:(TitleElement *)titleElement {
	[_titleView setTitle:titleElement.title
					font:[UIFont fontWithName:DEFAULT_FONT_NAME
										 size:36.0f]];
	
	[_titleView startAnimationWithDuration:3.0f
								completion:^(void) {
									NSLog(@"TitleView Animation Did Finish.");
									[self contentsElementDidConsume:titleElement];
								}];
	
	[self commonElementHandle:titleElement];
}

- (void)handleImageElement:(ImageElement*)imageElement {
	[_imageView setNextImage:imageElement.image];
	
	[_imageView startAnimationWithEffect:imageElement.imageEffect
								duration:imageElement.duration
							  completion:^(void) {
								  NSLog(@"ImageView Animation Did Finish.");
								  [self contentsElementDidConsume:imageElement];
							  }];
	
	[self commonElementHandle:imageElement];
}

- (void)handleTextElement:(TextElement*)textElement {
	[_textView setTextElement:textElement];
	
	[_textView startStreamingWithInterval:0.05f
							   completion:^(void) {
								   NSLog(@"TextView Animation Did Finish.");
								   [_indicatorView startAnimation];
								   [self contentsElementDidConsume:textElement];
							   }];
	
	[self commonElementHandle:textElement];
}

- (void)handleWaitElement:(WaitElement *)waitElement {
	[NSTimer scheduledTimerWithTimeInterval:waitElement.duration
									repeats:NO
									  block:^(NSTimer* timer) {
										  NSLog(@"Wait Interval Did Pass.");
										  [self contentsElementDidConsume:waitElement];
									  }];
}

- (void)commonElementHandle:(ContentsElement*)element {
	if (element.chainType == ChainTypeImmediate) {
		[self advanceContents:element];
	}
}

- (void)contentsElementDidConsume:(ContentsElement*)element {
	if (element.chainType != ChainTypeNone) {
		[self advanceContents:element];
	} else {
		_isContentsOngoing = NO;
	}
}

@end

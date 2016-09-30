//
//  ContentsViewController.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/31.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "ContentsViewController.h"

#import "AppDelegate.h"
#import "ContentsInterface.h"
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
#import "GestureHintView.h"
#import "SaveData.h"
#import "HistorySelectView.h"
#import "NSString+CustomDecoder.h"

const CGFloat kHeightOfIndicator		= 40.0f;
const CGFloat kSideMarginOfViews		= 10.0f;
const CGFloat kLongPressActionLength	= 10.0f;
const CGFloat kLongPressAvailableLength	= 10.0f;
const NSInteger kAlertTagEndOfSection	= 10001;
const NSInteger kAlertTagEndOfContents	= 10002;
const NSInteger	kAlertTagConfirmNext	= 10010;
const NSInteger	kAlertTagConfirmBack	= 10011;
const NSInteger	kAlertTagConfirmFinish	= 10020;
const CGFloat kContentsTitleTextSize	= 36.0f;

@interface ContentsViewController ()

@property (nonatomic, readwrite) NSInteger	sectionIndex;

// CoreDataに保存したコンテンツを読み込む
- (void)loadContentsFromCoreData;
	
// コンテンツを先にひとつ進める
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

// ロングプレスを検知したイベントをハンドリングする
- (void)longPressDidDetect:(UILongPressGestureRecognizer*)gestureRecognizer;

@end

@implementation ContentsViewController

@synthesize sectionIndex = _sectionIndex;

- (id)initWithSectionIndex:(NSInteger)sectionIndex {
	if (self = [super init]) {
		_sectionIndex = sectionIndex;
		_currentIndex = -1;
		_isContentsOngoing = NO;
		
		_beganPoint = CGPointZero;
		_endPoint = CGPointZero;
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
	
	// ジェスチャ(=ロングプレス)のヒントを表示するView
	UIFont* font = [UIFont fontWithName:[ContentsInterface sharedInstance].fontName size:20.0f];
	_gestureHintView = [[GestureHintView alloc] initWithFrame:self.view.bounds
														 font:font
														hints:NSLocalizedString(@"phrase_text_history", nil), NSLocalizedString(@"phrase_save", nil), NSLocalizedString(@"phrase_back", nil), nil];
	[self.view addSubview:_gestureHintView];
	
	// ジェスチャレコグナイザの設定
	_gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
																	   action:@selector(longPressDidDetect:)];
	_gestureRecognizer.minimumPressDuration = 0.6f;
	_gestureRecognizer.enabled = NO;
	[self.view addGestureRecognizer:_gestureRecognizer];
	
	// セーブデータ選択用View
	_historyView = [[HistorySelectView alloc] initWithFrame:self.view.bounds withClose:YES withSwitch:YES];
	_historyView.saveMode = YES;
	[_historyView dismissAnimated:NO completion:nil];
	[self.view addSubview:_historyView];

	[self loadContentsFromCoreData];
}

- (void)viewDidAppear:(BOOL)animated {
	[self advanceContents:nil];
}

- (void)touchesEnded:(NSSet<UITouch*>*)touches withEvent:(UIEvent *)event {
	[self advanceContents:nil];
}

- (void)loadContentsFromCoreData {
	CoreDataHandler* handler = [CoreDataHandler sharedInstance];
	NSFetchedResultsController* result = [handler fetch:_sectionIndex];
	
	NSMutableArray* contents = [[NSMutableArray alloc] init];

	for (NSManagedObject* obj in result.fetchedObjects) {
		ContentsElement* e = [self elementByManagedObject:obj];
		if (e) {
			[contents addObject:e];
		}
	}
	
	_contents = [NSArray arrayWithArray:contents];
	
	[[ContentsInterface sharedInstance] saveDataAtSlotNumber:0].section = _sectionIndex;
}

- (void)alertDidConfirmAt:(NSInteger)alertTag action:(NSInteger)actionTag {
	// 章の終了時に発生するアラート
	if (alertTag == kAlertTagEndOfSection) {
		// 次へ行く場合
		if (actionTag == kAlertTagConfirmNext) {
			++_sectionIndex;
			_currentIndex = -1;
			_isContentsOngoing = NO;
			
			[self loadContentsFromCoreData];
			[self advanceContents:nil];
		// 前の画面に戻る場合
		} else {
			[self dismissViewControllerAnimated:YES completion:nil];
		}
	// 物語の終了時に発生するアラート(常に前の画面に戻る)
	} else if (alertTag == kAlertTagEndOfContents) {
		[self dismissViewControllerAnimated:YES completion:nil];
	}
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
			AlertControllerHandler* handler;
			
			ContentsInterface* cif = [ContentsInterface sharedInstance];
			if (element.section < cif.maxSectionIndex) {
				NSString* msg = NSLocalizedString(@"message_section_finished", @"END-OF-SECTION");
				handler = [[AlertControllerHandler alloc] initWithTitle:nil
																message:msg
														  preferrdStyle:UIAlertControllerStyleAlert
																	tag:kAlertTagEndOfSection];
				[handler addAction:NSLocalizedString(@"phrase_next_section", @"GO-NEXT-SECTION") style:UIAlertActionStyleDefault tag:kAlertTagConfirmNext];
				[handler addAction:NSLocalizedString(@"phrase_back", @"GO-BACK") style:UIAlertActionStyleCancel tag:kAlertTagConfirmBack];
			} else {
				NSString* msg = NSLocalizedString(@"message_last_section_finished", @"END-OF-SECTION");
				handler = [[AlertControllerHandler alloc] initWithTitle:nil
																message:msg
														  preferrdStyle:UIAlertControllerStyleAlert
																	tag:kAlertTagEndOfContents];
				[handler addAction:NSLocalizedString(@"phrase_ok", @"OK") style:UIAlertActionStyleDefault tag:kAlertTagConfirmFinish];
			}
			
			handler.delegate = self;
			
			[self presentViewController:[handler build] animated:YES completion:nil];
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
	ContentsInterface* cif = [ContentsInterface sharedInstance];
	
	[_titleView setTitle:titleElement.title font:[UIFont fontWithName:cif.fontName
																 size:kContentsTitleTextSize]];
	
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
	
	[_textView startStreamingWithInterval:[ContentsInterface sharedInstance].textSpeedInterval
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
	SaveData* autoSave = [[ContentsInterface sharedInstance] saveDataAtSlotNumber:0];
	[autoSave addElement:element];
	[autoSave save];
	
	if (element.chainType != ChainTypeNone) {
		[self advanceContents:element];
	} else {
		_gestureRecognizer.enabled = YES;
		_isContentsOngoing = NO;
	}
}

- (void)longPressDidDetect:(UILongPressGestureRecognizer*)gestureRecognizer {
	if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
		_beganPoint = [gestureRecognizer locationInView:self.view];

		BOOL isLeft = (_beganPoint.x < self.view.bounds.size.width / 2.0f);
		CGFloat saveX = isLeft ? _beganPoint.x + 120.0f : _beganPoint.x - 120.0f;
		
		[_gestureHintView setCenterAtIndex:0 center:CGPointMake(_beganPoint.x, _beganPoint.y - 120.0f)];
		[_gestureHintView setCenterAtIndex:1 center:CGPointMake(saveX, _beganPoint.y)];
		[_gestureHintView setCenterAtIndex:2 center:CGPointMake(_beganPoint.x, _beganPoint.y + 120.0f)];
		[_gestureHintView showWithDuration:0.6f hint:0.1f];
	} else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
		_endPoint = [gestureRecognizer locationInView:self.view];

		[_gestureHintView hideWithDuration:0.6f hint:0.1f];
		
		// 上方向(テキスト履歴)
		if (_beganPoint.y - _endPoint.y >= kLongPressActionLength && fabs(_endPoint.x - _beganPoint.x) <= kLongPressAvailableLength) {
			NSLog(@"Open Text History.");
		// 下方向(閉じる)
		} else if (_endPoint.y - _beganPoint.y >= kLongPressActionLength && fabs(_endPoint.x - _beganPoint.x) <= kLongPressAvailableLength) {
			[self dismissViewControllerAnimated:YES completion:nil];
		} else {
			BOOL isLeft = (_beganPoint.x < self.view.bounds.size.width / 2.0f);
			
			// 画面左側でロングタップが開始された場合、右方向ならセーブ
			if (isLeft && (_endPoint.x - _beganPoint.x) >= kLongPressActionLength && fabs(_endPoint.y - _beganPoint.y) <= kLongPressAvailableLength) {
				[_historyView showAnimated:YES completion:nil];
			// 画面右側でロングタップが開始された場合、左方向ならセーブ
			} else if (!isLeft && (_beganPoint.x - _endPoint.x) >= kLongPressActionLength && fabs(_beganPoint.y - _endPoint.y) <= kLongPressAvailableLength) {
				[_historyView showAnimated:YES completion:nil];
			} else {
				// そのまま離したら何もしない
			}
		}
	}
}

@end

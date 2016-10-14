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
#import "TextHistoryViewController.h"
#import "TutorialViewController.h"
#import "NSString+CustomDecoder.h"

const CGFloat kHeightOfIndicator	= 40.0f;
const CGFloat kSideMarginOfViews	= 10.0f;

const NSInteger kAlertTagEndOfSection	= 10001;
const NSInteger kAlertTagEndOfContents	= 10002;
const NSInteger kAlertTagSaveHistory	= 10003;
const NSInteger kAlertTagLoadHistory	= 10004;
const NSInteger	kAlertTagConfirmNext	= 10010;
const NSInteger	kAlertTagConfirmBack	= 10011;
const NSInteger	kAlertTagConfirmFinish	= 10020;
const NSInteger kAlertTagConfirmOk		= 10030;
const NSInteger kAlertTagConfirmCancel	= 10031;

@interface ContentsViewController ()

@property (nonatomic, readwrite)	NSInteger	sectionIndex;
@property (nonatomic)				SaveData*	autoSaveData;

// CoreDataに保存したコンテンツを読み込む
- (void)loadContentsAt:(NSInteger)sectionIndex;

// コンテンツを先にひとつ進める
- (void)advanceContents:(ContentsElement*)element;

// セーブデータが保存された時点でのView等の表示状態を復元する
- (void)restoreSavedCondition:(SaveData*)saveData;

// handle~で始まるメソッドが、その中で呼び出す共通処理
- (void)advanceIfImmediateChain:(ContentsElement*)element;

// handle~で始まるメソッド群がそれぞれの処理を終了した時に共通で呼び出すメソッド
// 各メソッドにある完了ブロックで定義すると同じ処理が複数箇所に分散してしまうので
- (void)contentsElementDidConsume:(ContentsElement*)element;

// ロングプレスを検知したイベントをハンドリングする
- (void)respondsToLongPress:(UILongPressGestureRecognizer*)gestureRecognizer;

@end

@implementation ContentsViewController

@synthesize sectionIndex = _sectionIndex;

#pragma mark - Initializer

- (id)initWithSectionIndex:(NSInteger)sectionIndex {
	if (self = [super init]) {
		[self loadContentsAt:sectionIndex];
		
		[self.autoSaveData reset];
		self.autoSaveData.sectionIndex = sectionIndex;
		
		_isContentsOngoing = NO;
		
		_longPressBeganPoint = CGPointZero;
		_longPressEndPoint = CGPointZero;
	}
	return self;
}

- (id)initWithSaveData:(SaveData*)saveData {
	if (self = [super init]) {
		[self loadContentsAt:saveData.sectionIndex];
		
		if (self.autoSaveData.slotNumber != saveData.slotNumber) {
			[self.autoSaveData copyFrom:saveData includeTitle:NO];
		}
		
		_isContentsOngoing = NO;
		
		_longPressBeganPoint = CGPointZero;
		_longPressEndPoint = CGPointZero;
	}
	return self;
}

#pragma mark - ViewController Lifecycle & Overwrite

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
	_gestureHintView = [[GestureHintView alloc] initWithFrame:self.view.bounds];
	[_gestureHintView setHint:NSLocalizedString(@"phrase_text_history", nil) direction:GestureDirectionNorth];
	[_gestureHintView setHint:NSLocalizedString(@"phrase_load", nil) direction:GestureDirectionEast];
	[_gestureHintView setHint:NSLocalizedString(@"phrase_back", nil) direction:GestureDirectionSouth];
	[_gestureHintView setHint:NSLocalizedString(@"phrase_save", nil) direction:GestureDirectionWest];
	_gestureHintView.delegate = self;
	[self.view addSubview:_gestureHintView];
	
	// ジェスチャレコグナイザの設定
	_gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
																	   action:@selector(respondsToLongPress:)];
	_gestureRecognizer.minimumPressDuration = 0.6f;
	_gestureRecognizer.enabled = NO;
	[self.view addGestureRecognizer:_gestureRecognizer];
	
	// セーブデータ選択用View
	_historyView = [[HistorySelectView alloc] initWithFrame:self.view.bounds closable:YES loadOnly:NO autoSave:NO];
	_historyView.saveMode = YES;
	_historyView.delegate = self;
	[_historyView dismissAnimated:NO completion:nil];
	[self.view addSubview:_historyView];
	
	if (self.autoSaveData.isSaved) {
		[self restoreSavedCondition:self.autoSaveData];
	}
}

- (void)viewDidAppear:(BOOL)animated {
	if (![ContentsInterface sharedInstance].tutorialFinished) {
		TutorialViewController* vc = [[TutorialViewController alloc] init];
		vc.delegate = self;
		[self presentViewController:vc animated:YES completion:nil];
	} else {
		[self advanceContents:nil];
	}
}

- (void)touchesEnded:(NSSet<UITouch*>*)touches withEvent:(UIEvent *)event {
	ContentsElement* e = [_contents objectAtIndex:_currentIndex];

	// テキストが進行中(アニメーション実行中)であればそれをキャンセルして
	// 表示する予定のテキストをすべて表示する
	if (_isContentsOngoing && e.contentsType == ContentsTypeText) {
		[_textView cancelAnimation];
		[_indicatorView startAnimation];
		
		[self advanceIfImmediateChain:e];
		
		[self contentsElementDidConsume:e];
	} else {
		[self advanceContents:nil];
	}
}

#pragma mark - Properties

- (SaveData*)autoSaveData {
	return [[ContentsInterface sharedInstance] saveDataAt:0];
}

#pragma mark - Convenience Method

- (void)loadContentsAt:(NSInteger)sectionIndex {
	NSFetchedResultsController* result = [[CoreDataHandler sharedInstance] fetch:sectionIndex];
	
	NSMutableArray* contents = [[NSMutableArray alloc] init];

	for (NSManagedObject* obj in result.fetchedObjects) {
		ContentsElement* e = [ContentsElement contentsElementWithManagedObject:obj];
		if (e) {
			[contents addObject:e];
		}
	}
	
	_contents = [NSArray arrayWithArray:contents];
	_sectionIndex = sectionIndex;
	_currentIndex = -1;
	
	self.autoSaveData.sectionIndex = sectionIndex;
}

- (void)advanceContents:(ContentsElement*)element {
	if (!_isContentsOngoing || (element && element.chainType != ChainTypeNone)) {
		if (++_currentIndex < _contents.count) {
			[_indicatorView stopAnimation];
			
			ContentsElement* e = [_contents objectAtIndex:_currentIndex];
			
			if (e.contentsType == ContentsTypeImage) {
				[_imageView handleElement:e
							   completion:^(void) {
								   [self contentsElementDidConsume:e];
							   }];
				
				[self advanceIfImmediateChain:e];
			} else if (e.contentsType == ContentsTypeText || e.contentsType == ContentsTypeClearText) {
				[_textView handleElement:e
							  completion:^(void) {
								  [_indicatorView startAnimation];
								  [self contentsElementDidConsume:e];
							  }];
				
				if (e.contentsType == ContentsTypeText) {
					[self advanceIfImmediateChain:e];
				}
			} else if (e.contentsType == ContentsTypeTitle) {
				[_titleView handleElement:e
							   completion:^(void) {
								   [self contentsElementDidConsume:e];
							   }];
				
				[self advanceIfImmediateChain:e];
			} else if (e.contentsType == ContentsTypeWait) {
				[NSTimer scheduledTimerWithTimeInterval:((WaitElement*)e).duration
												repeats:NO
												  block:^(NSTimer* timer) {
													  [self contentsElementDidConsume:e];
												  }];
			}
			
			_isContentsOngoing = YES;
		} else {
			AlertControllerHandler* handler;
			
			ContentsInterface* cif = [ContentsInterface sharedInstance];
			
			// 章(section)が終了したので次に行くか、戻るか、終了するか
			if (element.section < cif.maxSectionIndex) {
				NSString* msg = NSLocalizedString(@"message_section_finished", nil);
				handler = [[AlertControllerHandler alloc] initWithTitle:nil
																message:msg
														  preferrdStyle:UIAlertControllerStyleAlert
																	tag:kAlertTagEndOfSection];
				[handler addAction:NSLocalizedString(@"phrase_next_section", nil) style:UIAlertActionStyleDefault tag:kAlertTagConfirmNext];
				[handler addAction:NSLocalizedString(@"phrase_back", nil) style:UIAlertActionStyleCancel tag:kAlertTagConfirmBack];
			// 最後の章が終了したので戻る
			} else {
				NSString* msg = NSLocalizedString(@"message_last_section_finished", nil);
				handler = [[AlertControllerHandler alloc] initWithTitle:nil
																message:msg
														  preferrdStyle:UIAlertControllerStyleAlert
																	tag:kAlertTagEndOfContents];
				[handler addAction:NSLocalizedString(@"phrase_ok", nil) style:UIAlertActionStyleDefault tag:kAlertTagConfirmFinish];
			}
			
			handler.delegate = self;
			
			[self presentViewController:[handler build] animated:YES completion:nil];
		}
	}
}

- (void)restoreSavedCondition:(SaveData*)saveData {
	if (saveData) {
		_currentIndex = saveData.sequence;
		
		for (NSNumber* key in saveData.elementSequences.allKeys) {
			ContentsType type = [key integerValue];
			
			if (type == ContentsTypeImage) {
				NSInteger seq = [[saveData.elementSequences objectForKey:key] integerValue];
				ImageElement* elm = [_contents objectAtIndex:seq];
				
				[_imageView setNextImage:elm.image];
				[_imageView showImmediate];
			}
		}
	}
}

- (void)advanceIfImmediateChain:(ContentsElement*)element {
	if (element.chainType == ChainTypeImmediate) {
		[self advanceContents:element];
	}
}

- (void)contentsElementDidConsume:(ContentsElement*)element {
	[self.autoSaveData addElement:element];
	[self.autoSaveData save];
	
	if (element.chainType != ChainTypeNone) {
		[self advanceContents:element];
	} else {
		_gestureRecognizer.enabled = YES;
		_isContentsOngoing = NO;
	}
}

#pragma mark - Delegate Method

- (void)alertDidConfirmAt:(NSInteger)alertTag action:(NSInteger)actionTag {
	// 章の終了時に発生するアラート
	if (alertTag == kAlertTagEndOfSection) {
		// 次へ行く場合
		if (actionTag == kAlertTagConfirmNext) {
			_isContentsOngoing = NO;
			
			NSInteger nextIndex = _sectionIndex + 1;
			[self loadContentsAt:nextIndex];
			
			[self.autoSaveData reset];
			self.autoSaveData.sectionIndex = nextIndex;
			
			[self advanceContents:nil];
		// 前の画面に戻る場合
		} else {
			[self dismissViewControllerAnimated:YES completion:nil];
		}
	// 物語の終了時に発生するアラート(常に前の画面に戻る)
	} else if (alertTag == kAlertTagEndOfContents) {
		[self dismissViewControllerAnimated:YES completion:nil];
	// セーブ
	} else if (alertTag == kAlertTagSaveHistory) {
		if (actionTag == kAlertTagConfirmOk) {
			[_targetSaveData copyFrom:self.autoSaveData includeTitle:NO];
			[_targetSaveData save];
			
			[_historyView dismissAnimated:YES completion:nil];
		}
	// ロード
	} else if (alertTag == kAlertTagLoadHistory) {
		if (actionTag == kAlertTagConfirmOk) {
			[_imageView reset];
			[_textView clearAllTexts];
			
			[self loadContentsAt:_targetSaveData.sectionIndex];
			[self restoreSavedCondition:_targetSaveData];
			[self.autoSaveData copyFrom:_targetSaveData includeTitle:NO];
			
			[_historyView dismissAnimated:YES
							   completion:^(void) {
								   [self advanceContents:nil];
							   }];
		}
	}
}

- (void)historyDidSelected:(SaveData *)saveData forSave:(BOOL)forSave {
	NSString* msg = forSave ? NSLocalizedString(@"message_save_confirmation", nil) : NSLocalizedString(@"message_load_confirmation", nil);
	
	NSInteger tag = forSave ? kAlertTagSaveHistory : kAlertTagLoadHistory;
	
	_targetSaveData = saveData;
	
	AlertControllerHandler* handler = [[AlertControllerHandler alloc] initWithTitle:nil
																			message:msg
																	  preferrdStyle:UIAlertControllerStyleAlert
																				tag:tag];
	[handler addAction:NSLocalizedString(@"phrase_ok", nil)
				 style:UIAlertActionStyleDefault
				   tag:kAlertTagConfirmOk];
	[handler addAction:NSLocalizedString(@"phrase_cancel", nil)
				 style:UIAlertActionStyleCancel
				   tag:kAlertTagConfirmCancel];
	handler.delegate = self;
	
	[self presentViewController:[handler build] animated:YES completion:nil];
}

- (void)hintGestureDidDetect:(GestureDirection)direction {
	if (direction == GestureDirectionNorth) {
		SaveData* saveData = [[ContentsInterface sharedInstance] saveDataAt:0];
		TextHistoryViewController* vc = [[TextHistoryViewController alloc] initWithTextHistories:saveData.textHistories];
		[self presentViewController:vc animated:YES completion:nil];
	} else if (direction == GestureDirectionEast) {
		_historyView.saveMode = YES;
		[_historyView refresh];
		[_historyView showAnimated:YES completion:nil];
	} else if (direction == GestureDirectionSouth) {
		[self dismissViewControllerAnimated:YES completion:nil];
	} else if (direction == GestureDirectionWest) {
		_historyView.saveMode = YES;
		[_historyView refresh];
		[_historyView showAnimated:YES completion:nil];
	}
}

- (void)overlayViewControllerDismissed:(id)sender {
	if ([sender isMemberOfClass:[TutorialViewController class]]) {
		[ContentsInterface sharedInstance].tutorialFinished = YES;
	}
	
	[self advanceContents:nil];
}

#pragma mark - Selector

- (void)respondsToLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
	if (_historyView.shown || _isContentsOngoing) {
		return;
	}
	
	CGPoint point = [gestureRecognizer locationInView:_gestureHintView];
	
	if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
		[_gestureHintView startGestureAt:point];
	} else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
		[_gestureHintView endGestureAt:point];
	}
}

@end

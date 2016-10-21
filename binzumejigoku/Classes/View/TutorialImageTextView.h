//
//  TutorialGestureView.h
//  SampleApp
//
//  Created by Shizuo Ichitake on 2016/10/14.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * チュートリアルの画像を寄せる方向を示す列挙値
 */
typedef NS_ENUM(NSUInteger, TutorialImageAlignment) {
	/** 左寄せ */
	TutorialImageAlignmentLeft,
	/** 右寄せ */
	TutorialImageAlignmentRight,
};

/**
 * 画像とテキストで構成されるチュートリアルを表示させるためのView
 */
@interface TutorialImageTextView : UIView {
	@private
	NSMutableArray<NSDictionary*>*	_tutorials;
}

/** フォント */
@property (nonatomic)	UIFont*		font;

/** テキストカラー */
@property (nonatomic)	UIColor*	textColor;

/**
 * 画像とテキストからなるチュートリアルを追加する
 * @param	text			テキスト
 * @param	image			画像
 * @param	imageAlignment	画像を寄せる方向
 */
- (void)addTutorial:(NSString*)text image:(UIImage*)image imageAlignment:(TutorialImageAlignment)imageAlignment;

/**
 * テキストのみからなるチュートリアルを追加する
 * @param	text	テキスト
 */
- (void)addTutorial:(NSString*)text;

/**
 * addTutorialメソッドで追加した内容が適切な場所で表示されるようViewを構成する<br />
 * Viewを表示する前にこのメソッドを呼び出すこと
 */
- (void)compose;

@end

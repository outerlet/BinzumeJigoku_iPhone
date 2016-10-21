//
//  GestureHintView.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/09/27.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * ジェスチャが行われた方向を示す列挙値
 */
typedef NS_ENUM(NSUInteger, GestureDirection) {
	/** 不明(=未確定) */
	GestureDirectionUnknown	= 0,
	/** 上方向 */
	GestureDirectionNorth	= 1,
	/** 右方向 */
	GestureDirectionEast	= 2,
	/** 下方向 */
	GestureDirectionSouth	= 3,
	/** 左方向 */
	GestureDirectionWest	= 4,
};

/**
 * ジェスチャが成立したイベントを補足するデリゲート
 */
@protocol GestureHintViewDelegate <NSObject>

/**
 * ジェスチャが成立したイベントを通知するデリゲートメソッド
 * @param	direction	ジェスチャが成立した方向
 */
- (void)hintGestureDidDetect:(GestureDirection)direction;

@end

/**
 * ロングタップのジェスチャに関するヒントを表示するView
 */
@interface GestureHintView : UIView {
	@private
	NSMutableDictionary<NSNumber*, UILabel*>*	_hintLabels;
	CGPoint	_startPoint;
}

/** ジェスチャが成立したイベントを捕捉するデリゲート */
@property (nonatomic)	id<GestureHintViewDelegate>	delegate;

/**
 * イニシャライザ
 * @param	frame		Viewを初期化するバウンディングボックス
 * @return	初期化されたインスタンス
 */
- (id)initWithFrame:(CGRect)frame;

/**
 *
 * @param	hintText
 * @param	direction
 */
- (void)setHint:(NSString*)hintText direction:(GestureDirection)direction;

/**
 * ジェスチャをこの位置から開始する<br />
 * このViewを表示させ、setHint:direction:で追加したヒントを表示する
 * @param	startPoint	ジェスチャを開始する位置
 */
- (void)startGestureAt:(CGPoint)startPoint;

/**
 * ジェスチャをこの位置で終了させる<br />
 * デリゲートメソッドを呼び出し、このViewを非表示にする
 * @param	endPoint	ジェスチャを終了させる位置
 */
- (void)endGestureAt:(CGPoint)endPoint;

@end

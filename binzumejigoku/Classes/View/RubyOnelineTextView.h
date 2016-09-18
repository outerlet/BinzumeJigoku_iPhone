//
//  RubyOnelineTextView.h
//  SampleApp
//
//  Created by Shizuo Ichitake on 2016/09/11.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * ルビ入りテキスト1行を表示する<br />
 * 1行表示に特化したViewなので改行などは自動で入らない
 */
@interface RubyOnelineTextView : UIView {
	@private
	NSMutableAttributedString*	_attributedString;
}

/** このViewのサイズ */
@property (nonatomic, readonly)	CGSize	requiredSize;

/** このViewに表示されるテキストの文字数 */
@property (nonatomic, readonly)	NSInteger	length;

/**
 * イニシャライザ
 * @param attributedString	このViewに表示するAttributed String
 */
- (id)initWithMutableAttributedString:(NSMutableAttributedString*)attributedString;

- (void)appendAttributedString:(NSAttributedString*)appendage;

@end

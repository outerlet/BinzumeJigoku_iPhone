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
	CGSize						_size;
}

/** このViewに表示されるAttributed String(ただしMutable) */
@property (nonatomic, readonly)	NSMutableAttributedString*	attributedString;

/** このViewのサイズ */
@property (nonatomic, readonly)	CGSize	size;

/**
 * イニシャライザ
 * @param attributedString	このViewに表示するAttributed String
 */
- (id)initWithMutableAttributedString:(NSMutableAttributedString*)attributedString;

@end

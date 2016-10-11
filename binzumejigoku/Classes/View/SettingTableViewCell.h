//
//  SettingTableViewCell.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/31.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 設定画面の各項目に相当するUITableViewCellのサブクラス
 */
@interface SettingTableViewCell : UITableViewCell

@property (nonatomic, readonly) UILabel*	subjectLabel;
@property (nonatomic, readonly) UILabel*	descriptionLabel;

/**
 * イニシャライザ<br />
 * バウンディングボックスとIDを与えてこのTableViewCellを初期化する
 * @param	frame			バウンディングボックス
 * @param	reuseIdentifier	セルに対して与えるID
 * @return	初期化済みのインスタンス
 */
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier;

@end

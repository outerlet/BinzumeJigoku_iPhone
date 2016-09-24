//
//  SettingTableViewCell.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/07/31.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "SettingTableViewCell.h"
#import "AppDelegate.h"
#import "ContentsInterface.h"

static const CGFloat kCellSidePadding		= 40.0f;

@interface SettingTableViewCell ()

@property (nonatomic, readwrite) UILabel*	subjectLabel;
@property (nonatomic, readwrite) UILabel*	descriptionLabel;

@end

@implementation SettingTableViewCell

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
		ContentsInterface* cif = [ContentsInterface sharedInstance];
		
		self.subjectLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		self.subjectLabel.backgroundColor = [UIColor clearColor];
		self.subjectLabel.textColor = [UIColor blackColor];
		self.subjectLabel.font = [UIFont fontWithName:cif.fontName size:cif.settingSubjectTextSize];
		self.subjectLabel.textAlignment = NSTextAlignmentLeft;
		self.subjectLabel.lineBreakMode = NSLineBreakByTruncatingTail;
		self.subjectLabel.numberOfLines = 1;
		[self.contentView addSubview:self.subjectLabel];
		
		self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		self.descriptionLabel.backgroundColor = [UIColor clearColor];
		self.descriptionLabel.textColor = [UIColor blackColor];
		self.descriptionLabel.font = [UIFont fontWithName:cif.fontName size:cif.settingDescriptionTextSize];
		self.descriptionLabel.textAlignment = NSTextAlignmentRight;
		self.descriptionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
		self.descriptionLabel.numberOfLines = 1;
		[self.contentView addSubview:self.descriptionLabel];
		
		self.frame = frame;
	}
	return self;
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	
	CGRect f = self.contentView.bounds;
	f.size.width -= kCellSidePadding;
	f.size.height /= 2.0f;
	f.origin.x += kCellSidePadding / 2.0f;
	
	self.subjectLabel.frame = f;
	
	f.origin.y += self.subjectLabel.frame.size.height;
	self.descriptionLabel.frame = f;
}

@end

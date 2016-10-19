//
//  TutorialGestureView.m
//  SampleApp
//
//  Created by Shizuo Ichitake on 2016/10/14.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "TutorialImageTextView.h"
#import "UIView+Adjustment.h"

static NSString* const kDictionaryKeyText			= @"DICTIONARY_KEY_TEXT";
static NSString* const kDictionaryKeyImage			= @"DICTIONARY_KEY_IMAGE";
static NSString* const kDictionaryKeyImageAlignment	= @"DICTIONARY_KEY_IMAGE_ALIGNMENT";

@interface TutorialImageTextView ()

- (NSAttributedString*)attributeString:(NSString*)string;

@end

@implementation TutorialImageTextView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		_tutorials = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)addTutorial:(NSString*)text image:(UIImage*)image imageAlignment:(TutorialImageAlignment)imageAlignment {
	[_tutorials addObject:@{ kDictionaryKeyText: text, kDictionaryKeyImage: image, kDictionaryKeyImageAlignment: [NSNumber numberWithInt:imageAlignment] }];
}

- (void)addTutorial:(NSString *)text {
	[_tutorials addObject:@{ kDictionaryKeyText: text}];
}

- (void)compose {
	CGFloat viewHeight = self.bounds.size.height / _tutorials.count;
	
	CGFloat labelWidth = self.bounds.size.width * 0.6f;
	CGFloat imageWidth = self.bounds.size.width * 0.3f;
	CGFloat spaceOfViews = (self.bounds.size.width - (labelWidth + imageWidth)) / 3.0f;
	
	for (NSInteger idx = 0 ; idx < _tutorials.count ; idx++) {
		NSDictionary* tutorial = [_tutorials objectAtIndex:idx];
		
		NSString* text = [tutorial objectForKey:kDictionaryKeyText];
		UIImage* image = [tutorial objectForKey:kDictionaryKeyImage];
		NSNumber* number = [tutorial objectForKey:kDictionaryKeyImageAlignment];

		BOOL textOnly = (!image || !number);
		
		CGRect frame = CGRectZero;
		frame.size.width = textOnly ? self.bounds.size.width * 0.9f : labelWidth;
		frame.size.height = viewHeight;
		
		UILabel* label = [[UILabel alloc] initWithFrame:frame];
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentLeft;
		label.numberOfLines = 0;
		label.attributedText = [self attributeString:text];
		[self addSubview:label];
		
		if (!textOnly) {
			UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, imageWidth, viewHeight)];
			imageView.contentMode = UIViewContentModeScaleAspectFit;
			imageView.image = image;
			[self addSubview:imageView];
			
			TutorialImageAlignment alignment = [number integerValue];
			
			if (alignment == TutorialImageAlignmentLeft) {
				[imageView moveTo:CGPointMake(spaceOfViews, viewHeight * idx)];
				[label moveTo:CGPointMake(imageView.frame.size.width + spaceOfViews * 2.0f, viewHeight * idx)];
			} else {
				[label moveTo:CGPointMake(spaceOfViews, viewHeight * idx)];
				[imageView moveTo:CGPointMake(label.frame.size.width + spaceOfViews * 2.0f, viewHeight * idx)];
			}
		} else {
			[label moveTo:CGPointMake(spaceOfViews, viewHeight * idx)];
		}
	}
}

- (NSAttributedString*)attributeString:(NSString*)string {
	NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
	style.minimumLineHeight = style.maximumLineHeight = 32.0f;
	
	NSDictionary* attrs = @{ NSFontAttributeName: self.font, NSForegroundColorAttributeName: self.textColor, NSParagraphStyleAttributeName: style };
	
	return [[NSAttributedString alloc] initWithString:string attributes:attrs];
}

@end

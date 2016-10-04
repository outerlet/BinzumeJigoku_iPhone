//
//  SaveData.h
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/09/25.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContentsElement;

@interface SaveData : UIView <NSCoding>

@property (nonatomic, readonly)	NSInteger									slotNumber;
@property (nonatomic)			NSString*									title;
@property (nonatomic, readonly)	NSDate*										date;
@property (nonatomic)			NSInteger									sectionIndex;
@property (nonatomic, readonly)	NSInteger									sequence;
@property (nonatomic, readonly)	NSMutableDictionary<NSNumber*, NSNumber*>*	elementSequences;
@property (nonatomic, readonly)	NSMutableArray<NSString*>*					textHistories;
@property (nonatomic, readonly)	BOOL										isSaved;

- (id)initWithSlotNumber:(NSInteger)slotNumber;
- (void)addElement:(ContentsElement*)element;
- (void)copyFrom:(SaveData*)other;
- (void)save;
- (BOOL)load;
- (void)reset;

@end

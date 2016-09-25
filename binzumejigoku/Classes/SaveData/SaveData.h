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

@property (nonatomic, readonly)	NSInteger					slotNumber;
@property (nonatomic)			NSInteger					section;
@property (nonatomic, readonly)	NSMutableArray<NSString*>*	textHistories;

- (id)initWithSlotNumber:(NSInteger)slotNumber;
- (void)addElement:(ContentsElement*)element;
- (void)save;
- (void)load;
- (void)reset;

@end

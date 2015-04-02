//
//  XWSettingArrowItem.h
//  XWeiBo
//
//  Created by DP on 14/12/2.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWSettingItem.h"

@class XWSettingArrowItem;

typedef void (^XWSettingArrowItemReadyForDestVc)(id item, id destVc);

@interface XWSettingArrowItem : XWSettingItem

@property (assign, nonatomic) Class destVcClass;
@property (copy, nonatomic) XWSettingArrowItemReadyForDestVc readyForDestVc;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass;
+ (instancetype)itemWithTitle:(NSString *)title destVcClass:(Class)destVcClass;

@end

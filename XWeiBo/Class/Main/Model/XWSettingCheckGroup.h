//
//  XWSettingCheckGroup.h
//  XWeiBo
//
//  Created by DP on 14/12/2.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWSettingGroup.h"
@class XWSettingCheckItem, XWSettingLabelItem;
@interface XWSettingCheckGroup : XWSettingGroup

@property (assign, nonatomic) int checkedIndex;

@property (strong, nonatomic) XWSettingCheckItem *checkedItem;
@property (strong, nonatomic) XWSettingLabelItem *sourceItem;

@end

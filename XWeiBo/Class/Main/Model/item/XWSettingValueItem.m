//
//  XWSettingValueItem.m
//  XWeiBo
//
//  Created by DP on 14/12/2.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWSettingValueItem.h"

@implementation XWSettingValueItem
- (NSString *)key
{
    return _key ? _key : self.title;
}

@end

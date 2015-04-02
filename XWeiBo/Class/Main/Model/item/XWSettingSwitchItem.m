//
//  XWSettingSwitchItem.m
//  XWeiBo
//
//  Created by DP on 14/12/2.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWSettingSwitchItem.h"

@implementation XWSettingSwitchItem
- (id)init
{
    if (self = [super init]) {
        self.defaultOn = YES;
    }
    return self;
}

- (BOOL)isOn
{
    id value = [XWUserDefaults objectForKey:self.key];
    if (value == nil) {
        return self.isDefaultOn;
    } else {
        return [value boolValue];
    }
}

- (void)setOn:(BOOL)on
{
    [XWUserDefaults setBool:on forKey:self.key];
    [XWUserDefaults synchronize];
}

@end

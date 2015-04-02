//
//  XWSettingLabelItem.m
//  XWeiBo
//
//  Created by DP on 14/12/2.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWSettingLabelItem.h"

@implementation XWSettingLabelItem
- (NSString *)text
{
    id value = [XWUserDefaults objectForKey:self.key];
    if (value == nil) {
        return self.defaultText;
    } else {
        return value;
    }
}

- (void)setText:(NSString *)text
{
    [XWUserDefaults setObject:text forKey:self.key];
    [XWUserDefaults synchronize];
}
@end

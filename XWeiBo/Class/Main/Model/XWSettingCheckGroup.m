//
//  XWSettingCheckGroup.m
//  XWeiBo
//
//  Created by DP on 14/12/2.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWSettingCheckGroup.h"
#import "XWSettingCheckItem.h"
#import "XWSettingLabelItem.h"

@implementation XWSettingCheckGroup
- (XWSettingCheckItem *)checkedItem
{
    for (XWSettingCheckItem *item in self.items) {
        if (item.isChecked) {
            return item;
        }
    }
    return nil;
}

- (void)setCheckedItem:(XWSettingCheckItem *)checkedItem
{
    for (XWSettingCheckItem *item in self.items) {
        item.checked = (item == checkedItem);
    }
    self.sourceItem.text = checkedItem.title;
}

- (void)setCheckedIndex:(int)checkedIndex
{
    if (checkedIndex < 0 || checkedIndex >= self.items.count) {
        return;
    }
    
    self.checkedItem = self.items[checkedIndex];
}

- (void)setItems:(NSArray *)items
{
    [super setItems:items];
    self.sourceItem = self.sourceItem;
}
- (void)setSourceItem:(XWSettingLabelItem *)sourceItem
{
    _sourceItem = sourceItem;
    
    for (XWSettingCheckItem *item in self.items) {
        item.checked = [item.title isEqualToString:sourceItem.text];
    }
}

@end

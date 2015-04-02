//
//  XWSettingCell.h
//  XWeiBo
//
//  Created by DP on 14/12/2.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWBgCell.h"
@class XWSettingItem;
@interface XWSettingCell : XWBgCell

@property (strong, nonatomic) XWSettingItem *item;
@property (strong, nonatomic) NSIndexPath *indexPath;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

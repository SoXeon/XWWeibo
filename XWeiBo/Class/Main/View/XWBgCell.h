//
//  XWBgCell.h
//  XWeiBo
//
//  Created by DP on 14/12/2.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWBgCell : UITableViewCell
{
    /** 背景view */
    UIImageView *bg;
    /** 选中的背景view */
    UIImageView *selectedBg;

}
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

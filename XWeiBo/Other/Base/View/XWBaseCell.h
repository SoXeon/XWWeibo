//
//  XWBaseCell.h
//  XWeiBo
//
//  Created by DP on 14/12/3.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
@interface XWBaseCell : SWTableViewCell
{
    UIImageView *_bg;
    UIImageView *_selectedBg;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

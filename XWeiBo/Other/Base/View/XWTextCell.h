//
//  XWTextCell.h
//  XWeiBo
//
//  Created by DP on 14/12/3.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWBaseWordCell.h"
@class XWBaseTextCellFrame;
@interface XWTextCell : XWBaseWordCell

@property (nonatomic, strong) XWBaseTextCellFrame *cellFrame;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) UITableView *myTableView;
@end

//
//  XWStatusCellFrame.m
//  XWeiBo
//
//  Created by DP on 14/12/3.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWStatusCellFrame.h"
#import "XWStatus.h"
#import "XWUser.h"
#import "XWIconView.h"
#import "XWImageListView.h"

@implementation XWStatusCellFrame
- (void)setStatus:(XWStatus *)status
{
    [super setStatus:status];
    
    _cellHeight += kStatusDockHeight;
}
@end

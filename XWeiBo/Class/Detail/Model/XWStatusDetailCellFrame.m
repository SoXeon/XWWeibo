//
//  XWStatusDetailCellFrame.m
//  XWeiBo
//
//  Created by DP on 14/12/3.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWStatusDetailCellFrame.h"
#import "XWStatus.h"
@implementation XWStatusDetailCellFrame
- (void)setStatus:(XWStatus *)status
{
    [super setStatus:status];
    
    if (status.retweetedStatus) {
        _retweetedFrame.size.height += kRetweetedDockHeight;
        _cellHeight += kRetweetedDockHeight;
    }
}
@end

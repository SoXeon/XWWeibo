//
//  XWStatusCell.m
//  XWeiBo
//
//  Created by DP on 14/12/3.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWStatusCell.h"
#import "XWStatusCellFrame.h"
#import "XWStatusDock.h"

@interface XWStatusCell()
{
    XWStatusDock *_dock;
}
@end

@implementation XWStatusCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 操作条
        CGFloat y = self.frame.size.height - kStatusDockHeight;
        _dock = [[XWStatusDock alloc] initWithFrame:CGRectMake(0, y, 0, 0)];
        [self.contentView addSubview:_dock];
    }
    return self;
}

- (void)setCellFrame:(XWBaseStatusCellFrame *)cellFrame
{
    [super setCellFrame:cellFrame];
    _dock.status = cellFrame.status;
}
@end

//
//  XWDetailCell.m
//  XWeiBo
//
//  Created by DP on 14/12/3.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWDetailCell.h"
#import "XWRetweetedDock.h"
#import "XWBaseStatusCellFrame.h"
#import "XWStatus.h"
#import "XWStatusDetailController.h"
#import "XWTabBarController.h"

@interface XWDetailCell()
{
    XWRetweetedDock *_dock;
}

@end

@implementation XWDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        // 1.操作条
        XWRetweetedDock *dock = [[XWRetweetedDock alloc] init];
        dock.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        CGFloat x = _retweeted.frame.size.width - dock.frame.size.width;
        CGFloat y = _retweeted.frame.size.height - dock.frame.size.height;
        dock.frame = CGRectMake(x, y, 0, 0);
        [_retweeted addSubview:dock];
        _dock = dock;
        
        // 2.监听被转发微博的点击
        [_retweeted addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showRetweeted)]];
    }
    return self;
}

- (void)showRetweeted
{
    // 展示被转发的微博
    XWStatusDetailController *detail = [[XWStatusDetailController alloc] init];
    detail.status = _dock.status;
   
    XWTabBarController *main = (XWTabBarController *)self.window.rootViewController;
    UINavigationController *nav =  (UINavigationController *)main.selectedController;
    
    [nav pushViewController:detail animated:YES];
}

- (void)setCellFrame:(XWBaseStatusCellFrame *)cellFrame
{
    [super setCellFrame:cellFrame];
    
    // 设置子控件的数据
    _dock.status = cellFrame.status.retweetedStatus;
}



@end

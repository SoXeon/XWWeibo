//
//  XWBaseRefreshViewController.m
//  XWeiBo
//
//  Created by DP on 14/12/4.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWBaseRefreshViewController.h"

@implementation XWBaseRefreshViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _header = [MJRefreshHeaderView header];
    _header.delegate = self;
    _header.scrollView = self.tableView;
    [_header beginRefreshing];
    
    _footer = [MJRefreshFooterView footer];
    _footer.delegate = self;
    _footer.scrollView = self.tableView;
}

- (void)viewDidAppear:(BOOL)animated {}

- (void)dealloc
{
    [_header free];
    [_footer free];
}
@end

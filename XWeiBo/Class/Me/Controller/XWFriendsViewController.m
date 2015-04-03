//
//  XWFriendsViewController.m
//  XWeiBo
//
//  Created by DP on 14/12/5.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWFriendsViewController.h"
#import "XWUserTool.h"
#import "XWFriendshipResult.h"
#import "XWFriendshipParam.h"
#import "MJRefresh.h"

@implementation XWFriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"全部关注";
    
    [self addRefreshView];
}

- (void)addRefreshView
{
    __weak typeof(&*self) weakSelf = self;
    
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        
        __strong typeof(&*self) strongSelf = weakSelf;
        
        if (strongSelf) {
            [strongSelf loadNewFriends];
        }
        
    }];
    
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        
        __strong typeof(&*self) strongSelf = weakSelf;
        
        if (strongSelf) {
            [strongSelf loadNewFriends];
        }
    }];
    
    [self.tableView.header beginRefreshing];

}

- (void)loadNewFriends
{
    _param.cursor = @(_result.previous_cursor);
    
    [XWUserTool friendsWithParam:_param success:^(XWFriendshipResult *result) {
        _result = result;
        // 1.新数据
        NSMutableArray *newUsers = [NSMutableArray arrayWithArray:result.users];
        [newUsers addObjectsFromArray:_friendships];
        _friendships = newUsers;
        
        // 3.刷新表格
        [self.tableView reloadData];
        
        // 4.刷新控件
        [self.tableView.header endRefreshing];
    } failure:^(NSError *error){
        [self.tableView.header endRefreshing];
    }];
}

- (void)loadMoreFriends
{
    _param.cursor = @(_result.next_cursor);
    
    [XWUserTool friendsWithParam:_param success:^(XWFriendshipResult *result) {
        _result = result;
        // 1.新数据
        [_friendships addObjectsFromArray:result.users];
        
        // 2.刷新表格
        [self.tableView reloadData];
        
        // 3.刷新控件
        [self.tableView.footer endRefreshing];
    } failure:^(NSError *error){
        [self.tableView.footer endRefreshing];
    }];
}

@end

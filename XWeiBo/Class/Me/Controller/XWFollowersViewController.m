//
//  XWFollowersViewController.m
//  XWeiBo
//
//  Created by DP on 14/12/5.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWFollowersViewController.h"
#import "XWUserTool.h"
#import "XWFriendshipParam.h"
#import "XWFriendshipResult.h"
#import "MJRefresh.h"

@implementation XWFollowersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"全部粉丝";
    
    [self refreshFollowers];
}


- (void)refreshFollowers
{
    
    __weak typeof(&*self) weakSelf = self;
    
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        
        __strong typeof(&*self) strongSelf = weakSelf;

        if (strongSelf) {
            [strongSelf loadNewFollwers];
        }

    }];
    
    [self.tableView addLegendFooterWithRefreshingBlock:^{
       
        __strong typeof(&*self) strongSelf = weakSelf;
        
        if (strongSelf) {
            [strongSelf loadMoreFollwers];
        }
    }];
    
    [self.tableView.header beginRefreshing];
}

- (void)loadNewFollwers
{
    _param.cursor = @(_result.previous_cursor);
    
    [XWUserTool followersWithParam:_param success:^(XWFriendshipResult *result) {
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

- (void)loadMoreFollwers
{
    _param.cursor = @(_result.next_cursor);
    
    [XWUserTool followersWithParam:_param success:^(XWFriendshipResult *result) {
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

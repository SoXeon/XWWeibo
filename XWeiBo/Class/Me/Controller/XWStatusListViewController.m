//
//  XWStatusListViewController.m
//  XWeiBo
//
//  Created by DP on 14/12/5.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWStatusListViewController.h"
#import "XWStatusTool.h"
#import "XWStatusResult.h"
#import "XWSingleStatusParam.h"
#import "XWStatusCellFrame.h"
#import "XWStatus.h"
#import "XWStatusCell.h"
#import "MJRefresh.h"
#import "XWStatusDetailController.h"

@interface XWStatusListViewController()

@end

@implementation XWStatusListViewController

- (id)init
{
    if (self = [super init]) {
        _param = [[XWSingleStatusParam alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"全部微博";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self loadNewStatuses];
    
    
    __weak typeof(&*self) weakSelf = self;

    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        __strong typeof(&*self) strongSelf = weakSelf;

        if (strongSelf) {
            [strongSelf loadNewStatuses];
        }
    }];
    
    [self.tableView.header beginRefreshing];
    
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        
        __strong typeof(&*self) strongSelf = weakSelf;

        if (strongSelf) {
            [strongSelf loadMoreStatuses];
        }
    }];

}

- (void)loadNewStatuses
{
    if (_statusFrames.count) {
        XWStatusCellFrame *sf = _statusFrames[0];
        _param.since_id = @(sf.status.idstr.longLongValue);
        _param.max_id = nil;
    }
    
    [XWStatusTool everyUserStatusesWithParams:@{
                                                @"uid" : _param.uid
                                                
                                                }
                                      success:^(NSArray *statues) {
                                          NSMutableArray *newFrames = [NSMutableArray array];

                                          for (XWStatus *status in statues) {
                                              XWStatusCellFrame *sf = [[XWStatusCellFrame alloc] init];
                                              sf.status = status;
                                              [newFrames addObject:sf];
                                          }
                                          [newFrames addObjectsFromArray:_statusFrames];
                                          _statusFrames = newFrames;
                                          [self.tableView reloadData];
                                          [self.tableView.header endRefreshing];
        
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];
}

- (void)loadMoreStatuses
{
    if (_statusFrames.count) {
        XWStatusCellFrame *sf = [_statusFrames lastObject];
        _param.max_id = @(sf.status.idstr.longLongValue - 1);
        _param.since_id = nil;
    }

    [XWStatusTool everyUserStatusesWithParams:@{
                                                @"uid" : _param.uid
                                                
                                                }
                                      success:^(NSArray *statues) {
                                          NSMutableArray *newFrames = [NSMutableArray array];
                                          
                                          for (XWStatus *status in statues) {
                                              XWStatusCellFrame *sf = [[XWStatusCellFrame alloc] init];
                                              sf.status = status;
                                              [newFrames addObject:sf];
                                          }
                                          [newFrames addObjectsFromArray:_statusFrames];
                                          _statusFrames = newFrames;
                                          [self.tableView reloadData];
                                          [self.tableView.footer endRefreshing];
                                          
                                      } failure:^(NSError *error) {
                                          [self.tableView.footer endRefreshing];
                                      }];}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_result.total_number == _statusFrames.count) {
        self.tableView.footer.hidden = YES;
    } else {
        self.tableView.footer.hidden = NO;
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XWStatusDetailController *detail = [[XWStatusDetailController alloc] init];
    XWStatusCellFrame *f = _statusFrames[indexPath.row];
    detail.status = f.status;
    [self.navigationController pushViewController:detail animated:YES];
}

@end

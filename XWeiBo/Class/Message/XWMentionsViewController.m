//
//  XWMentionsViewController.m
//  XWeiBo
//
//  Created by DP on 15/2/15.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWMentionsViewController.h"
#import "XWStatusDetailController.h"
#import "SLPagingViewController.h"
#import "MJRefresh.h"
#import "XWStatusCell.h"
#import "XWStatusCellFrame.h"
#import "XWStatusTool.h"
#import "XWStatus.h"

@interface XWMentionsViewController ()
{
    NSMutableArray *_statusFrames;
}

@end

@implementation XWMentionsViewController

- (id)init
{
    if (self = [super init]) {
        

    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self buildUI];
    
    [self addRefreshViews];
}



- (void)buildUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)addRefreshViews
{
    _statusFrames = [NSMutableArray array];
    
    __weak typeof(&*self) weakSelf = self;
    
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        
        __strong typeof(&*self) strongSelf = weakSelf;
        
        if (strongSelf) {
            [strongSelf loadNewData];
        }
        
    }];
    
    [self.tableView.header beginRefreshing];
    
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        
        __strong typeof(&*self) strongSelf = weakSelf;
        
        if (strongSelf) {
            [strongSelf loadMoreData];
        }
    }];


}

#pragma mark 加载最新数据
- (void)loadNewData
{
    // 1.第1条微博的ID
    XWStatusCellFrame *f = _statusFrames.count?_statusFrames[0]:nil;
    long long first = [f.status ID];
    
    [XWStatusTool metionsWithSinceId:first maxId:0 success:^(NSArray *statues) {
    
            
            // 1.在拿到最新微博数据的同时计算它的frame
            NSMutableArray *newFrames = [NSMutableArray array];
            for (XWStatus *s in statues) {
                XWStatusCellFrame *f = [[XWStatusCellFrame alloc] init];
                f.status = s;
                [newFrames addObject:f];
            }
            
            // 2.将newFrames整体插入到旧数据的前面
            [_statusFrames insertObjects:newFrames atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newFrames.count)]];
            
            // 3.刷新表格
            [self.tableView reloadData];
            
            // 4.让刷新控件停止刷新状态
            [self.tableView.header endRefreshing];

        } failure:^(NSError *error) {
            [self.tableView.header endRefreshing];

        }];
}

- (void)loadMoreData
{
    // 1.最后1条微博的ID
    XWStatusCellFrame *f = [_statusFrames lastObject];
    long long last = [f.status ID];
    
    [XWStatusTool metionsWithSinceId:0 maxId:last -1 success:^(NSArray *statues) {
        // 1.在拿到最新微博数据的同时计算它的frame
        NSMutableArray *newFrames = [NSMutableArray array];
        for (XWStatus *s in statues) {
            XWStatusCellFrame *f = [[XWStatusCellFrame alloc] init];
            f.status = s;
            [newFrames addObject:f];
        }
        
        // 2.将newFrames整体插入到旧数据的后面
        [_statusFrames addObjectsFromArray:newFrames];
        
        // 3.刷新表格
        [self.tableView reloadData];
        
        // 4.让刷新控件停止刷新状态
        [self.tableView.footer endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.footer endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView Delegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _statusFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    XWStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[XWStatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.cellFrame = _statusFrames[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_statusFrames[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    XWStatusDetailController *detail = [[XWStatusDetailController alloc] init];
    XWStatusCellFrame *f = _statusFrames[indexPath.row];
    detail.status = f.status;

    [self.navigationController pushViewController:detail animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

@end

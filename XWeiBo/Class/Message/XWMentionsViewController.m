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

@interface XWMentionsViewController () <MJRefreshBaseViewDelegate>
{
    NSMutableArray *_statusFrames;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;

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

    // 1.下拉刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.delegate = self;
    _header = header;
    [_header beginRefreshing];
    
    // 2.上拉加载更多
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.delegate = self;
    _footer = footer;

}

#pragma mark 刷新代理方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == _footer) {
        [self loadMoreData:refreshView];
    } else {
        [self loadNewData:refreshView];
    }
}

#pragma mark 加载最新数据
- (void)loadNewData:(MJRefreshBaseView *)refreshView
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
            [refreshView endRefreshing];
            
        } failure:^(NSError *error) {
    
        }];
}

- (void)loadMoreData:(MJRefreshBaseView *)refreshView
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
        [refreshView endRefreshing];
    } failure:^(NSError *error) {
        [refreshView endRefreshing];
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

- (void)dealloc
{
    [_header free];
    [_footer free];
}

@end

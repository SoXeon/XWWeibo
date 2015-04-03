//
//  XWMessageTableViewController.m
//  XWeiBo
//
//  Created by DP on 15/2/14.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWMessageTableViewController.h"
#import "XWRepeatCommentsViewController.h"
#import "XWNavigationController.h"
#import "XWStatusTool.h"
#import "XWStatus.h"
#import "XWOwnComment.h"
#import "XWOwnCommentCell.h"
#import "XWOwnCommentsCellFrame.h"
#import "MJRefresh.h"
#import "UIImage+DP.h"
#import "XWStatus.h"

@interface XWMessageTableViewController () < XWCommentsCellDelegate>
{
    NSMutableArray *_commentsFrames;
}

@end

@implementation XWMessageTableViewController

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
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kTableBorderWidth, 0);
    
}

- (void)addRefreshViews
{
    _commentsFrames = [NSMutableArray array];
    
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
    XWOwnCommentsCellFrame *f = _commentsFrames.count?_commentsFrames[0]:nil;
    long long first = [f.ownComments commentsID];
    
    [XWStatusTool ownCommentsWithSinceId:first maxId:0 success:^(NSArray *ownComments) {
        
        NSMutableArray *newFrames = [NSMutableArray array];
        for (XWOwnComment *o in ownComments) {
            XWOwnCommentsCellFrame *f = [[XWOwnCommentsCellFrame alloc] init];
            f.ownComments = o;
            [newFrames addObject:f];
        }
        
        
        [_commentsFrames insertObjects:newFrames atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newFrames.count)]];
        [self.tableView reloadData];
        
        [self.tableView.header endRefreshing];
        
    } failure:^(NSError *error) {
        
        [self.tableView.header endRefreshing];
    }];
    
}

- (void)loadMoreData
{
    
    XWOwnCommentsCellFrame *f = [_commentsFrames lastObject];
    long long last = [f.ownComments commentsID];
    
    [XWStatusTool ownCommentsWithSinceId:0 maxId:last -1 success:^(NSArray *ownComments) {
        NSMutableArray *newFrames = [NSMutableArray array];
        
        for (XWOwnComment *o in ownComments) {
            
            XWOwnCommentsCellFrame *f = [[XWOwnCommentsCellFrame alloc] init];
            f.ownComments = o;
            [newFrames addObject:f];
        }
        
        [_commentsFrames addObjectsFromArray:newFrames];
        [self.tableView reloadData];

        [self.tableView.footer endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.footer endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentsFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    XWOwnCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[XWOwnCommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.cellFrame = _commentsFrames[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_commentsFrames[indexPath.row] cellHeight];
}

#pragma mark commentsCell Delegate
- (void)commentsCell:(XWOwnCommentCell *)cell didTapCommentsButton:(UIButton *)button
{
        
    XWRepeatCommentsViewController *compose = [[XWRepeatCommentsViewController alloc] init];
    compose.ownComment = cell.cellFrame.ownComments;
    XWNavigationController *nav = [[XWNavigationController alloc] initWithRootViewController:compose];
    [self presentViewController:nav animated:YES completion:nil];

}

@end

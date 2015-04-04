//
//  XWStatusDetailController.m
//  XWeiBo
//
//  Created by DP on 14/12/3.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWStatusDetailController.h"
#import "XWDetailCell.h"
#import "XWStatusDetailCellFrame.h"
#import "DetailHeader.h"
#import "XWStatusTool.h"
#import "XWStatus.h"
#import "XWCommentCellFrame.h"
#import "XWRepostCellFrame.h"
#import "XWComment.h"
#import "XWRepostCell.h"
#import "XWCommentCell.h"
#import "MJRefresh.h"

@interface XWStatusDetailController() <DetailHeaderDelegate, UIScrollViewDelegate>
{
    XWStatusDetailCellFrame *_detailFrame;
    NSMutableArray *_repostFrames; // 转发frame数据
    NSMutableArray *_commentFrames; // 评论frame数据
    
    
    BOOL _commentLastPage; // 评论数据是否为最后一页
    BOOL _repostLastPage; // 转发数据是否为最后一页

}

@property (nonatomic, strong)DetailHeader *detailHeader;


@end

@implementation XWStatusDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"微博正文";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kTableBorderWidth, 0);
    
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    _detailFrame = [[XWStatusDetailCellFrame alloc] init];
    _detailFrame.status = _status;
    
    _repostFrames = [NSMutableArray array];
    _commentFrames = [NSMutableArray array];
    
    [self addRefreshViews];
    
    _detailHeader = [DetailHeader header];
    _detailHeader.delegate = self;
    
    // 默认点击了“评论”
    [self detailHeader:nil btnClick:kDetailHeaderBtnTypeComment];

}

- (void)addRefreshViews
{
    __weak typeof(&*self) weakSelf = self;
    
   [self.tableView addLegendHeaderWithRefreshingBlock:^{
       

       
       __strong typeof(&*self) strongSelf = weakSelf;
       
       if (strongSelf) {
           [strongSelf loadNewStatus];
           
       }

   }];
    
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        
        __strong typeof(&*self) strongSelf = weakSelf;
        
        if (strongSelf) {
            // 上拉加载更多
            if (strongSelf.detailHeader.currentBtnType == kDetailHeaderBtnTypeRepost) {
                [strongSelf loadMoreRepost]; // 加载更多的转发
            } else { // 加载更多的评论
                [strongSelf loadMoreComment];
            }
        }
        
        
    }];
    
}

#pragma mark 获得当前需要使用的数组
- (NSMutableArray *)currentFrames
{
    if (_detailHeader.currentBtnType == kDetailHeaderBtnTypeComment) {
        return _commentFrames;
    } else {
        return _repostFrames;
    }
}

#pragma mark - 数据源\代理方法
#pragma mark 1.有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 1.判断上拉加载更多控件要不要显示
    if (_detailHeader.currentBtnType == kDetailHeaderBtnTypeComment) {
        self.tableView.header.hidden = _commentLastPage;
    } else {
        self.tableView.footer.hidden = _repostLastPage;
    }
    return 2;
}

#pragma mark 2.第section组头部控件有多高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) return 0;
    return 50;
}

#pragma mark 3.第section组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section ? [[self currentFrames] count]: 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return _detailFrame.cellHeight;
    } else {
        return [self.currentFrames[indexPath.row] cellHeight];
    }

}

#pragma mark 5.indexPath这行的cell长什么样子
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) { // 微博详情cell
        static NSString *CellIdentifier = @"DetailCell";
        XWDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[XWDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }
        
        cell.cellFrame = _detailFrame;
        
        return cell;
    } else if (_detailHeader.currentBtnType == kDetailHeaderBtnTypeRepost) {
        // 转发cell
        static NSString *CellIdentifier = @"RepostCell";
        XWRepostCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[XWRepostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.myTableView = tableView;
        }
        
        cell.indexPath = indexPath;
        cell.cellFrame = _repostFrames[indexPath.row];
        
        return cell;
    } else {
        // 评论cell
        static NSString *CellIdentifier = @"CommentCell";
        XWCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[XWCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.myTableView = tableView;
        }
        
        cell.indexPath = indexPath;
        cell.cellFrame = _commentFrames[indexPath.row];
        
        return cell;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
}

#pragma mark 判断第indexPath行的cell能不能达到选中状态
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section;
}

#pragma mark 6.第section组头部显示什么控件
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) return nil;
    _detailHeader.status = _status;
    return _detailHeader;
}

#pragma mark - DetailHeader的代理方法
- (void)detailHeader:(DetailHeader *)header btnClick:(DetailHeaderBtnType)index
{
    // 1.先刷新表格(马上显示对应的旧数据)
    [self.tableView reloadData];
    
    if (index == kDetailHeaderBtnTypeRepost) { // 点击了转发
        [self loadNewRepost];
    } else if (index == kDetailHeaderBtnTypeComment) { // 点击了评论
        [self loadNewComment];
    }
}

#pragma mark 解析模型数据为frame数据
- (NSMutableArray *)framesWithModels:(NSArray *)models class:(Class)class
{
    NSMutableArray *newFrames = [NSMutableArray array];
    for (XWBaseText *s in models) {
        XWBaseTextCellFrame *f = [[class alloc] init];
        f.baseText = s;
        [newFrames addObject:f];
    }
    return newFrames;
}

#pragma mark 加载最新的微博数据
- (void)loadNewStatus
{
    [XWStatusTool statusWithId:_status.ID success:^(XWStatus *status) {
        _status = status;
        _detailFrame.status = status;
        
        // 刷新表格
        [self.tableView reloadData];
        
        [self.tableView.header endRefreshing];
    } failure:^(NSError *r){
        [self.tableView.header endRefreshing];
    }];
}

#pragma mark 加载最新的转发数据
- (void)loadNewRepost
{
    long long firstId = _repostFrames.count?[[_repostFrames[0] baseText] ID]:0;
    
    [XWStatusTool repostsWithSinceId:firstId maxId:0 statusId:_status.ID success:^(NSArray *reposts, int totoalNumber, long long nextCursor) {
        // 1.解析最新的转发frame数据
        NSMutableArray *newFrames = [self framesWithModels:reposts class:[XWRepostCellFrame class]];
     
        _status.repostsCount = totoalNumber;
        
        // 2.添加数据
        [_repostFrames insertObjects:newFrames atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newFrames.count)]];
        
        _repostLastPage = nextCursor == 0;
        
        // 3.刷新表格
        [self.tableView reloadData];
        
    } failure:nil];
}

#pragma mark 加载最新的评论数据
- (void)loadNewComment
{
    long long firstId = _commentFrames.count?[[_commentFrames[0] baseText] ID]:0;
    
    [XWStatusTool commentsWithSinceId:firstId maxId:0 statusId:_status.ID success:^(NSArray *comments, int totalNumber, long long nextCursor) {
        // 1.解析最新的评论frame数据
        NSMutableArray *newFrames = [self framesWithModels:comments class:[XWCommentCellFrame class]];
        
        _status.commentsCount = totalNumber;
        
        // 2.添加数据到旧数据的前面
        [_commentFrames insertObjects:newFrames atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newFrames.count)]];
        
        _commentLastPage = nextCursor == 0;
        
        // 3.刷新表格
        [self.tableView reloadData];
    } failure:nil];
}

#pragma mark 加载更多的转发数据
- (void)loadMoreRepost
{
    long long lastId = [[[_repostFrames lastObject] baseText] ID] - 1;
    
    [XWStatusTool repostsWithSinceId:0 maxId:lastId statusId:_status.ID success:^(NSArray *reposts, int totalNumber, long long nextCursor) {
        // 1.解析最新的评论frame数据
        NSMutableArray *newFrames = [self framesWithModels:reposts class:[XWRepostCellFrame class]];
        
        _status.repostsCount = totalNumber;
        
        // 2.添加数据到旧数据的后面
        [_repostFrames addObjectsFromArray:newFrames];
        
        _repostLastPage = nextCursor == 0;
        
        // 3.刷新表格
        [self.tableView reloadData];
        
        [self.tableView.footer endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.footer endRefreshing];
    }];
}


#pragma mark 加载更多的评论数据
- (void)loadMoreComment
{
    long long lastId = [[[_commentFrames lastObject] baseText] ID] - 1;
    
    [XWStatusTool commentsWithSinceId:0 maxId:lastId statusId:_status.ID success:^(NSArray *comments, int totalNumber, long long nextCursor) {
        // 1.解析最新的评论frame数据
        NSMutableArray *newFrames = [self framesWithModels:comments class:[XWCommentCellFrame class]];
        
        _status.commentsCount = totalNumber;
        
        // 2.添加数据到旧数据的后面
        [_commentFrames addObjectsFromArray:newFrames];
        _commentLastPage = nextCursor == 0;
        
        // 3.刷新表格
        [self.tableView reloadData];
        
        [self.tableView.footer endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.footer endRefreshing];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}

@end

//
//  XWHomeTableViewController.m
//  XWeiBo
//
//  Created by DP on 14/12/2.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWHomeTableViewController.h"
#import "XWBadgeButton.h"
#import "UIBarButtonItem+DP.h"
#import "XWTitleButton.h"
#import "XWAccountTool.h"
#import "XWStatusTool.h"
#import "XWStatus.h"
#import "XWUser.h"
#import "XWStatusCellFrame.h"
#import "XWStatusCell.h"
#import "MJRefresh.h"
#import "UIImage+DP.h"
#import "XWStatusDetailController.h"

#import "RepostViewController.h"
#import "CommentViewController.h"
#import "UIViewController+MaryPopin.h"

#import "ACTimeScroller.h"

#import "XWUserTool.h"
#import "XWUserParam.h"
#import "XWUser.h"
#import "XWIconView.h"

#import "kLink.h"
#import "TOWebViewController.h"


@interface XWHomeTableViewController () <SWTableViewCellDelegate, ACTimeScrollerDelegate, UIScrollViewDelegate>
{
    NSMutableArray *_statusFrames;
    ACTimeScroller *_timeScroller;
}

@property (nonatomic, assign) CGPoint cellPoint;
@property (nonatomic, assign) CGFloat cellOriginY;
@property (nonatomic, strong) XWIconView *userIconView;
@end

@implementation XWHomeTableViewController

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popToWebViewController:) name:kLinkDidSelectedNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self buildUI];
    
    [self setupNavItem];
    
    [self addRefreshViews];
}

- (void)popToWebViewController:(NSNotification *)notification
{
    
    NSString *webUrl = notification.userInfo[kLinkText];

    NSLog(@"webURL %@", webUrl);
    
    NSURL *url = [NSURL URLWithString:webUrl];
    
    //TODO: you change theme about webview
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:url];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:webViewController] animated:YES completion:^{
        
    }];
}

- (void)buildUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kTableBorderWidth, 0);
    
    _timeScroller = [[ACTimeScroller alloc] initWithDelegate:self];
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

#pragma mark 加载最新数据
- (void)loadNewData{
    // 1.第1条微博的ID
    XWStatusCellFrame *f = _statusFrames.count?_statusFrames[0]:nil;
    long long first = [f.status ID];
    
    // 2.获取微博数据
    [XWStatusTool statusesWithSinceId:first maxId:0 success:^(NSArray *statues){
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
        
        // 5.顶部展示最新微博的数目
        [self showNewStatusCount:(int)statues.count];
    } failure:^(NSError *error) {
        [self.tableView.header endRefreshing];
    }];
    
    //TODO:MLGB的API限制，我先去实现其他功能区
    NSDictionary *paramsDict = @{@"source": kAppKey, @"uid": [XWAccountTool sharedXWAccountTool].currentAccount.uid};
    
    [WBHttpRequest requestWithAccessToken:[XWAccountTool sharedXWAccountTool].currentAccount.accessToken url:@"https://api.weibo.com/2/place/users/photos.json" httpMethod:@"GET" params:paramsDict queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        
    }];
    
#warning fuck SB WeiBo, MLGB的要高级权限才可以用这个接口
    [XWStatusTool fetchFriendGroupWithSuccess:^(id JSON) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)loadMoreData
{
    // 1.最后1条微博的ID
    XWStatusCellFrame *f = [_statusFrames lastObject];
    long long last = [f.status ID];
    
    // 2.获取微博数据
    [XWStatusTool statusesWithSinceId:0 maxId:last - 1 success:^(NSArray *statues){
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

- (void)refreshContent:(BOOL)FromSelf
{
    if (self.tabBarItem.badgeValue) {
        [self.tableView.header beginRefreshing];

    } else if (FromSelf){
        NSIndexPath *firstRow = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [self.tableView scrollToRowAtIndexPath:firstRow atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark 展示最新微博的数目
- (void)showNewStatusCount:(int)count
{
    [UIApplication sharedApplication].applicationIconBadgeNumber -= self.tabBarItem.badgeValue.intValue;
    
    
    self.tabBarItem.badgeValue = nil;
    
    // 1.创建按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.enabled = NO;
    btn.adjustsImageWhenDisabled = NO;
    
    [btn setBackgroundImage:[UIImage resizedImage:@"timeline_new_status_background.png"] forState:UIControlStateNormal];
    CGFloat w = self.view.frame.size.width;
    CGFloat h = 35;
    btn.frame = CGRectMake(0, 66 - h, w, h);
    NSString *title = count?[NSString stringWithFormat:@"共有%d条新的微博", count]:@"没有新的微博";
    [btn setTitle:title forState:UIControlStateNormal];
    [self.navigationController.view insertSubview:btn belowSubview:self.navigationController.navigationBar];
    
    // 2.开始执行动画
    CGFloat duration = 0.5;
    
    [UIView animateWithDuration:duration animations:^{ // 下来
        btn.transform = CGAffineTransformMakeTranslation(0, h);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{// 上去
            btn.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [btn removeFromSuperview];
        }];
    }];
}


- (void)setupNavItem
{
    // 左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"navigationbar_friendsearch" highIcon:@"navigationbar_friendsearch_highlighted" target:self action:@selector(findFriend)];
        
    XWUserParam *userParam = [[XWUserParam alloc] init];
    
    [XWUserTool userWithParam:userParam success:^(XWUser *user) {
        
        UIImageView *iconImage = [[UIImageView alloc] init];
        iconImage.frame = CGRectMake(0, 0, 36, 36);
        iconImage.layer.cornerRadius = 10.0f;
        iconImage.layer.borderColor = [UIColor whiteColor].CGColor;
        iconImage.layer.borderWidth = 1.0f;
        iconImage.clipsToBounds = YES;
        
        [HttpTool downloadImage:user.avatar_large place:[UIImage imageNamed:@"avatar_default_small.png"] imageView:iconImage];
        
        UIBarButtonItem *mailbutton = [[UIBarButtonItem alloc] initWithCustomView:iconImage];
        self.navigationItem.rightBarButtonItem= mailbutton;
        self.navigationItem.title = user.name;
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

- (void)titleClick:(XWTitleButton *)titleButton
{
    if (titleButton.currentImage == [UIImage imageWithName:@"navigationbar_arrow_up"]) {
        [titleButton setImage:[UIImage imageWithName:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
        //        titleButton.tag = IWTitleButtonDownTag;
    } else {
        [titleButton setImage:[UIImage imageWithName:@"navigationbar_arrow_up"] forState:UIControlStateNormal];
        //        titleButton.tag = IWTitleButtonUpTag;
    }
}

- (void)findFriend
{
    XWLog(@"findFriend");
}

- (void)pop
{
    XWLog(@"pop");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source
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
        cell.rightUtilityButtons = [self rightButtons];
        cell.leftUtilityButtons = [self leftButtons];
        cell.delegate = self;
    }
    
    cell.cellFrame = _statusFrames[indexPath.row];
     return cell;
}


#pragma mark 自定义手势滑动 转发和评论
- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor greenColor] icon:[UIImage imageNamed:@"check.png"]];

    return leftUtilityButtons;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor greenColor] icon:[UIImage imageNamed:@"list.png"]];
    return rightUtilityButtons;
}

#pragma mark SWTableViewCell Delegate
- (void)swipeableTableViewCell:(XWStatusCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            [cell hideUtilityButtonsAnimated:NO];

            [self showRepostViewControllerWithStatus:cell.cellFrame];
        }
            
            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(XWStatusCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            [cell hideUtilityButtonsAnimated:NO];
            [self showCommentViewControllerWithStatus:cell.cellFrame];

            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    
    //TODO: 在特定事件触发下，刷新数据
    switch (state) {
        case 0:
            NSLog(@"utility buttons closed");
            break;
        case 1:
            NSLog(@"left utility buttons open");
            break;
        case 2:
            NSLog(@"right utility buttons open");
            break;
        default:
            break;
    }

}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)showRepostViewControllerWithStatus:(XWBaseStatusCellFrame *)cellFrame
{
    RepostViewController *repostVC = [[RepostViewController alloc] init];
    [repostVC setPopinTransitionStyle:BKTPopinTransitionStyleSpringySlide];
    [repostVC setPopinOptions:BKTPopinDisableAutoDismiss];
    [repostVC setPopinOptions:BKTPopinIgnoreKeyboardNotification];
    [repostVC setPreferedPopinContentSize:CGSizeMake(300.0, 240.0)];
    [repostVC setPopinTransitionDirection:BKTPopinTransitionDirectionLeft];
    [repostVC setPopinAlignment:BKTPopinAlignementOptionCentered];
    repostVC.status = cellFrame.status;

    [self presentPopinController:repostVC animated:YES completion:^{
        [repostVC.repostMessage becomeFirstResponder];
    }];
    
    
}

- (void)showCommentViewControllerWithStatus:(XWBaseStatusCellFrame *)cellFrame
{
    CommentViewController *commentVC = [[CommentViewController alloc] init];
    [commentVC setPopinTransitionStyle:BKTPopinTransitionStyleSpringySlide];
    [commentVC setPopinOptions:BKTPopinDisableAutoDismiss];
    [commentVC setPopinOptions:BKTPopinIgnoreKeyboardNotification];
    [commentVC setPreferedPopinContentSize:CGSizeMake(300.0, 240.0)];
    [commentVC setPopinTransitionDirection:BKTPopinTransitionDirectionRight];
    [commentVC setPopinAlignment:BKTPopinAlignementOptionCentered];
    commentVC.status = cellFrame.status;
    
    [self presentPopinController:commentVC animated:YES completion:^{
        [commentVC.commentTextView becomeFirstResponder];
    }];
    
}

#pragma mark 返回每一行cell的高度 每次tableView刷新数据的时候都会调用
// 而且会一次性算出所有cell的高度，比如有100条数据，一次性调用100次
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_statusFrames[indexPath.row] cellHeight];
}


#warning 现则存在一个BUG，就是从子页面返回，cell的位置会不同程度上移，但是我的页面StatusList中不会出现这种情况
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XWStatusDetailController *detail = [[XWStatusDetailController alloc] init];
    XWStatusCellFrame *f = _statusFrames[indexPath.row];
    detail.status = f.status;
    
    CGPoint point = [tableView contentOffset];
    self.cellPoint = point;

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"ddd%f",cell.frame.origin.y);//获取当前cell在table中的位置
    
    self.cellOriginY = cell.frame.origin.y;
    
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - ACTimeScrollerDelegate Methods
- (UITableView *)tableViewForTimeScroller:(ACTimeScroller *)timeScroller
{
    return [self tableView];
}

- (NSDate *)timeScroller:(ACTimeScroller *)timeScroller dateForCell:(XWStatusCell *)cell
{
    
    return cell.cellFrame.status.createdTime;
}

#pragma mark UIScrollviewDelegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_timeScroller scrollViewWillBeginDragging];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_timeScroller scrollViewDidScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [_timeScroller scrollViewDidEndDecelerating];
}

@end

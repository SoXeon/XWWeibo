//
//  XWMeViewController.m
//  XWeiBo
//
//  Created by DP on 14/12/2.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWMeViewController.h"
#import "IWProfileHeaderView.h"
#import "XWUserParam.h"

#import "XWStatusTool.h"
#import "XWStatusResult.h"
#import "XWSingleStatusParam.h"
#import "XWStatusCellFrame.h"
#import "XWStatusCell.h"

#import "XWProfileHeaderView.h"
#import "BLKDelegateSplitter.h"
#import "XWProfileHeaderViewBehaviorDefineer.h"

#import "XWUserTool.h"
#import "XWUser.h"
#import "HttpTool.h"

#import "UIButton+backgroundMusic.h"

@interface XWMeViewController () <UITableViewDelegate, UITableViewDataSource>
{
//    IWProfileHeaderView *_header;
//    XWProfileHeaderView *_customHeader;
    UIImageView *_bgView;
    
    XWSingleStatusParam *_param;
    XWStatusResult *_result;
    NSMutableArray *_statusFrames;
}

@property (nonatomic) BLKDelegateSplitter *delegateSplitter;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XWUser *currentUser;
@property (nonatomic, strong) XWProfileHeaderView *customHeader;
@end

@implementation XWMeViewController

- (id)init
{
    self = [super init];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheme) name:themeChangeNotification object:nil];
    }
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    _param = [[XWSingleStatusParam alloc] init];
    _statusFrames = [NSMutableArray array];
    
    [self loadNewStatus];

    // 1.添加背景图片
//    _bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile_cover_background.jpg"]];
//    CGFloat bgW = self.view.frame.size.width;
//    _bgView.bounds = CGRectMake(0, 0, bgW, bgW);
//    _bgView.layer.position = CGPointMake(bgW * 0.5, - bgW / 4);
//    _bgView.layer.anchorPoint = CGPointMake(0.5, 0);
//    [self.tableView addSubview:_bgView];
    
//    // 2.头部
//    _header = [IWProfileHeaderView header];
//    _header.param = [[XWUserParam alloc] init];
//    self.tableView.tableHeaderView = _header;
    [self setNeedsStatusBarAppearanceUpdate];
    
#warning 全部微博、粉丝、关注还没加上，回学校加上
    
    _customHeader = [[XWProfileHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 100.0)];
    
    NSData *colorData = [XWUserDefaults objectForKey:XWUserThemeColor];
    UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];

    if (color) {
        _customHeader.backgroundColor = color;
    }
    
    XWProfileHeaderViewBehaviorDefineer *behaviorDefiner = [[XWProfileHeaderViewBehaviorDefineer alloc] init];
    [behaviorDefiner addSnappingPositionProgress:0.0 forProgressRangeStart:0.0 end:0.5];
    [behaviorDefiner addSnappingPositionProgress:1.0 forProgressRangeStart:0.5 end:1.0];
    behaviorDefiner.snappingEnabled = YES;
    behaviorDefiner.elasticMaximumHeightAtTop = YES;
    _customHeader.behaviorDefiner = behaviorDefiner;
    
    XWUserParam *userParam = [[XWUserParam alloc] init];

    _customHeader.param = userParam;
    
    self.delegateSplitter = [[BLKDelegateSplitter alloc] initWithFirstDelegate:behaviorDefiner secondDelegate:self];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

    self.tableView.delegate = (id<UITableViewDelegate>)self.delegateSplitter;
    [self.view addSubview:_customHeader];
    
    
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 3.注册
    [self.tableView registerClass:[XWBaseStatusCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.contentInset = UIEdgeInsetsMake(_customHeader.maximumBarHeight, 0.0, 0.0, 0.0);

    self.tableView.dataSource = self;
    
    [self.view insertSubview:self.tableView belowSubview:_customHeader];

    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)changeTheme
{
    NSData *colorData = [XWUserDefaults objectForKey:XWUserThemeColor];
    UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    
    _customHeader.backgroundColor = color;
}


- (void)loadNewStatus
{
    [XWStatusTool everyUserStatusesWithParams:nil success:^(NSArray *statues) {
        
        NSMutableArray *newFrames = [NSMutableArray array];
        
        for (XWStatus *status in statues) {
            XWStatusCellFrame *sf = [[XWStatusCellFrame alloc] init];
            sf.status = status;
            [newFrames addObject:sf];
        }
        
        [newFrames addObjectsFromArray:_statusFrames];
        _statusFrames = newFrames;
        
        [self.tableView reloadData];

        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)refreshContent:(BOOL)FromSelf
{
    if (self.tabBarItem.badgeValue) {

        //TODO:RefreshContent will instead of ImageList
        
    } else if (FromSelf){
        NSIndexPath *firstRow = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [self.tableView scrollToRowAtIndexPath:firstRow atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
 
}

- (void)viewDidAppear:(BOOL)animated {}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [self loadNewStatus];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _statusFrames.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_statusFrames[indexPath.row] cellHeight] - 10.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XWBaseStatusCell *cell = [XWBaseStatusCell cellWithTableView:tableView];
    cell.cellFrame = _statusFrames[indexPath.row];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 0) return;
    
    // 1.向上的阻力系数（值越大，阻力越大，向上的力越大）
    CGFloat upFactor = 0.6;
    
    // 2.到什么位置开始放大
    CGFloat upMin = - (_bgView.frame.size.height / 8) / (1 - upFactor);
    
    // 3.还没到特定位置，就网上挪动
    if (offsetY >= upMin) {
        _bgView.transform = CGAffineTransformMakeTranslation(0, offsetY * upFactor);
    } else {
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0, offsetY - upMin * (1 - upFactor));
        CGFloat s = 1 + (upMin - offsetY) * 0.005;
        _bgView.transform = CGAffineTransformScale(transform, s, s);
    }
}

@end

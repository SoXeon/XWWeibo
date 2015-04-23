//
//  XWSquareViewController.m
//  XWeiBo
//
//  Created by DP on 14/12/2.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWSquareViewController.h"
#import "XWSearchBar.h"
#import "XWSettingArrowItem.h"
#import "XWSettingGroup.h"
#import "XWAnyMoreViewController.h"


@interface XWSquareViewController ()

@property (nonatomic, strong) UIButton *logoutBtn;

@end

@implementation XWSquareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    XWSearchBar *searchBar = [XWSearchBar searchBar];
    searchBar.frame = CGRectMake(0, 0, 300, 30);
    self.navigationItem.titleView = searchBar;
    
    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];

}

- (void)setupGroup0
{
    XWSettingGroup *group = [self addGroup];
    
    XWSettingArrowItem *hot = [XWSettingArrowItem itemWithIcon:@"hot_status" title:@"消息通知" destVcClass:nil];
    group.items = @[hot];
}

- (void)setupGroup1
{
    XWSettingGroup *group = [self addGroup];
    
    XWSettingArrowItem *gameCenter = [XWSettingArrowItem itemWithIcon:@"game_center" title:@"显示设置" destVcClass:nil];
    XWSettingArrowItem *near = [XWSettingArrowItem itemWithIcon:@"near" title:@"阅读设置" destVcClass:nil];
    XWSettingArrowItem *app = [XWSettingArrowItem itemWithIcon:@"app" title:@"音效设置" destVcClass:nil];

    group.items = @[gameCenter, near, app];
}

- (void)setupGroup2
{
    XWSettingGroup *group = [self addGroup];
    
    XWSettingArrowItem *video = [XWSettingArrowItem itemWithIcon:@"video" title:@"图片上传与保存" destVcClass:nil];
    XWSettingArrowItem *music = [XWSettingArrowItem itemWithIcon:@"music" title:@"存储与稍后读" destVcClass:nil];
    XWSettingArrowItem *movie = [XWSettingArrowItem itemWithIcon:@"movie" title:@"关于XWeiBo" destVcClass:nil];
    
    group.items = @[video, music, movie];
}

- (void)addBottomLogoutBtn
{
    CGRect footerRect = CGRectZero;
    footerRect.size.height = 50;
    footerRect.size.width = self.tableView.bounds.size.width;
    
    UIView *footerView = [[UIView alloc] initWithFrame:footerRect];
    
    CGRect btnRect = CGRectMake(10, 10, self.tableView.bounds.size.width - 20, 40);
    
    self.logoutBtn = [[UIButton alloc] initWithFrame:btnRect];
    [self.logoutBtn setBackgroundColor:[UIColor redColor]];
    [self.logoutBtn addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    [self.logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    self.logoutBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:self.logoutBtn];
    
    self.tableView.tableFooterView = footerView;
}

- (void)logoutAction
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 代理
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view.window endEditing:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view.window endEditing:YES];
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end

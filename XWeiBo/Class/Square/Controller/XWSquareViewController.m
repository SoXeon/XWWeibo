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
    
    XWSettingArrowItem *hot = [XWSettingArrowItem itemWithIcon:@"hot_status" title:@"热门微博" destVcClass:nil];
    hot.subtitle = @"笑话，娱乐，呵呵嗒";
    XWSettingArrowItem *find = [XWSettingArrowItem itemWithIcon:@"find_people" title:@"找好友" destVcClass:nil];
    find.subtitle = @"两块钱买不了吃亏，买不了上当";
    group.items = @[hot, find];
}

- (void)setupGroup1
{
    XWSettingGroup *group = [self addGroup];
    
    XWSettingArrowItem *gameCenter = [XWSettingArrowItem itemWithIcon:@"game_center" title:@"游戏中心" destVcClass:nil];
    XWSettingArrowItem *near = [XWSettingArrowItem itemWithIcon:@"near" title:@"周边" destVcClass:nil];
    XWSettingArrowItem *app = [XWSettingArrowItem itemWithIcon:@"app" title:@"应用" destVcClass:nil];

    group.items = @[gameCenter, near, app];
}

- (void)setupGroup2
{
    XWSettingGroup *group = [self addGroup];
    
    XWSettingArrowItem *video = [XWSettingArrowItem itemWithIcon:@"video" title:@"视频" destVcClass:nil];
    XWSettingArrowItem *music = [XWSettingArrowItem itemWithIcon:@"music" title:@"音乐" destVcClass:nil];
    XWSettingArrowItem *movie = [XWSettingArrowItem itemWithIcon:@"movie" title:@"电影" destVcClass:nil];
    XWSettingArrowItem *cast = [XWSettingArrowItem itemWithIcon:@"cast" title:@"播客" destVcClass:nil];
    XWSettingArrowItem *more = [XWSettingArrowItem itemWithIcon:@"more" title:@"更多" destVcClass:[XWAnyMoreViewController class]];
    
    group.items = @[video, music, movie, cast, more];
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

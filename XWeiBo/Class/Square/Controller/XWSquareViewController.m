//
//  XWSquareViewController.m
//  XWeiBo
//
//  Created by DP on 14/12/2.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWSquareViewController.h"
#import "XWSettingArrowItem.h"
#import "XWSettingLabelItem.h"
#import "XWSettingGroup.h"

#import "XWMessageManagementController.h"
#import "XWMusicSettingViewController.h"
#import "XWImageSettingsViewController.h"
#import "XWReadingSettingViewController.h"
#import "XWColorChoiceViewController.h"
#import "XWPinViewController.h"

#import "XWOAuthViewController.h"

#import "XWAboutViewController.h"
#import "MBProgressHUD.h"

#import "UIImageView+WebCache.h"


@interface XWSquareViewController ()

@property (nonatomic, strong) UIButton *logoutBtn;

@end

@implementation XWSquareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
    [self setupGroup3];
    
    [self addBottomLogoutBtn];

}

- (void)setupGroup0
{
    XWSettingGroup *group = [self addGroup];
    
    XWSettingArrowItem *hot = [XWSettingArrowItem itemWithIcon:@"hot_status" title:@"消息通知" destVcClass:[XWMessageManagementController class]];
    group.items = @[hot];
}

- (void)setupGroup1
{
    XWSettingGroup *group = [self addGroup];
    
    XWSettingArrowItem *gameCenter = [XWSettingArrowItem itemWithIcon:@"game_center" title:@"显示设置" destVcClass:[XWColorChoiceViewController class]];
    XWSettingArrowItem *near = [XWSettingArrowItem itemWithIcon:@"near" title:@"阅读设置" destVcClass:[XWReadingSettingViewController class]];
    XWSettingArrowItem *app = [XWSettingArrowItem itemWithIcon:@"app" title:@"音效设置" destVcClass:[XWMusicSettingViewController class]];

    group.items = @[gameCenter, near, app];
}

- (void)setupGroup2
{
    XWSettingGroup *group = [self addGroup];
    
    XWSettingArrowItem *video = [XWSettingArrowItem itemWithIcon:@"video" title:@"图片上传与保存" destVcClass:[XWImageSettingsViewController class]];
    XWSettingArrowItem *movie = [XWSettingArrowItem itemWithIcon:@"movie" title:@"关于XWeiBo" destVcClass:[XWAboutViewController class]];
    
    group.items = @[video, movie];
}

- (void)setupGroup3
{
    XWSettingGroup *group = [self addGroup];
    XWSettingLabelItem *video = [XWSettingLabelItem itemWithIcon:@"video" title:@"清除缓存" destVcClass:nil];
//    video.defaultText = @"6.20M";
    video.option = ^{
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"正在清理...";
        hud.dimBackground = YES;
        [hud hide:YES afterDelay:1.0];
        
        //停止所有下载
        [[SDWebImageManager sharedManager] cancelAll];
        //清除内存中的缓存
        [[SDWebImageManager sharedManager].imageCache clearMemory];

    };
    
    
    XWSettingArrowItem *pinSetting = [XWSettingArrowItem itemWithIcon:@"movie" title:@"密码锁定" destVcClass:[XWPinViewController class]];
    
    if ([XWUserDefaults objectForKey:kUserPin]) {
        pinSetting.subtitle = @"                               开启";
    } else {
        pinSetting.subtitle = @"                               关闭";

    }
    
    group.items = @[video, pinSetting];

}

- (void)addBottomLogoutBtn
{
    CGRect footerRect = CGRectZero;
    footerRect.size.height = 50;
    footerRect.size.width = self.tableView.bounds.size.width;
    
    UIView *footerView = [[UIView alloc] initWithFrame:footerRect];
    
    CGRect btnRect = CGRectMake(8, 10, self.tableView.bounds.size.width - 16, 40);
    
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
    XWOAuthViewController *oauthVC = [XWOAuthViewController new];
    
    [self.navigationController pushViewController:oauthVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view.window endEditing:YES];
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end

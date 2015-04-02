//
//  XWTabBarController.m
//  XWeiBo
//
//  Created by DP on 14/12/2.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWTabBarController.h"
#import "XWHomeTableViewController.h"
#import "XWSquareViewController.h"
#import "XWMeViewController.h"
#import "XWMoreViewController.h"
#import "XWNavigationController.h"
#import "UIImage+DP.h"
#import "XWTabBar.h"
#import "XWComposeViewController.h"

#import "UIColor+SLAddition.h"

#import "XWMentionsViewController.h"
#import "XWMessageTableViewController.h"

@interface XWTabBarController () <XWTabBarDelegate>

@property (nonatomic, weak) XWTabBar *customTabBar;

//Message页面的两个tableView
@property (nonatomic, strong) XWMessageTableViewController *commentsTableViewController;
@property (nonatomic, strong) XWMentionsViewController *mentionsTableViewController;

@end

@implementation XWTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTabbar];

    [self setupAllChildVC];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}

- (void)setupTabbar
{
    XWTabBar *customTabBar = [[XWTabBar alloc] init];
    customTabBar.frame = self.tabBar.bounds;
    customTabBar.delegate = self;
    [self.tabBar addSubview:customTabBar];
    self.customTabBar = customTabBar;
}

- (void)tabBar:(XWTabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to
{

    self.selectedIndex = to;

}

- (void)tabBarDidClickPlusButton:(XWTabBar *)tabBar
{
    XWComposeViewController *compose = [[XWComposeViewController alloc] init];
    XWNavigationController *nav = [[XWNavigationController alloc] initWithRootViewController:compose];
    [self presentViewController:nav animated:YES completion:nil];
}


- (void)setupAllChildVC
{
    XWHomeTableViewController *XWHome = [[XWHomeTableViewController alloc]init];
    [self setupChildViewController:XWHome title:@"首页" imageName:@"tabbar_home" selectedImageName:@"tabbar_home_selected"];
    
    XWMeViewController *XWMe = [[XWMeViewController alloc]init];
    [self setupChildViewController:XWMe title:@"我" imageName:@"tabbar_profile" selectedImageName:@"tabbar_profile_selected"];
    
    XWMessageTableViewController *message = [[XWMessageTableViewController alloc] init];
    [self setupChildViewController:message title:@"回复" imageName:@"tabbar_discover" selectedImageName:@"tabbar_discover_selected"];

    
    [self addMessageViewController];
}

- (void)addMessageViewController
{
    XWMentionsViewController *mentionVC = [[XWMentionsViewController alloc] init];
    
    self.mentionsTableViewController = mentionVC;
    
    [self setupChildViewController:self.mentionsTableViewController
                             title:@"@我"
                         imageName:@"tabbar_message_center"
                 selectedImageName:@"tabbar_message_center_selected"];

}

- (XWMessageTableViewController *)createCommentsTableView
{
    
    XWMessageTableViewController *messageVC = [[XWMessageTableViewController alloc] init];
    
    self.commentsTableViewController = messageVC;
    
    return self.commentsTableViewController;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//初始化一个VC
- (void)setupChildViewController:(UIViewController *)childVC title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    
    childVC.title = title;
    childVC.tabBarItem.image = [UIImage imageWithName:imageName];
    
    if (iOS7) {
        childVC.tabBarItem.selectedImage = [[UIImage imageWithName:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        childVC.tabBarItem.selectedImage = [UIImage imageWithName:selectedImageName];
    }
    
    XWNavigationController *nav = [[XWNavigationController alloc]initWithRootViewController:childVC];
    [self addChildViewController:nav];
    
    [self.customTabBar addTabBarButtonWithItem:childVC.tabBarItem];
}

@end

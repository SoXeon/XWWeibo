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

#import "XWStatusTool.h"
#import "XWUnreadParam.h"
#import "XWUnreadResult.h"

#import "YSLContainerViewController.h"

@interface XWTabBarController () <XWTabBarDelegate, YSLContainerViewControllerDelegate>

@property (nonatomic, weak) XWTabBar *customTabBar;

//Message页面的两个tableView
@property (nonatomic, strong) XWMessageTableViewController *commentsTableViewController;
@property (nonatomic, strong) XWMentionsViewController *mentionsTableViewController;

@property (nonatomic, strong) XWHomeTableViewController *homeVC;
@property (nonatomic, strong) XWMeViewController *meVC;
@property (nonatomic, strong) XWMessageTableViewController *messageVC;

@end

@implementation XWTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTabbar];

    [self setupAllChildVC];
    
    //定时器，定期请求未读数
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(getUnreadCount) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)getUnreadCount
{
    XWUnreadParam *unreadParam = [XWUnreadParam new];
    
    [XWStatusTool unreadCountWithParam:unreadParam success:^(XWUnreadResult *result) {

        //微博未读数
        if (result.status == 0) {
            self.homeVC.tabBarItem.badgeValue = nil;
        } else {
            self.homeVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", result.status];
        }
        
        //me
        if (result.follower == 0 ) {
            self.meVC.tabBarItem.badgeValue = nil;
        } else {
            self.meVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", result.follower];
        }
        
        //message
        if (result.totalMessageCount == 0) {
            self.messageVC.tabBarItem.badgeValue = nil;
        } else {
            self.messageVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", result.totalMessageCount];
        }
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = result.totalCount;

    } failure:^(NSError *error) {
        NSLog(@"erorrrni ");
    }];
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
    
    if (to == 0 && from == to) {
        [self.homeVC refreshContent:YES];
    } else if (to == 0) {
        [self.homeVC refreshContent:NO];
    }
    
    if (to == 1 && from == to) {
        [self.meVC refreshContent:YES];
    } else if(to == 1) {
        [self.meVC refreshContent:NO];
    }
    
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
    self.homeVC = XWHome;
    
    XWMeViewController *XWMe = [[XWMeViewController alloc]init];
    [self setupChildViewController:XWMe title:@"我" imageName:@"tabbar_profile" selectedImageName:@"tabbar_profile_selected"];
    self.meVC = XWMe;
    
    //TODO: 这里还需要另外一个控制器
    XWMessageTableViewController *message = [[XWMessageTableViewController alloc] init];
    [self setupChildViewController:message title:@"回复" imageName:@"tabbar_discover" selectedImageName:@"tabbar_discover_selected"];
    message.title = @"message";
    self.messageVC = message;
    
    XWMentionsViewController *mentionVC = [[XWMentionsViewController alloc] init];
    mentionVC.title = @"metions";
    self.mentionsTableViewController = mentionVC;
    
    UIViewController *revice = [[UIViewController alloc]init];
    revice.title = @"revice";
    revice.view.backgroundColor = [UIColor greenColor];
    
    UIViewController *containVC = [[UIViewController alloc]init];
    
    [self setupChildViewController:containVC
                             title:@"@我"
                         imageName:@"tabbar_message_center"
                 selectedImageName:@"tabbar_message_center_selected"];
    
    YSLContainerViewController *yslVC = [[YSLContainerViewController alloc] initWithControllers:@[self.messageVC, self.mentionsTableViewController, revice] topBarHeight:66 parentViewController:containVC];
    yslVC.delegate = self;
    yslVC.menuItemFont = [UIFont fontWithName:@"Futura-Medium" size:16];
    yslVC.menuItemTitleColor = [UIColor whiteColor];
    yslVC.menuItemSelectedTitleColor = [UIColor redColor];
    yslVC.menuIndicatorColor = [UIColor yellowColor];
    yslVC.menuBackGroudColor = [UIColor purpleColor];
    
    [containVC.view addSubview:yslVC.view];
    
//    [self addMessageViewController];
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

#pragma mark YSLContainer Delegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    [controller viewWillAppear:YES];
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

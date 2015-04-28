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
#import "XWComposeViewController.h"

#import "UIColor+SLAddition.h"

#import "XWMentionsViewController.h"
#import "XWMessageTableViewController.h"
#import "XWSendMessageTableViewController.h"

#import "XWStatusTool.h"
#import "XWUnreadParam.h"
#import "XWUnreadResult.h"

#import "YSLContainerViewController.h"

#import "YALFoldingTabBar.h"
#import "YALTabBarItem.h"
#import "YALAnimatingTabBarConstants.h"

#import "CBZSplashView.h"
#import "UIColor+HexString.h"
static NSString * const kTwitterColor = @"4099FF";


//XWTabBarDelegate

@interface XWTabBarController () < YSLContainerViewControllerDelegate, YALTabBarViewDelegate, YALTabBarViewDataSource>

@property (nonatomic, weak) YALFoldingTabBar *customTabBar;

//Message页面的两个tableView
@property (nonatomic, strong) XWMessageTableViewController *commentsTableViewController;
@property (nonatomic, strong) XWMentionsViewController *mentionsTableViewController;

@property (nonatomic, strong) XWHomeTableViewController *homeVC;
@property (nonatomic, strong) XWMeViewController *meVC;
@property (nonatomic, strong) XWMessageTableViewController *messageVC;
@property (nonatomic, strong) XWSendMessageTableViewController *sendMessageVC;
@property (nonatomic, strong) CBZSplashView *splashView;


@end

@implementation XWTabBarController

- (id)init
{
    self = [super init];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTabBar) name:kPopVC object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidenTabBar) name:kPushVC object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheme) name:themeChangeNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *icon = [UIImage imageNamed:@"snapchatIcon"];
    UIColor *color = [UIColor colorWithHexString:kTwitterColor];
    
    CBZSplashView *splashView = [CBZSplashView splashViewWithIcon:icon backgroundColor:color];
    
    splashView.animationDuration = 1.4;
    
    [self.view addSubview:splashView];
    
    self.splashView = splashView;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self setupTabbar];
        
        [self setupAllChildVC];

    });

    //定时器，定期请求未读数
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(getUnreadCount) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /* wait a beat before animating in */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.splashView startAnimation];
    });
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

    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBar.hidden = YES;
    
}

- (void)hidenTabBar
{
    [UIView animateWithDuration:0.35 animations:^{
        self.customTabBar.alpha = 0.0;
    }];
}

- (void)showTabBar
{
    [UIView animateWithDuration:0.35 animations:^{
        self.customTabBar.alpha = 1.0;
    }];

}

- (void)setupTabbar
{
    self.tabBar.backgroundColor = [UIColor clearColor];
    YALFoldingTabBar *customTabBar = [[YALFoldingTabBar alloc] initWithFrame:CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y, self.tabBar.frame.size.width, self.tabBar.frame.size.height) state:YALStateCollapsed];
    customTabBar.delegate = self;
    customTabBar.dataSource = self;
    customTabBar.tag = 22222;
    
    NSData *colorData = [XWUserDefaults objectForKey:XWUserThemeColor];
    UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];

    if (color) {
        customTabBar.tabBarColor = color;
    } else {
        customTabBar.tabBarColor =[UIColor colorWithRed:72.0/255.0 green:211.0/255.0 blue:178.0/255.0 alpha:1];
    }
    
    customTabBar.selectedTabBarItemIndex = 0;
    customTabBar.extraTabBarItemHeight = YALExtraTabBarItemsDefaultHeight;
    customTabBar.offsetForExtraTabBarItems = YALForExtraTabBarItemsDefaultOffset;
    [self.view addSubview:customTabBar];
    self.customTabBar = customTabBar;
}


- (void)changeTheme
{
    
    NSData *colorData = [XWUserDefaults objectForKey:XWUserThemeColor];
    UIColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];

    
    self.customTabBar.mainView.backgroundColor = color;
    self.customTabBar.extraLeftButton.backgroundColor = color;
    self.customTabBar.extraRightButton.backgroundColor = color;
}

//- (void)tabBarDidClickPlusButton:(XWTabBar *)tabBar
//{
//    XWComposeViewController *compose = [[XWComposeViewController alloc] init];
//    XWNavigationController *nav = [[XWNavigationController alloc] initWithRootViewController:compose];
//    [self presentViewController:nav animated:YES completion:nil];
//}


- (void)setupAllChildVC
{
    XWHomeTableViewController *XWHome = [[XWHomeTableViewController alloc]init];
    [self setupChildViewController:XWHome title:@"首页"];
    self.homeVC = XWHome;
    
    XWMeViewController *XWMe = [[XWMeViewController alloc]init];
    [self setupChildViewController:XWMe title:@"我"];
    self.meVC = XWMe;
    
    XWMentionsViewController *mentionVC = [[XWMentionsViewController alloc] init];
    mentionVC.title = @"metions";
    self.mentionsTableViewController = mentionVC;
    
    XWMessageTableViewController *message = [[XWMessageTableViewController alloc] init];
    message.title = @"message";
    self.messageVC = message;


    XWSendMessageTableViewController *recviceVC = [[XWSendMessageTableViewController alloc] init];
    recviceVC.title = @"revice";
    self.sendMessageVC = recviceVC;
    
    UIViewController *containVC = [[UIViewController alloc]init];
    
    [self setupChildViewController:containVC
                             title:@"消息"];
    
    
    //容器包含三个子viewController
    YSLContainerViewController *yslVC = [[YSLContainerViewController alloc] initWithControllers:@[self.messageVC, self.sendMessageVC, self.mentionsTableViewController] topBarHeight:66 parentViewController:containVC];
    yslVC.delegate = self;
    yslVC.menuItemFont = [UIFont fontWithName:@"Futura-Medium" size:16];
    yslVC.menuItemTitleColor = [UIColor whiteColor];
    yslVC.menuItemSelectedTitleColor = [UIColor redColor];
    yslVC.menuIndicatorColor = [UIColor yellowColor];
    yslVC.menuBackGroudColor = [UIColor purpleColor];
    
    [containVC.view addSubview:yslVC.view];

    
//    UIViewController *settingVC = [[UIViewController alloc] init];
//    [self setupChildViewController:settingVC title:@"settings"];
    
//    XWMoreViewController *more = [[XWMoreViewController alloc] init];
//    more.view.backgroundColor = [UIColor whiteColor];
//    [self setupChildViewController:more title:@"setting"];
    
    XWSquareViewController *quare = [[XWSquareViewController alloc] init];
    [self setupChildViewController:quare title:@"setting"];
    
}

//- (void)addMessageViewController
//{
//    XWMentionsViewController *mentionVC = [[XWMentionsViewController alloc] init];
//    
//    self.mentionsTableViewController = mentionVC;
//    
//    [self setupChildViewController:self.mentionsTableViewController
//                             title:@"@我"
//                         imageName:@"tabbar_message_center"
//                 selectedImageName:@"tabbar_message_center_selected"];
//
//}

//- (XWMessageTableViewController *)createCommentsTableView
//{
//    
//    XWMessageTableViewController *messageVC = [[XWMessageTableViewController alloc] init];
//    
//    self.commentsTableViewController = messageVC;
//    
//    return self.commentsTableViewController;
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark YALTabBarViewDelegate & DataSource
- (NSArray *)leftTabBarItemsInTabBarView:(YALFoldingTabBar *)tabBarView
{
    YALTabBarItem *homeItem = [[YALTabBarItem alloc] initWithItemImage:[UIImage imageNamed:@"nearby_icon"]
                                                         leftItemImage:nil
                                                        rightItemImage:[UIImage imageNamed:@"edit_icon"]];
    
    YALTabBarItem *meItem = [[YALTabBarItem alloc] initWithItemImage:[UIImage imageNamed:@"profile_icon"]
                                                       leftItemImage:nil
                                                      rightItemImage:nil];
    
    return @[homeItem, meItem];
}

- (NSArray *)rightTabBarItemsInTabBarView:(YALFoldingTabBar *)tabBarView
{
    YALTabBarItem *chatItem = [[YALTabBarItem alloc] initWithItemImage:[UIImage imageNamed:@"chats_icon"]
                                                         leftItemImage:nil
                                                        rightItemImage:nil];
    
    YALTabBarItem *settingItem = [[YALTabBarItem alloc] initWithItemImage:[UIImage imageNamed:@"settings_icon"]
                                                            leftItemImage:nil
                                                           rightItemImage:nil];
    
    return @[chatItem, settingItem];
}

- (UIImage *)centerImageInTabBarView:(YALFoldingTabBar *)tabBarView
{
    return [UIImage imageNamed:@"plus_icon"];
}

- (void)itemInTabBarViewPressed:(YALFoldingTabBar *)tabBarView atIndex:(NSUInteger)index
{
    self.selectedIndex = index;
}

- (void)extraRightItemDidPressedInTabBarView:(YALFoldingTabBar *)tabBarView
{
    if (tabBarView.selectedTabBarItemIndex == 0) {
        XWComposeViewController *compose = [[XWComposeViewController alloc] init];
        XWNavigationController *nav = [[XWNavigationController alloc] initWithRootViewController:compose];
        [self presentViewController:nav animated:YES completion:nil];

    }
    
}


#pragma mark YSLContainer Delegate ,模仿Path的时间显示
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    [controller viewWillAppear:YES];
}


//初始化一个VC
- (void)setupChildViewController:(UIViewController *)childVC title:(NSString *)title
{
    
    childVC.title = title;

    XWNavigationController *nav = [[XWNavigationController alloc]initWithRootViewController:childVC];
    [nav.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kLTFont size:18], NSFontAttributeName, nil]];
    [self addChildViewController:nav];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end

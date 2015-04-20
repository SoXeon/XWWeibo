//
//  XWNavigationController.m
//  XWeiBo
//
//  Created by DP on 14/12/2.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWNavigationController.h"
#import "UIBarButtonItem+DP.h"

@interface XWNavigationController () <UINavigationControllerDelegate>

@end


@implementation XWNavigationController

+ (void)initialize
{
    [self setupNavBarTheme];
    
    [self setupBarButtonItemTheme];
}


+ (void)setupNavBarTheme
{
    // 取出appearance对象
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    // 设置背景
    if (!iOS7) {
        [navBar setBackgroundImage:[UIImage imageWithName:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
    }
    
    // 设置标题属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[UITextAttributeTextColor] = XWNavigationBarTitleColor;

    textAttrs[UITextAttributeFont] = XWNavigationBarTitleFont;
        textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetMake(0, 0)];
    [navBar setTitleTextAttributes:textAttrs];
}

+ (void)setupBarButtonItemTheme
{
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    // 设置背景
    if (!iOS7) {
        [item setBackgroundImage:[UIImage imageWithName:@"navigationbar_button_background"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [item setBackgroundImage:[UIImage imageWithName:@"navigationbar_button_background_pushed"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        [item setBackgroundImage:[UIImage imageWithName:@"navigationbar_button_background_disable"] forState:UIControlStateDisabled barMetrics:UIBarMetricsDefault];
    }
    
    // 设置文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[UITextAttributeTextColor] = XWBarButtonTitleColor;
    textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetMake(0, 0)];
    textAttrs[UITextAttributeFont] = XWBarButtonTitleFont;
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateHighlighted];
    
    
    NSMutableDictionary *disableAttrs = [NSMutableDictionary dictionary];
    disableAttrs[UITextAttributeTextColor] = XWBarButtonTitleDisabledColor;
    disableAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetMake(0, 0)];
    [item setTitleTextAttributes:disableAttrs forState:UIControlStateDisabled];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kPushVC object:nil];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
     if (viewController != navigationController.viewControllers[0] && viewController.navigationItem.leftBarButtonItem == nil) {
         
         viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"navigationbar_back" highIcon:@"navigationbar_back_highlighted" target:self action: @selector(back)];
         
     }
    
}

/**
 *  返回
 */
- (void)back
{
    [self popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:kPopVC object:nil];
}

/**
 *  更多
 */


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    self.view.backgroundColor = XWColor(232, 232, 232);
    if (iOS7) {
        // 重新拥有滑动出栈的功能
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}

@end

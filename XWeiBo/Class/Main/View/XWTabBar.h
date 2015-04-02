//
//  XWTabBar.h
//  XWeiBo
//
//  Created by DP on 14/12/2.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XWTabBar;

@protocol XWTabBarDelegate <NSObject>

@optional
- (void)tabBar:(XWTabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to;
- (void)tabBarDidClickPlusButton:(XWTabBar *)tabBar;

@end

@interface XWTabBar : UIView
- (void)addTabBarButtonWithItem:(UITabBarItem *)item;
@property (nonatomic, weak) id<XWTabBarDelegate> delegate;
@end

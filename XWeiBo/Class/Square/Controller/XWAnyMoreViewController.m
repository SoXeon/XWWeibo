//
//  XWAnyMoreViewController.m
//  XWeiBo
//
//  Created by DP on 14/12/2.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWAnyMoreViewController.h"
#import "XWSettingArrowItem.h"
#import "XWSettingGroup.h"

@implementation XWAnyMoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    XWSettingGroup *group = [self addGroup];
    
    XWSettingArrowItem *shop = [XWSettingArrowItem itemWithIcon:@"shop" title:@"精选商品" destVcClass:nil];
    XWSettingArrowItem *lottery = [XWSettingArrowItem itemWithIcon:@"lottery" title:@"彩票" destVcClass:nil];
    XWSettingArrowItem *food = [XWSettingArrowItem itemWithIcon:@"food" title:@"美食" destVcClass:nil];
    XWSettingArrowItem *car = [XWSettingArrowItem itemWithIcon:@"car" title:@"汽车" destVcClass:nil];
    XWSettingArrowItem *tour = [XWSettingArrowItem itemWithIcon:@"tour" title:@"旅游" destVcClass:nil];
    XWSettingArrowItem *news = [XWSettingArrowItem itemWithIcon:@"news" title:@"新浪新闻" destVcClass:nil];
    XWSettingArrowItem *recommend = [XWSettingArrowItem itemWithIcon:@"recommend" title:@"官方推荐" destVcClass:nil];
    XWSettingArrowItem *read = [XWSettingArrowItem itemWithIcon:@"read" title:@"读书" destVcClass:nil];
    
    group.items = @[shop, lottery, food, car, tour, news, recommend, read];

}

@end

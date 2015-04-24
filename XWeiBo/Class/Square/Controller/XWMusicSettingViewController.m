//
//  XWMusicSettingViewController.m
//  XWeiBo
//
//  Created by DP on 15/4/24.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWMusicSettingViewController.h"
#import "XWSettingSwitchItem.h"
#import "XWSettingGroup.h"

@implementation XWMusicSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupGroup0];
    [self setupGroup1];

}

- (void)setupGroup0
{
    XWSettingGroup *group = [self addGroup];
    
    XWSettingSwitchItem *stopMusic = [XWSettingSwitchItem itemWithIcon:@"hot_status" title:@"全部静音"];
    group.items = @[stopMusic];

}

- (void)setupGroup1
{
    XWSettingGroup *group = [self addGroup];
    
    XWSettingSwitchItem *timeLineMusic = [XWSettingSwitchItem itemWithIcon:@"game_center" title:@"时间线刷新音效"];
    XWSettingSwitchItem *newMessageMusic = [XWSettingSwitchItem itemWithIcon:@"near" title:@"新消息提醒音效"];
    XWSettingSwitchItem *touchMusic = [XWSettingSwitchItem itemWithIcon:@"app" title:@"点击音效"];
    XWSettingSwitchItem *messageSendMusic = [XWSettingSwitchItem itemWithIcon:@"video" title:@"信息发送音效"];

    group.items = @[timeLineMusic, newMessageMusic, touchMusic, messageSendMusic];
}

@end

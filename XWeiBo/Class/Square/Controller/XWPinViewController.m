//
//  XWPinViewController.m
//  XWeiBo
//
//  Created by DP on 15/4/27.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWPinViewController.h"
#import "XWSettingGroup.h"
#import "XWSettingLabelItem.h"
#import "XWSettingArrowItem.h"

#import "XWPinDetailController.h"

@implementation XWPinViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupGroup0];
    [self setupGroup1];
}

- (void)setupGroup0
{
    XWSettingGroup *group = [self addGroup];
    
    //若没有开启密码，状态为另外一种 1.开启密码锁定 2.灰色不可点击
    
    XWSettingLabelItem *closePin = [XWSettingLabelItem itemWithTitle:@"关闭密码锁定"];
    XWSettingLabelItem *changePin = [XWSettingLabelItem itemWithTitle:@"更改密码"];
    group.items = @[closePin, changePin];
}

- (void)setupGroup1
{
    XWSettingGroup *group = [self addGroup];
    
    XWSettingArrowItem *needPin = [XWSettingArrowItem itemWithTitle:@"需要密码" destVcClass:[XWPinDetailController class]];
    needPin.subtitle = @"立即";
    
    group.items = @[needPin];
}

@end

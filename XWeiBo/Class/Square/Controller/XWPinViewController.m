//
//  XWPinViewController.m
//  XWeiBo
//
//  Created by DP on 15/4/27.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

/**
 *  具体逻辑
 *  1.分为设置密码和未设置密码两种状态
 *  2.初始化密码是要两次确定
 *  3.需要设置密码弹出时间
 *  4.密码存储在XWUserDefaults
 *  5.密码设置要两次，需要一致
 *  6.修改密码要先输入之前的密码
 *  7.这块逻辑就是烦，不是难
 */


#import "XWPinViewController.h"
#import "XWSettingGroup.h"
#import "XWSettingArrowItem.h"

#import "XWPinDetailController.h"
#import "XWSetPinViewController.h"

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
    
   NSString *userPin = [XWUserDefaults objectForKey:kUserPin];
    
    XWSettingArrowItem *closePin = [XWSettingArrowItem itemWithTitle:@"关闭密码锁定" destVcClass:[XWPinDetailController class]];
    XWSettingArrowItem *changePin = [XWSettingArrowItem itemWithTitle:@"更改密码"];

    
    if (userPin) {
        closePin.title = @"关闭密码锁定";
        closePin.destVcClass = [XWPinDetailController class];
    } else {
        closePin.title = @"开启密码锁定";
        closePin.destVcClass = [XWSetPinViewController class];
    }
    
        group.items = @[closePin, changePin];
}

- (void)setupGroup1
{
    XWSettingGroup *group = [self addGroup];
    
    XWSettingArrowItem *needPin = [XWSettingArrowItem itemWithTitle:@"需要密码" destVcClass:nil];
    needPin.subtitle = @"立即";
    
    group.items = @[needPin];
}

@end

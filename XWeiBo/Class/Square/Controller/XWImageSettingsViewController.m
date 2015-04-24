//
//  XWImageSettingsViewController.m
//  XWeiBo
//
//  Created by DP on 15/4/24.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWImageSettingsViewController.h"

#import "XWSettingSwitchItem.h"
#import "XWSettingGroup.h"
#import "XWSettingCheckGroup.h"
#import "XWSettingCheckItem.h"

@interface XWImageSettingsViewController()

@property (nonatomic, strong) XWSettingCheckGroup *group;

@end

@implementation XWImageSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupGroup0];
    [self setupGroup1];
}

- (void)setupGroup0
{
    self.group = [self addCheckGroup];
    
    XWSettingCheckItem *smartModel = [XWSettingCheckItem itemWithTitle:@"智能模式"];
    
    XWSettingCheckItem *highModel = [XWSettingCheckItem itemWithTitle:@"高质量图片(WiFi模式)"];
    XWSettingCheckItem *nomarlModel = [XWSettingCheckItem itemWithTitle:@"普通图片(2G或3G)"];
    
    self.group.items = @[smartModel, highModel, nomarlModel];
    
    int quality =  [XWUserDefaults integerForKey:XWUserImageQuality];
    
    self.group.checkedItem = [self.group.items objectAtIndex:quality];
    
}

- (void)setupGroup1
{
    XWSettingGroup *group = [self addGroup];

    XWSettingSwitchItem *uploadHighImage = [XWSettingSwitchItem itemWithTitle:@"在Wi-Fi环境下上传高质量图片"];
    XWSettingSwitchItem *saveImageAndVideo = [XWSettingSwitchItem itemWithTitle:@"保存原图和视频"];
    XWSettingSwitchItem *saveChangedImageAndVideo = [XWSettingSwitchItem itemWithTitle:@"保存处理过的图片和视频"];
    
    group.items = @[uploadHighImage, saveImageAndVideo, saveChangedImageAndVideo];
    
}


@end

//
//  XWMessageManagementController.m
//  XWeiBo
//
//  Created by DP on 15/4/24.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWMessageManagementController.h"
#import "XWSettingSwitchItem.h"
#import "XWSettingGroup.h"


@implementation XWMessageManagementController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupGroup0];
    [self setupGroup1];

}

- (void)setupGroup0
{
    XWSettingGroup *group = [self addGroup];
    
    XWSettingSwitchItem *messageNotification = [XWSettingSwitchItem itemWithIcon:@"hot_status" title:@"消息通知"];
    group.items = @[messageNotification];
    
}

- (void)setupGroup1
{
    XWSettingGroup *group = [self addGroup];
    
    XWSettingSwitchItem *newMetion = [XWSettingSwitchItem itemWithIcon:@"game_center" title:@"新提到"];
    XWSettingSwitchItem *newMessage = [XWSettingSwitchItem itemWithIcon:@"near" title:@"新评论"];
    XWSettingSwitchItem *newPrivateMessage = [XWSettingSwitchItem itemWithIcon:@"app" title:@"新私信"];
    XWSettingSwitchItem *newFollowers = [XWSettingSwitchItem itemWithIcon:@"video" title:@"新粉丝"];
    
    group.items = @[newMetion, newMessage, newPrivateMessage, newFollowers];
}

#pragma mark Setting FooterView
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}


-  (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UITextView *footerLabel = [[UITextView alloc] init];
        footerLabel.frame = CGRectMake(8, 0, tableView.frame.size.width - 15, 80);
        footerLabel.userInteractionEnabled = NO;
        footerLabel.backgroundColor = [UIColor clearColor];
        footerLabel.text = @"你可以通过设置XXXXX\n你可以通过设置XXXXX\n你可以通过设置XXXXX";
        footerLabel.font = kSourceFont;
        
        UIView *footerView = [UIView new];
        footerView.size = CGSizeMake(tableView.frame.size.width, 100);
        
        [footerView addSubview:footerLabel];
        
        return footerView;

    }
    
    return nil;
}
@end

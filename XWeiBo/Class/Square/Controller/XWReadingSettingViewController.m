//
//  XWReadingSettingViewController.m
//  XWeiBo
//
//  Created by DP on 15/4/24.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWReadingSettingViewController.h"
#import "XWSettingSwitchItem.h"
#import "XWSettingGroup.h"
#import "XWSettingCheckGroup.h"
#import "XWSettingCheckItem.h"
#import "XWSettingLabelItem.h"

#import "DKNightVersion.h"

@implementation XWReadingSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchChanged:) name:@"switchItemChanged" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)switchChanged:(NSNotification *)notification
{
    NSString *itemTitle = notification.userInfo[@"switchItemTitle"];
    
    if ([itemTitle isEqualToString:@"首页全屏阅读"]) {
        if ([XWUserDefaults objectForKey:@"首页全屏阅读"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"allScreenReading" object:nil];
        }
    }
}

- (void)setupGroup0
{
    XWSettingCheckGroup *group = [self addCheckGroup];
    
    XWSettingCheckItem *always = [XWSettingCheckItem itemWithTitle:@"总是"];
    
    XWSettingCheckItem *onlyWiFi = [XWSettingCheckItem itemWithTitle:@"仅使用Wi-Fi时"];
    
    group.items = @[always, onlyWiFi];
    
    int choice = [XWUserDefaults integerForKey:XWUserWuFengReading];
    
    group.checkedItem = [group.items objectAtIndex:choice];

}

- (void)setupGroup1
{
    XWSettingCheckGroup *group = [self addCheckGroup];
    
    XWSettingCheckItem *upRead = [XWSettingCheckItem itemWithTitle:@"顺序浏览"];
    XWSettingCheckItem *downRead = [XWSettingCheckItem itemWithTitle:@"逆序阅读"];
    
    group.items = @[upRead, downRead];
    
    int choice = [XWUserDefaults integerForKey:XWUserReadingDirection];
    
    group.checkedItem = [group.items objectAtIndex:choice];

}

- (void)setupGroup2
{
    XWSettingGroup *group = [self addGroup];
    
    XWSettingSwitchItem *fullScreenReading = [XWSettingSwitchItem itemWithTitle:@"首页全屏阅读"];
    
    XWSettingArrowItem *nightReadingModel = [XWSettingSwitchItem itemWithTitle:@"夜晚阅读模式"];
    //TODO:设置夜晚阅读模式时间端
    XWSettingLabelItem *timeSelectedModel = [XWSettingLabelItem itemWithIcon:@"video" title:@"清除缓存" destVcClass:nil];
    timeSelectedModel.defaultText = @"20:00~23:00";
    
    group.items = @[fullScreenReading, nightReadingModel, timeSelectedModel];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XWSettingGroup *group = self.groups[indexPath.section];
    XWSettingItem *item = group.items[indexPath.row];
    
    
    if ([item isKindOfClass:[XWSettingCheckItem class]]) {
        
        
        if (indexPath.section == 0) {
            XWSettingCheckGroup *checkGroup = (XWSettingCheckGroup *)group;
            checkGroup.checkedIndex = (int)indexPath.row;
            [XWUserDefaults setInteger:(int)indexPath.row forKey:XWUserWuFengReading];
            
        } else if (indexPath.section == 1) {
            XWSettingCheckGroup *checkGroup = (XWSettingCheckGroup *)group;
            checkGroup.checkedIndex = (int)indexPath.row;
            [XWUserDefaults setInteger:(int)indexPath.row forKey:XWUserReadingDirection];
            
        }
        
        [tableView reloadData];

    }
    
}

#pragma mark Setting FooterView && HeaderView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}


-  (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerLabel = [UILabel new];
    headerLabel.frame = CGRectMake(13, 0, self.tableView.width, 33);
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = kTextFont;
    
    switch (section) {
        case 0:
            headerLabel.text = @"无缝浏览设置";
            break;
        case 1:
            headerLabel.text = @"浏览顺序";
            break;
        case 2:
            headerLabel.text = @"沉浸模式";
            break;
        default:
            break;
    }
    
    UIView *headerView = [UIView new];
    headerView.size = CGSizeMake(self.tableView.width, 44);
    [headerView addSubview:headerLabel];
    self.tableView.contentInset = UIEdgeInsetsMake(77, 0, 0, 0);
    
    return headerView;
}
@end

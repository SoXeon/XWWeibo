//
//  XWSettingViewController.m
//  XWeiBo
//
//  Created by DP on 14/12/2.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWSettingViewController.h"
#import "XWSettingGroup.h"
#import "XWSettingCell.h"
#import "XWSettingArrowItem.h"
#import "XWSettingCheckItem.h"
#import "XWSettingCheckGroup.h"

@implementation XWSettingViewController

- (NSMutableArray *)groups
{
    if (_groups == nil) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

- (XWSettingGroup *)addGroup
{
    XWSettingGroup *group = [XWSettingGroup group];
    [self.groups addObject:group];
    return group;
}

- (XWSettingCheckGroup *)addCheckGroup
{
    XWSettingCheckGroup *group = [XWSettingCheckGroup group];
    [self.groups addObject:group];
    return group;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (id)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = XWColor(232, 232, 232);
    
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 6;
    
    UIView *footer = [[UIView alloc] init];
    footer.frame = CGRectMake(0, 0, 0, 1);
    
    if (iOS7) {
        self.tableView.contentInset = UIEdgeInsetsMake(6 - 33, 0, 0, 0);
    } else {
        self.tableView.contentInset = UIEdgeInsetsMake(6, 0, 0, 0);
    }
}

#pragma mark TableView datat Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    XWSettingGroup *group = self.groups[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XWSettingCell *cell = [XWSettingCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    XWSettingGroup *group = self.groups[indexPath.section];
    cell.item = group.items[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XWSettingGroup *group = self.groups[indexPath.section];
    XWSettingItem *item = group.items[indexPath.row];
    
    if (item.option) {
        item.option();
    }
    
    if ([item isKindOfClass:[XWSettingArrowItem class]]) {
        XWSettingArrowItem *arrowItem = (XWSettingArrowItem *)item;
        if (arrowItem.destVcClass) {
            UIViewController *destVC = [[arrowItem.destVcClass alloc] init];
            destVC.title = arrowItem.title;
            
            if (arrowItem.readyForDestVc) {
                arrowItem.readyForDestVc(arrowItem, destVC);
            }
            
            [self.navigationController pushViewController:destVC animated:YES];
        }
    }
    
    if ([item isKindOfClass:[XWSettingCheckItem class]]) {
        XWSettingCheckGroup *checkGroup = (XWSettingCheckGroup *)group;
        checkGroup.checkedIndex = (int)indexPath.row;
        [XWUserDefaults setInteger:(int)indexPath.row forKey:XWUserImageQuality];
        
        [tableView reloadData];
    }
}
@end

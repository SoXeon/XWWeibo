//
//  XWFriendshipListViewController.m
//  XWeiBo
//
//  Created by DP on 14/12/5.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWFriendshipListViewController.h"
#import "IWFriendshipCell.h"
#import "XWFriendshipParam.h"
#import "XWFriendshipResult.h"
#import "XWUserTool.h"
#import "XWUser.h"

#import "XWStatusListViewController.h"

@interface XWFriendshipListViewController()


@end

@implementation XWFriendshipListViewController


- (void)viewDidLoad
{
    _friendships = [NSMutableArray array];
    _param = [[XWFriendshipParam alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [super viewDidLoad];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (_result.total_number == _friendships.count || _result.next_cursor == 0) {
//        _footer.hidden = YES;
//    } else {
//        _footer.hidden = NO;
//    }
    return _friendships.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IWFriendshipCell *cell = [IWFriendshipCell cellWithTableView:tableView];
    
    cell.user = _friendships[indexPath.row];
    cell.delegate = self;
    
    cell.indexPath = indexPath;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [IWFriendshipCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark FriendshipCell Delegate
- (void)customCell:(IWFriendshipCell *)cell didTapButton:(UIButton *)button
{
    
    if (!cell.user.following) {
        
        [XWUserTool createFriendshipWithParam:@{ @"uid" : cell.user.idstr
                                                 }
                                      success:^(id JSON) {
                                                     
                                                 } failure:^(NSError *error) {
                                                     
                                                 }];
        [cell.followBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [cell.followBtn setTitle:@"已关注" forState:UIControlStateNormal];

        [cell.followBtn setImage:[UIImage imageWithName:cell.user.follow_me?@"userinfo_relationship_indicator_arrow":@"userinfo_relationship_indicator_tick_unfollow"] forState:UIControlStateNormal];
    }
    
    if (cell.user.following) {
        
        [XWUserTool destoryFriendshipWithParam:@{
                                                 
                                                 @"uid" : cell.user.idstr
                                                 
                                                 } success:^(id JSON) {
                                                     
                                                 } failure:^(NSError *error) {
                                                     
                                                 }];
        [cell.followBtn setTitleColor:XWColor(42, 135, 46) forState:UIControlStateNormal];
        [cell.followBtn setTitle:@"关注" forState:UIControlStateNormal];
        [cell.followBtn setImage:[UIImage imageWithName:@"userinfo_relationship_indicator_plus"] forState:UIControlStateNormal];
        
        
        
    }

}


@end

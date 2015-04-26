//
//  XWBaseStatusListViewController.m
//  XWeiBo
//
//  Created by DP on 14/12/4.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWBaseStatusListViewController.h"
#import "XWBaseStatusCell.h"
#import "XWStatusCellFrame.h"
#import "XWStatus.h"
#import "XWStatusCell.h"
#import "XWStatusTool.h"
#import "HttpTool.h"
@implementation XWBaseStatusListViewController


- (void)viewDidLoad
{
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = XWColor(232, 232, 232);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 5, 0);
    
    _statusFrames = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _statusFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XWBaseStatusCell *cell = [XWBaseStatusCell cellWithTableView:tableView];
    
    cell.cellFrame = _statusFrames[indexPath.row];
    
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_statusFrames[indexPath.row] cellHeight];
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}

#pragma mark SWTableViewCell Delegate

- (void)swipeableTableViewCell:(XWStatusCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            [cell hideUtilityButtonsAnimated:YES];

            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
            [_statusFrames removeObjectAtIndex:cellIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
            
            [HttpTool postWithpath:@"2/statuses/destroy.json" params:@{ @"id" :@(cell.cellFrame.status.ID)
                
            } success:^(id JSON) {
                
            } failure:^(NSError *error) {
                
            }];

        }
            
            break;
        default:
            break;
    }

}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}


@end

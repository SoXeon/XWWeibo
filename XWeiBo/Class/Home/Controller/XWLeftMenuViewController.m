//
//  XWLeftMenuViewController.m
//  XWeiBo
//
//  Created by DP on 15/4/29.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWLeftMenuViewController.h"
#import "XWHomeTableViewController.h"

@interface XWLeftMenuViewController()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *objects;

@end

@implementation XWLeftMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.objects = @[@{@"name":@"所有微博",@"image":@"IconHome"},
                     @{@"name":@"个人收藏",@"image":@"IconProfile"},
                     @{@"name":@"好友圈",@"image":@"IconCalendar"},
                     @{@"name":@"公共微博",@"image":@"IconSettings"}];
    
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 4) / 2.0f, self.view.frame.size.width, 54 * 4) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[XWHomeTableViewController new]]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"allWeiBo" object:nil];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 1:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[XWHomeTableViewController new]]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"personalCollection" object:nil];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 2:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[XWHomeTableViewController new]]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"friendsLoop" object:nil];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 3:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[XWHomeTableViewController new]]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pulicWeibo" object:nil];
            [self.sideMenuViewController hideMenuViewController];
            break;

        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    
    cell.textLabel.text = self.objects[indexPath.row][@"name"];
    cell.imageView.image = [UIImage imageNamed:self.objects[indexPath.row][@"image"]];
    
    return cell;
}

@end

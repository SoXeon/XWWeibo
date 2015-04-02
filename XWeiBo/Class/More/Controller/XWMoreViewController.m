//
//  XWMoreViewController.m
//  XWeiBo
//
//  Created by DP on 14/12/2.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWAccountsTableViewController.h"
#pragma mark 这个类只用在MoreController
@interface LogutBtn : UIButton
@end

@implementation LogutBtn
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat x = 10;
    CGFloat y = 0;
    CGFloat width = contentRect.size.width - 2 * x;
    CGFloat height = contentRect.size.height;
    return CGRectMake(x, y, width, height);
}
@end


#import "XWMoreViewController.h"
#import "UIImage+DP.h"
#import "XWGroupCell.h"

@interface XWMoreViewController ()
{
    NSArray *_data;
}
@end

@implementation XWMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildUI];
    
    [self loadPlist];
    
    [self buildTableView];
    
}

- (void)buildTableView
{
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = XWColor(232, 232, 232);
    
    // 2.设置tableView每组头部的高度
    self.tableView.sectionHeaderHeight = 15;
    self.tableView.sectionFooterHeight = 10;
    
    
    // 3.要在tableView底部添加一个按钮
    LogutBtn *logout = [LogutBtn buttonWithType:UIButtonTypeCustom];
    // 设置背景图片
    [logout setImage:[UIImage resizedImage:@"common_button_big_red.png"] forState:UIControlStateNormal];
    [logout setImage:[UIImage resizedImage:@"common_button_big_red_highlighted.png"] forState:UIControlStateHighlighted];
    // tableFooterView的宽度是不需要设置。默认就是整个tableView的宽度
    logout.bounds = CGRectMake(0, 0, 0, 44);
    
    // 4.设置按钮文字
    [logout setTitle:@"退出登录" forState:UIControlStateNormal];
    
    //    logout.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    self.tableView.tableFooterView = logout;
    
    // 增加底部额外的滚动区域
    //self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == _data.count - 1) {
        return 1;
    }
    return 10;
}

- (void)loadPlist
{
    // 1.获得路径
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"More" withExtension:@"plist"];
    
    // 2.读取数据
    _data = [NSArray arrayWithContentsOfURL:url];
}

- (void)buildUI
{
    // 1.设置标题
    self.view.backgroundColor = [UIColor whiteColor];
    // 2.设置右上角按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleBordered target:nil action:nil];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    // forIndexPath:indexPath 跟 storyboard配套使用的
    XWGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[XWGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        // 设置cell所在的tableView
        cell.myTableView = tableView;
    }
    
    // 1.取出这行对应的字典数据
    NSDictionary *dict = _data[indexPath.section][indexPath.row];
    
    // 2.设置文字
    cell.textLabel.text = dict[@"name"];
    
    // 3.设置cell的背景
    cell.indexPath = indexPath;
    
    // 4.设置cell的类型（设置右边显示什么东西）
    if (indexPath.section == 2) {
        cell.cellType = kCellTypeLabel;
        cell.rightLabel.text = indexPath.row?@"有图模式":@"经典主题";
            } else {
        cell.cellType = kCellTypeArrow;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        XWAccountsTableViewController *accounts = [[XWAccountsTableViewController alloc] init];
        [self.navigationController pushViewController:accounts animated:YES];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

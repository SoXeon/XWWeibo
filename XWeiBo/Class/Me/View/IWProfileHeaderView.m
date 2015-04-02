//
//  IWProfileHeaderView.m
//  ItcastWeibo
//
//  Created by mj on 14-1-12.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWProfileHeaderView.h"
#import "XWIconView.h"
#import "XWUser.h"
#import "IWNumberBtn.h"
#import "XWUserTool.h"
#import "XWUserParam.h"
#import "XWUser.h"
#import "IWIconView.h"
#import "XWFollowersViewController.h"
#import "XWFriendsViewController.h"
#import "XWStatusListViewController.h"

@interface IWProfileHeaderView()
/**
 *  详细资料
 */
@property (weak, nonatomic) IBOutlet IWIconView *iconView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *dividers;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet IWNumberBtn *statusCount;
@property (weak, nonatomic) IBOutlet IWNumberBtn *friendsCount;
@property (weak, nonatomic) IBOutlet IWNumberBtn *fansCount;
@property (weak, nonatomic) IBOutlet IWNumberBtn *likeCount;
@end

@implementation IWProfileHeaderView

+ (instancetype)header
{
    return [[NSBundle mainBundle] loadNibNamed:@"IWProfileHeaderView" owner:nil options:nil][0];
}

- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
    
    // 2.分隔线
    for (UIView *divider in _dividers) {
        CGRect frame = divider.frame;
        if (frame.size.width > 20) { // 横线
            frame.size.height = 0.1;
        } else { // 竖线
            frame.size.width = 0.1;
        }
        divider.alpha = 0.5;
        divider.frame = frame;
    }
    
    // 3.阴影
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0.5);
    self.layer.shadowOpacity = 0.7;
    
    // 4.默认值
    _statusCount.number = 0;
    _friendsCount.number = 0;
    _fansCount.number = 0;
    _likeCount.number = 0;
}

- (void)setParam:(XWUserParam *)param
{
    _param = param;
    
    
    [XWUserTool userWithParam:param success:^(XWUser *user) {
        
        // 3.1.设置头像
        [_iconView setUser:user iconType:IWIconTypeBig];
        // 3.2.设置数量
        _statusCount.number = user.statuses_count;
        _friendsCount.number = user.friends_count;
        _fansCount.number = user.followers_count;
        
        // 3.3.描述
        if (user.verified_reason.length) {
            _descLabel.text = [NSString stringWithFormat:@"新浪认证:%@", user.verified_reason];
        } else if (user.desc.length) {
            _descLabel.text = user.desc;
        } else {
            _descLabel.text = @"这个人很懒，什么也没写！";
        }
        
        // 3.4.昵称
        _nameLabel.text = user.name;
        CGFloat nameMaxW = self.frame.size.width - _nameLabel.frame.origin.x - 30;
        CGSize nameSize = [user.screenName sizeWithFont:_nameLabel.font constrainedToSize:CGSizeMake(nameMaxW, MAXFLOAT)];
        CGRect nameF = _nameLabel.frame;
        CGFloat oldW = nameF.size.width;
        nameF.size.width = nameSize.width;
        _nameLabel.frame = nameF;
        
        // 3.5.性别
        CGRect sexF = _sexView.frame;
        sexF.origin.x += nameSize.width - oldW;
        _sexView.frame = sexF;
    } failure:nil];
}

- (IBAction)statusClick {
    UITabBarController *root = (UITabBarController *)self.window.rootViewController;
    UINavigationController *nav = (UINavigationController *)root.selectedViewController;
    XWStatusListViewController *vc = [[XWStatusListViewController alloc] init];
    [nav pushViewController:vc animated:YES];
}

- (IBAction)friendsClick {
    UITabBarController *root = (UITabBarController *)self.window.rootViewController;
    UINavigationController *nav = (UINavigationController *)root.selectedViewController;
    XWFriendsViewController *vc = [[XWFriendsViewController alloc] init];
    [nav pushViewController:vc animated:YES];
}

- (IBAction)fansClick {
    UITabBarController *root = (UITabBarController *)self.window.rootViewController;
    UINavigationController *nav = (UINavigationController *)root.selectedViewController;
    XWFollowersViewController *vc = [[XWFollowersViewController alloc] init];
    [nav pushViewController:vc animated:YES];
}

@end

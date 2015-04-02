//
//  IWFriendshipCell.m
//  ItcastWeibo
//
//  Created by mj on 14-1-15.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWFriendshipCell.h"
#import "IWIconView.h"
#import "XWUser.h"
#import "XWStatus.h"

@interface IWFriendshipCell()
{
    UIView *_divider;
}
@property (weak, nonatomic) IBOutlet IWIconView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end

@implementation IWFriendshipCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"friendship";
    IWFriendshipCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"IWFriendshipCell" owner:nil options:nil][0];
    }
    return cell;
}

- (void)awakeFromNib
{
    // 1.按钮背景
    [_followBtn setBackgroundImage:[UIImage resizedImage:@"userinfo_relationship_button_background"] forState:UIControlStateNormal];
    [_followBtn setBackgroundImage:[UIImage resizedImage:@"userinfo_relationship_button_highlighted"] forState:UIControlStateHighlighted];
    
    // 2.背景
    bg.backgroundColor = [UIColor whiteColor];
    selectedBg.backgroundColor = [UIColor grayColor];
    
    // 3.分隔线
    _divider = [[UIView alloc] init];
    _divider.backgroundColor = [UIColor lightGrayColor];
    _divider.frame = CGRectMake(0, 0, self.contentView.frame.size.width, 0.5);
    [self.contentView addSubview:_divider];
}

- (void)setUser:(XWUser *)user
{
    _user = user;
    
    // 0.头像
    [_iconView setUser:user iconType:IWIconTypeDefault];
    
    // 1.昵称
    _nameLabel.text = user.name;
    
    // 2.最近的微博
    _statusLabel.text = user.status.text;
    
    // 3.按钮
    if (user.following) { // 已经关注
        [_followBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_followBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [_followBtn setImage:[UIImage imageWithName:user.follow_me?@"userinfo_relationship_indicator_arrow":@"userinfo_relationship_indicator_tick_unfollow"] forState:UIControlStateNormal];
    } else { // 未关注
        [_followBtn setTitleColor:XWColor(42, 135, 46) forState:UIControlStateNormal];
        [_followBtn setTitle:@"关注" forState:UIControlStateNormal];
        [_followBtn setImage:[UIImage imageWithName:@"userinfo_relationship_indicator_plus"] forState:UIControlStateNormal];
    }
}
- (IBAction)changeFriendshipAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(customCell:didTapButton:)])
    {
        [self.delegate performSelector:@selector(customCell:didTapButton:) withObject:self withObject:self.followBtn];
    }
}

+ (CGFloat)cellHeight
{
    return 65;
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    
    _divider.hidden = indexPath.row == 0;
}

@end

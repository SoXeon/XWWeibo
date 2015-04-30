//
//  XWProfileHeaderView.m
//  XWeiBo
//
//  Created by DP on 15/4/25.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWProfileHeaderView.h"
#import "IWNumberBtn.h"
#import "IWNumberBtn.h"
#import "XWUser.h"
#import "XWUserTool.h"
#import "XWUserParam.h"
#import "XWStatusListViewController.h"
#import "HttpTool.h"

@interface XWProfileHeaderView()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) UIButton *statusCount;
@property (nonatomic, strong) UIButton *friendsCount;
@property (nonatomic, strong) UIButton *fansCount;


@end

@implementation XWProfileHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        [self configureBar];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_nameLabel sizeToFit];
}


- (void)setParam:(XWUserParam *)param
{
    _param = param;
    
    [XWUserTool userWithParam:param success:^(XWUser *user) {
        
        [HttpTool downloadImage:user.avatar_large place:[UIImage imageNamed:@"avatar_default_small.png"] imageView:_profileImageView];
        // 3.2.设置数量
        [_statusCount setTitle:[NSString stringWithFormat:@"%d",user.statuses_count] forState:UIControlStateNormal];
        [_statusCount setImage:[UIImage imageNamed:@"cast"] forState:UIControlStateNormal];
        
        [_friendsCount setTitle:[NSString stringWithFormat:@"%d", user.friends_count] forState:UIControlStateNormal];
        [_friendsCount setImage:[UIImage imageNamed:@"hot_status"] forState:UIControlStateNormal];
        
        [_fansCount setTitle:[NSString stringWithFormat:@"%d", user.followers_count] forState:UIControlStateNormal];
        [_fansCount setImage:[UIImage imageNamed:@"near"] forState:UIControlStateNormal];
         
        
        // 3.4.昵称
        _nameLabel.text = user.name;
        _nameLabel.font = kTextFont;
        [_nameLabel sizeToFit];
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)configureBar
{
    self.maximumBarHeight = 200.0;
    self.minimumBarHeight = 65.0;
    self.backgroundColor = [UIColor greenColor];
    
    self.nameLabel = [UILabel new];
    self.nameLabel.font = kTextFont;
    self.nameLabel.textColor =[UIColor whiteColor];
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *initialNameLabelLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] init];
    initialNameLabelLayoutAttributes.size = [_nameLabel sizeThatFits:CGSizeZero];
    initialNameLabelLayoutAttributes.center = CGPointMake(self.frame.size.width*0.5 - 50, self.maximumBarHeight-50.0);
    [_nameLabel addLayoutAttributes:initialNameLabelLayoutAttributes forProgress:0.0];
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *midwayNameLabelLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] initWithExistingLayoutAttributes:initialNameLabelLayoutAttributes];
    midwayNameLabelLayoutAttributes.center = CGPointMake(self.frame.size.width*0.5 - 50, (self.maximumBarHeight-self.minimumBarHeight)*0.4+self.minimumBarHeight-50.0);
    [_nameLabel addLayoutAttributes:midwayNameLabelLayoutAttributes forProgress:0.6];
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *finalNameLabelLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] initWithExistingLayoutAttributes:midwayNameLabelLayoutAttributes];
    finalNameLabelLayoutAttributes.center = CGPointMake(self.frame.size.width*0.5 - 50, self.minimumBarHeight-25.0);
    [_nameLabel addLayoutAttributes:finalNameLabelLayoutAttributes forProgress:1.0];
    
    [self addSubview:self.nameLabel];
    
    CGSize btnSize = CGSizeMake(150, 30);
    
    self.statusCount = [[UIButton alloc] init];
    [self.statusCount addTarget:self action:@selector(openDetailStatus) forControlEvents:UIControlEventTouchUpInside];
    BLKFlexibleHeightBarSubviewLayoutAttributes *statusBtnStartLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] init];
    statusBtnStartLayoutAttributes.size = btnSize;
    statusBtnStartLayoutAttributes.center = CGPointMake(self.frame.size.width * 0.15, 185);
    [self.statusCount addLayoutAttributes:statusBtnStartLayoutAttributes forProgress:0.0];
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *statusBtnMidLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] initWithExistingLayoutAttributes:statusBtnStartLayoutAttributes];
    statusBtnMidLayoutAttributes.center = CGPointMake(self.frame.size.width * 0.15, 150);
    statusBtnMidLayoutAttributes.alpha = 0.0;
    [self.statusCount addLayoutAttributes:statusBtnMidLayoutAttributes forProgress:0.3];
    
    [self addSubview:self.statusCount];
    
    self.friendsCount = [[UIButton alloc] init];
    BLKFlexibleHeightBarSubviewLayoutAttributes *friendBtnStartLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] init];
    friendBtnStartLayoutAttributes.size = btnSize;
    friendBtnStartLayoutAttributes.center = CGPointMake(self.frame.size.width * 0.5, 185);
    [self.friendsCount addLayoutAttributes:friendBtnStartLayoutAttributes forProgress:0.0];
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *friendBtnMidLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] initWithExistingLayoutAttributes:friendBtnStartLayoutAttributes];
    friendBtnMidLayoutAttributes.center = CGPointMake(self.frame.size.width * 0.5, 150);
    friendBtnMidLayoutAttributes.alpha = 0.0;
    [self.friendsCount addLayoutAttributes:friendBtnMidLayoutAttributes forProgress:0.3];
    [self addSubview:self.friendsCount];
    
    self.fansCount = [[UIButton alloc] init];
    BLKFlexibleHeightBarSubviewLayoutAttributes *fanBtnStartLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] init];
    fanBtnStartLayoutAttributes.size = btnSize;
    fanBtnStartLayoutAttributes.center = CGPointMake(self.frame.size.width * 0.85, 185);
    [self.fansCount addLayoutAttributes:fanBtnStartLayoutAttributes forProgress:0.0];
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *fanBtnMidLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] initWithExistingLayoutAttributes:fanBtnStartLayoutAttributes];
    fanBtnMidLayoutAttributes.center = CGPointMake(self.frame.size.width * 0.85, 150);
    fanBtnMidLayoutAttributes.alpha = 0.0;
    [self.fansCount addLayoutAttributes:fanBtnMidLayoutAttributes forProgress:0.3];
    [self addSubview:self.fansCount];
    
    self.profileImageView = [UIImageView new];
    self.profileImageView.contentMode = UIViewContentModeScaleToFill;
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.cornerRadius = 35.0;
    self.profileImageView.layer.borderWidth = 2.0;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *initialProfileImageViewLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] init];
    initialProfileImageViewLayoutAttributes.size = CGSizeMake(70.0, 70.0);
    initialProfileImageViewLayoutAttributes.center = CGPointMake(self.frame.size.width*0.5, self.maximumBarHeight-110.0);
    [_profileImageView addLayoutAttributes:initialProfileImageViewLayoutAttributes forProgress:0.0];
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *midwayProfileImageViewLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] initWithExistingLayoutAttributes:initialProfileImageViewLayoutAttributes];
    midwayProfileImageViewLayoutAttributes.center = CGPointMake(self.frame.size.width*0.5, (self.maximumBarHeight-self.minimumBarHeight)*0.8+self.minimumBarHeight-110.0);
    [_profileImageView addLayoutAttributes:midwayProfileImageViewLayoutAttributes forProgress:0.2];
    
    BLKFlexibleHeightBarSubviewLayoutAttributes *finalProfileImageViewLayoutAttributes = [[BLKFlexibleHeightBarSubviewLayoutAttributes alloc] initWithExistingLayoutAttributes:midwayProfileImageViewLayoutAttributes];
    finalProfileImageViewLayoutAttributes.center = CGPointMake(self.frame.size.width*0.5, (self.maximumBarHeight-self.minimumBarHeight)*0.64+self.minimumBarHeight-110.0);
    finalProfileImageViewLayoutAttributes.transform = CGAffineTransformMakeScale(0.5, 0.5);
    finalProfileImageViewLayoutAttributes.alpha = 0.0;
    [_profileImageView addLayoutAttributes:finalProfileImageViewLayoutAttributes forProgress:0.5];
    
    
    [self addSubview:self.profileImageView];
    
}

- (void)openDetailStatus
{
    UITabBarController *root = (UITabBarController *)self.window.rootViewController;
    UINavigationController *nav = (UINavigationController *)root.selectedViewController;
    XWStatusListViewController *vc = [[XWStatusListViewController alloc] init];
    [nav pushViewController:vc animated:YES];
}

@end

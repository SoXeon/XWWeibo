//
//  XWIconView.m
//  XWeiBo
//
//  Created by DP on 14/12/3.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWIconView.h"
#import "XWUser.h"
#import "HttpTool.h"

/*
 1.图片尺寸
 */
/** 中等头像宽高 */
const int XWIconWH = 50;
/** 小头像宽高 */
const int XWIconSmallWH = 34;
/** 大头像宽高 */
const int XWIconBigWH = 85;
/** 认证图标宽高 */
const int XWVerifiedWH = 18;
/** 会员图标宽高 */
const int XWMBWH = 14;


@interface XWIconView()
{
    UIImageView *_icon; // 头像图片
    UIImageView *_vertify; // 认证图标
    
    NSString *_placehoder; // 占位图片
}
@end

@implementation XWIconView

// 任何UIView的init方法内部都会调用initWithFrame:方法
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup
{
    // 1.用户头像图片
    _icon = [[UIImageView alloc] init];
    [self addSubview:_icon];
    
    // 2.右下角的认证图标
    _vertify = [[UIImageView alloc] init];
    _vertify.bounds = CGRectMake(0, 0, XWVerifiedWH, XWVerifiedWH);
    [self addSubview:_vertify];
}

#pragma mark 同时设置头像的用户和类型
- (void)setUser:(XWUser *)user type:(IconType)type
{
    self.type = type;
    self.user = user;
}

#pragma mark 设置模型数据

- (void)setUser:(XWUser *)user
{
    _user = user;
    
    [HttpTool downloadImage:user.profileImageUrl place:[UIImage imageNamed:_placehoder] imageView:_icon];
    
    //设置认证图标
    NSString *verifiedIcon = nil;
    switch (user.verifiedType) {
        case kVerifiedTypeNone: // 没有认证认证
            _vertify.hidden = YES;
            break;
        case kVerifiedTypeDaren: // 微博达人
            verifiedIcon = @"avatar_grassroot.png";
            break;
        case kVerifiedTypePersonal: // 个人
            verifiedIcon = @"avatar_vip.png";
            break;
        default: // 企业认证
            verifiedIcon = @"avatar_enterprise_vip.png";
            break;
    }
        _vertify.hidden = NO;
        _vertify.image = [UIImage imageNamed:verifiedIcon];
    
}

- (void)setType:(IconType)type
{
    _type = type;
    
    // 1.判断类型
    CGSize iconSize;
    switch (type) {
        case kIconTypeSmall: // 小图标
            iconSize = CGSizeMake(kIconSmallW, kIconSmallH);
            _placehoder = @"avatar_default_small.png";
            
            break;
            
        case kIconTypeDefault: // 中图标
            iconSize = CGSizeMake(kIconDefaultW, kIconDefaultH);
            _placehoder = @"avatar_default.png";
            
            break;
            
        case kIconTypeBig: // 大图标
            iconSize = CGSizeMake(kIconBigW, kIconBigH);
            _placehoder = @"avatar_default_big.png";
            
            break;
    }
    
    // 2.设置frame
    _icon.frame = (CGRect){CGPointZero, iconSize};
    _vertify.bounds = CGRectMake(0, 0, kVertifyW, kVertifyH);
    _vertify.center = CGPointMake(iconSize.width, iconSize.height);
    
    // 3.自己的宽高
    CGFloat width = iconSize.width + kVertifyW * 0.5;
    CGFloat height = iconSize.height + kVertifyH * 0.5;
    self.bounds = CGRectMake(0, 0, width, height);
}

+ (CGSize)iconSizeWithType:(IconType)type
{
    CGSize iconSize;
    switch (type) {
        case kIconTypeSmall: // 小图标
            iconSize = CGSizeMake(kIconSmallW, kIconSmallH);
            break;
            
        case kIconTypeDefault: // 中图标
            iconSize = CGSizeMake(kIconDefaultW, kIconDefaultH);
            break;
            
        case kIconTypeBig: // 大图标
            iconSize = CGSizeMake(kIconBigW, kIconBigH);
            break;
    }
    CGFloat width = iconSize.width + kVertifyW * 0.5;
    CGFloat height = iconSize.height + kVertifyH * 0.5;
    return CGSizeMake(width, height);
}

@end

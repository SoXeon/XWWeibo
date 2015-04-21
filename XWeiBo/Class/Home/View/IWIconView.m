//
//  IWIconView.m
//  ItcastWeibo
//
//  Created by mj on 14-1-11.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWIconView.h"
#import "XWUser.h"
#import "UIImageView+DP.h"

/*
 1.图片尺寸
 */
/** 中等头像宽高 */
const int IWIconWH = 50;
/** 小头像宽高 */
const int IWIconSmallWH = 34;
/** 大头像宽高 */
const int IWIconBigWH = 85;
/** 认证图标宽高 */
const int IWVerifiedWH = 18;
/** 会员图标宽高 */
const int IWMBWH = 14;


@interface IWIconView()
{
    UIImageView *_imageView; // 头像
    NSString *_imagePlaceholder;
    UIImageView *_verifiedView; // 认证
}

@end

@implementation IWIconView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
    
    if (_user) {
        [self setUser:_user iconType:_iconType];
    }
}

- (void)setup
{
    _imageView = [[UIImageView alloc] init];
    [self addSubview:_imageView];
    
    _verifiedView = [[UIImageView alloc] init];
    _verifiedView.bounds = CGRectMake(0, 0, IWVerifiedWH, IWVerifiedWH);
    [self addSubview:_verifiedView];
}

- (void)setIconType:(IWIconType)iconType
{
    _iconType = iconType;
    
    CGFloat iconWH;
    switch (iconType) {
        case IWIconTypeDefault:
            iconWH = IWIconWH;
            _imagePlaceholder = @"avatar_default.png";
            [_imageView setImageWithURL:_user.avatar_large place:[UIImage imageWithName:_imagePlaceholder]];
            break;
        case IWIconTypeSmall:
            iconWH = IWIconSmallWH;
            _imagePlaceholder = @"avatar_default_small.png";
            [_imageView setImageWithURL:_user.profileImageUrl place:[UIImage imageWithName:_imagePlaceholder]];
            break;
        case IWIconTypeBig:
            iconWH = IWIconBigWH;
            _imagePlaceholder = @"avatar_default_big.png";
            [_imageView setImageWithURL:_user.avatar_hd place:[UIImage imageWithName:_imagePlaceholder]];
            _imageView.layer.shadowColor = [UIColor grayColor].CGColor;
            _imageView.layer.shadowOffset = CGSizeMake(1, 1);
            _imageView.layer.shadowOpacity = 0.7;
            break;
    }
    
    _imageView.frame = CGRectMake(0, 0, iconWH, iconWH);
    _imageView.layer.cornerRadius = _imageView.frame.size.width / 2;
    _imageView.clipsToBounds = YES;
    _imageView.layer.borderWidth = 2.0f;
    _imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _verifiedView.center = CGPointMake(iconWH - 2, iconWH - 2);
    
    CGRect frame = self.frame;
    frame.size = CGSizeMake(CGRectGetMaxX(_verifiedView.frame), CGRectGetMaxY(_verifiedView.frame));
    [super setFrame:frame];
}

- (void)setUser:(XWUser *)user
{
    _user = user;
    
    // 认证
    NSString *imageName = nil;
    
//    if (user.verified_type != -1) {
//        switch (user.verified_type) {
//            case kVerifiedTypeNone:
//                _verifiedView.hidden = YES;
//                return;
//                
//            case kVerifiedTypeDaren:
//                imageName = @"avatar_grassroot.png";
//                break;
//                
//            case kVerifiedTypePersonal:
//                imageName = @"avatar_vip.png";
//                break;
//                
//            default:
//                imageName = @"avatar_enterprise_vip.png";
//                break;
//        }
//
//    }
//    
//    _verifiedView.hidden = NO;
//    _verifiedView.image = [UIImage imageWithName:imageName];
}

- (void)setUser:(XWUser *)user iconType:(IWIconType)iconType
{
    self.user = user;
    self.iconType = iconType;
}

- (void)setFrame:(CGRect)frame
{
    frame.size = self.frame.size;
    [super setFrame:frame];
}

- (void)setBounds:(CGRect)bounds
{
    bounds.size = self.bounds.size;
    [super setBounds:bounds];
}

#pragma mark 返回头像的宽高
+ (CGSize)sizeWithIconType:(IWIconType)iconType
{
    CGFloat iconWH = 0;
    switch (iconType) {
        case IWIconTypeDefault:
            iconWH = IWIconWH;
            break;
        case IWIconTypeSmall:
            iconWH = IWIconSmallWH;
            break;
        case IWIconTypeBig:
            iconWH = IWIconBigWH;
            break;
    }
    iconWH += IWVerifiedWH * 0.5;
    return CGSizeMake(iconWH, iconWH);
}
@end
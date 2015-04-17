//
//  XWIconView.h
//  XWeiBo
//
//  Created by DP on 14/12/3.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    kIconTypeSmall,
    kIconTypeDefault,
    kIconTypeBig
} IconType;

@class XWUser;
@interface XWIconView : UIView

@property (nonatomic, strong) XWUser *user;
@property (nonatomic, assign) IconType type;
@property (nonatomic, strong) UIImageView *icon; // 头像图片


- (void)setUser:(XWUser *)user type:(IconType)type;

+ (CGSize)iconSizeWithType:(IconType)type;

@end

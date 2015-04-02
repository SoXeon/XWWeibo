//
//  IWIconView.h
//  ItcastWeibo
//
//  Created by mj on 14-1-11.
//  Copyright (c) 2014年 itcast. All rights reserved.
//  头像

#import <UIKit/UIKit.h>
@class XWUser;

typedef enum {
    IWIconTypeDefault = 0,
    IWIconTypeSmall,
    IWIconTypeBig
} IWIconType;

@interface IWIconView : UIView

@property (nonatomic, strong) XWUser *user;
@property (nonatomic, assign) IWIconType iconType;


- (void)setUser:(XWUser *)user iconType:(IWIconType)iconType;

+ (CGSize)sizeWithIconType:(IWIconType)iconType;
@end
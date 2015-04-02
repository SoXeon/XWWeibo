//
//  IWProfileHeaderView.h
//  ItcastWeibo
//
//  Created by mj on 14-1-12.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XWUserParam;
@interface IWProfileHeaderView : UIView
+ (instancetype)header;

@property (nonatomic, strong) XWUserParam *param;
@end

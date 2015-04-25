//
//  XWProfileHeaderView.h
//  XWeiBo
//
//  Created by DP on 15/4/25.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "BLKFlexibleHeightBar.h"
@class IWNumberBtn;

@interface XWProfileHeaderView : BLKFlexibleHeightBar

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) IWNumberBtn *allStatusBtn;
@property (nonatomic, strong) IWNumberBtn *followersBtn;
@property (nonatomic, strong) IWNumberBtn *friendsBtn;

@end

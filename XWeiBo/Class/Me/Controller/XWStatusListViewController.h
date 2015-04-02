//
//  XWStatusListViewController.h
//  XWeiBo
//
//  Created by DP on 14/12/5.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWBaseStatusListViewController.h"
#import "XWSingleStatusParam.h"
#import "XWStatusResult.h"

@interface XWStatusListViewController : XWBaseStatusListViewController

@property (nonatomic, strong) XWSingleStatusParam *param;
@property (nonatomic, strong) XWStatusResult *result;

@end

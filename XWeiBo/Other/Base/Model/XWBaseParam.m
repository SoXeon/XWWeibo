//
//  XWBaseParam.m
//  XWeiBo
//
//  Created by DP on 14/12/4.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWBaseParam.h"
#import "XWAccountTool.h"
#import "XWAccount.h"

@implementation XWBaseParam
- (id)init
{
    if (self = [super init]) {
        _access_token = [XWAccountTool sharedXWAccountTool].currentAccount.accessToken;
    }
    return self;
}
@end

//
//  XWSingleStatusParam.m
//  XWeiBo
//
//  Created by DP on 14/12/4.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWSingleStatusParam.h"
#import "XWAccountTool.h"
#import "XWAccount.h"
@implementation XWSingleStatusParam

- (id)init
{
    if (self = [super init]) {
        _uid = [XWAccountTool sharedXWAccountTool].currentAccount.uid;
    }
    return self;
}
@end

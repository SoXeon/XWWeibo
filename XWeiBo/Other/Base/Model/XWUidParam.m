//
//  XWUidParam.m
//  XWeiBo
//
//  Created by DP on 14/12/4.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWUidParam.h"
#import "XWAccount.h"
#import "XWAccountTool.h"

@implementation XWUidParam
- (id)init
{
    if (self = [super init]) {
        _uid = [XWAccountTool sharedXWAccountTool].currentAccount.uid;
    }
    return self;
}
@end

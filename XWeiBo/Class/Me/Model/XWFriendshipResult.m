//
//  XWFriendshipResult.m
//  XWeiBo
//
//  Created by DP on 14/12/4.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWFriendshipResult.h"
#import "XWUser.h"
@implementation XWFriendshipResult
- (NSDictionary *)arrayModelClasses
{
    return @{@"users" :[XWUser class]};
}
@end

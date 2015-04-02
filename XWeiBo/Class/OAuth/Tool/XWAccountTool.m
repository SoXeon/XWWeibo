//
//  XWAccountTool.m
//  XWeiBo
//
//  Created by DP on 14/12/2.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWAccountTool.h"

#define kFile   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"account.data"]

@implementation XWAccountTool

single_implementation(XWAccountTool)

- (id)init
{
    if (self = [super init]) {
        _currentAccount = [NSKeyedUnarchiver unarchiveObjectWithFile:kFile];
    }
    
    return  self;
}

- (void)saveAccount:(XWAccount *)account
{
    _currentAccount = account;
    [NSKeyedArchiver archiveRootObject:account toFile:kFile];
}

@end

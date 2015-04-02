//
//  XWStatusResult.m
//  XWeiBo
//
//  Created by DP on 14/12/4.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWStatusResult.h"
#import "XWStatus.h"

@implementation XWStatusResult

- (NSDictionary *)arrayModelClasses
{
    return @{@"statuses" : [XWStatus class]};
}

@end

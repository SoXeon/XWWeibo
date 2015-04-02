//
//  XWOwnComment.m
//  XWeiBo
//
//  Created by DP on 15/2/16.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import "XWOwnComment.h"

@implementation XWOwnComment

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super initWithDict:dict];
    if (self) {
       self.status = [[XWStatus alloc] initWithDict:dict[@"status"]];
        
        self.commentsID = [dict[@"id"] longLongValue];
    }
    return self;
}


@end

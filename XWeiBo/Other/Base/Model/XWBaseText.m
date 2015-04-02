//
//  XWBaseText.m
//  XWeiBo
//
//  Created by DP on 14/12/3.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWBaseText.h"
#import "XWUser.h"

@implementation XWBaseText

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super initWithDict:dict]) {
        self.text = dict[@"text"];
        self.user = [[XWUser alloc] initWithDict:dict[@"user"]];
    }
    return self;
}

@end

//
//  XWUser.m
//  XWeiBo
//
//  Created by DP on 14/12/3.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWUser.h"

@implementation XWUser

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super initWithDict:dict]) {
        self.screenName = dict[@"screen_name"];
        self.profileImageUrl = dict[@"profile_image_url"];
        self.avatar_hd = dict[@"avatar_hd"];
        self.avatar_large = dict[@"avatar_large"];
        self.verified = [dict[@"verified"] boolValue];
        self.verifiedType = [dict[@"verified_type"] intValue];
        self.mbrank = [dict[@"mbrank"] intValue];
        self.mbtype = [dict[@"mbtype"] intValue];
        self.desc = dict[@"desc"];
    }
    return self;
}

#warning 个人简介无法获取，但是其他内容都可以获取
- (NSDictionary *)replaceKeys
{
    return @{@"desc" : @"description"};
}

@end

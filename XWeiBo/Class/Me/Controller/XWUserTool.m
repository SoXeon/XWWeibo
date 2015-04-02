//
//  XWUserTool.m
//  XWeiBo
//
//  Created by DP on 14/12/4.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWUserTool.h"
#import "XWUserParam.h"
#import "XWUser.h"
#import "XWFriendshipParam.h"
#import "XWFriendshipResult.h"

@implementation XWUserTool

+ (void)userWithParam:(XWUserParam *)param success:(UserSuccess)success failure:(HttpFailureBlock)failure
{
    [self getWithPath:@"2/users/show.json" param:param success:success failure:failure resultClass:[XWUser class]];
}

+ (void)friendsWithParam:(XWFriendshipParam *)param success:(FriendshipSuccess)success failure:(HttpFailureBlock)failure
{
    [self getWithPath:@"2/friendships/friends.json" param:param success:success failure:failure resultClass:[XWFriendshipResult class]];
}

+ (void)followersWithParam:(XWFriendshipParam *)param success:(FriendshipSuccess)success failure:(HttpFailureBlock)failure
{
    [self getWithPath:@"2/friendships/followers.json" param:param success:success failure:failure resultClass:[XWFriendshipResult class]];
}

+ (void)createFriendshipWithParam:(NSDictionary *)param success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    [HttpTool postWithpath:@"2/friendships/create.json" params:param success:^(id JSON) {
        
    } failure:^(NSError *error) {
        
    }];
}

+ (void)destoryFriendshipWithParam:(NSDictionary *)param success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    [HttpTool postWithpath:@"2/friendships/destroy.json" params:param success:^(id JSON)
    {
        
    } failure:^(NSError *error) {
        
    }];

}

@end

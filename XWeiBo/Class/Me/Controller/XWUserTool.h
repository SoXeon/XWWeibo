//
//  XWUserTool.h
//  XWeiBo
//
//  Created by DP on 14/12/4.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWBaseTool.h"

@class XWUserParam, XWUser;
@class XWFriendshipParam, XWFriendshipResult;

typedef void (^FriendshipSuccess)(XWFriendshipResult *result);

typedef void (^UserSuccess)(XWUser *user);


@interface XWUserTool : XWBaseTool

+ (void)userWithParam:(XWUserParam *)param success:(UserSuccess)success failure:(HttpFailureBlock)failure;

+ (void)friendsWithParam:(XWFriendshipParam *)param success:(FriendshipSuccess)success failure:(HttpFailureBlock)failure;
+ (void)followersWithParam:(XWFriendshipParam *)param success:(FriendshipSuccess)success failure:(HttpFailureBlock)failure;

//关注别人
+ (void)createFriendshipWithParam:(NSDictionary *)param success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;

//取消关注
+ (void)destoryFriendshipWithParam:(NSDictionary *)param success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;

@end

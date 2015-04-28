//
//  XWStatusTool.m
//  XWeiBo
//
//  Created by DP on 14/12/3.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWStatusTool.h"
#import "HttpTool.h"
#import "XWAccountTool.h"
#import "XWStatus.h"
#import "XWComment.h"
#import "XWOwnComment.h"

#import "XWStatusParam.h"
#import "XWStatusResult.h"
#import "XWUnreadParam.h"
#import "XWUnreadResult.h"
#import "XWUpdateParam.h"
#import "XWUploadParam.h"
#import "XWStatus.h"
#import "XWSingleStatusParam.h"
#import "MJExtension.h"

@implementation XWStatusTool
+ (void)statusesWithSinceId:(long long)sinceId
                      maxId:(long long)maxId
                    success:(StatusSuccessBlock)success
                    failure:(StatusFailureBlock)failure
{
    [HttpTool getWithpath:@"2/statuses/home_timeline.json" params:@{
                                                                    @"count" : @20,
                                                                    @"since_id" : @(sinceId),
                                                                    @"max_id" : @(maxId)
                                                                    } success:^(id JSON) {
                                                                        if (success == nil) return;
                                                                        
                                                                        NSMutableArray *statuses = [NSMutableArray array];
                                                                        
                                                                        // 解析json对象
                                                                        NSArray *array = JSON[@"statuses"];
                                                                        for (NSDictionary *dict in array) {
                                                                            XWStatus *s = [[XWStatus alloc] initWithDict:dict];
                                                                            [statuses addObject:s];
                                                                        }
                                                                        
                                                                        // 回调block
                                                                        success(statuses);
                                                                    } failure:^(NSError *error) {
                                                                        if (failure == nil) return;
                                                                        
                                                                        failure(error);
                                                                    }];
}

+ (void)publicStatusesWithSinceId:(long long)sinceId
                            maxId:(long long)maxId
                          success:(StatusSuccessBlock)success
                          failure:(StatusFailureBlock)failure
{
    [HttpTool getWithpath:@"2/statuses/public_timeline.json" params:@{
                                                                      @"count" : @20,
                                                                      @"since_id" : @(sinceId),
                                                                      @"max_id" : @(maxId)

                                                                      } success:^(id JSON) {
                                                                          if (success == nil) {
                                                                              return;
                                                                          }
                                                                          NSMutableArray *statuses = [NSMutableArray array];

                                                                          NSArray *array = JSON[@"statuses"];
                                                                          
                                                                          for (NSDictionary *dict in array) {
                                                                              XWStatus *s = [[XWStatus alloc] initWithDict:dict];
                                                                              [statuses addObject:s];
                                                                          }
                                                                          
                                                                          success(statuses);
                                                                      } failure:^(NSError *error) {
                                                                          if (failure == nil) {
                                                                              return;
                                                                          }
                                                                          
                                                                          failure(error);
                                                                      }];
}

+ (void)repeatCommentsWithStatusID:(long long)statusID
                        commentsID:(long long)commentsID
                    commentContent:(NSString *)commentContent
                           success:(HttpSuccessBlock)success
                           failure:(HttpFailureBlock)failure
{
    [HttpTool postWithpath:@"2/comments/reply.json" params:@{
                                                             @"cid" : @(commentsID),
                                                             @"id" : @(statusID),
                                                             @"comment" : commentContent
                                                             } success:^(id JSON) {
                                                                 
                                                                 if (success == nil) return;
                                        
                                                                 success(JSON);
                                                             } failure:^(NSError *error) {
                                                                 if (failure == nil) return;
                                                                 
                                                                 failure(error);

                                                             }];
}


+ (void)fetchUserImagesWithUID:(long long)UID
                      WithPage:(NSUInteger)page
                       Success:(HttpSuccessBlock)success
                       failure:(HttpFailureBlock)failure
{
    [HttpTool getWithpath:@"2/place/users/photos.json"
                   params:@{
                            @"uid" : @(UID)
                           }success:^(id JSON) {
                                                                     
                        if (success == nil) {
                                        return;
                        }
                                                                     
                                                                     if (success) {
                                                                         success(JSON);
                                                                     }
                                                                     
                                                                 } failure:^(NSError *error) {
                                                                     failure(error);
                                                                 }];
}

+ (void)ownCommentsWithSinceId:(long long)sinceId
                         maxId:(long long)maxId
                       success:(OwnCommentsSuccessBlock)success
                       failure:(OwnCommentsFailureBloack)failure
{
    [HttpTool getWithpath:@"2/comments/to_me.json"
                   params:@{
                                @"count" : @20,
                                @"since_id" : @(sinceId),
                                @"max_id" : @(maxId)
                            }  success:^(id JSON) {
                                
                                if (success == nil) return;
                                
                                NSMutableArray *ownComments = [NSMutableArray array];
                                
                                // 解析json对象
                                NSArray *array = JSON[@"comments"];
                                
                                
                                for (NSDictionary *dict in array) {
                                    
                                    XWOwnComment *s = [[XWOwnComment alloc] initWithDict:dict];
                                    [ownComments addObject:s];
                                }
                             
                                success(ownComments);


    } failure:^(NSError *error) {
        if (failure == nil) return;
        
        failure(error);
    }];
}

+ (void)sendCommentsHistorySince:(long long)sinceId
                           maxId:(long long)maxId
                         success:(OwnCommentsSuccessBlock)success
                         failure:(OwnCommentsFailureBloack)failure
{
    [HttpTool getWithpath:@"2/comments/by_me.json"
                   params:@{
                            @"count" : @20,
                            @"since_id" : @(sinceId),
                            @"max_id" : @(maxId)
                            }  success:^(id JSON) {
                                
                                if (success == nil) return;
                                
                                NSMutableArray *ownComments = [NSMutableArray array];
                                
                                // 解析json对象
                                NSArray *array = JSON[@"comments"];
                                
                                
                                for (NSDictionary *dict in array) {
                                    
                                    XWOwnComment *s = [[XWOwnComment alloc] initWithDict:dict];
                                    [ownComments addObject:s];
                                }
                                
                                success(ownComments);
                                
                                
                            } failure:^(NSError *error) {
                                if (failure == nil) return;
                                
                                failure(error);
                            }];

}

+ (void)metionsWithSinceId:(long long)sinceId
                     maxId:(long long)maxId
                   success:(StatusSuccessBlock)success
                   failure:(StatusFailureBlock)failure
{
    [HttpTool getWithpath:@"2/statuses/mentions.json"
                   params:@{
                            @"count" : @30,
                            @"since_id" : @(sinceId),
                            @"max_id" : @(maxId)
                           }
                  success:^(id JSON) {
                                        if (success == nil) return;
                      
                                        NSMutableArray *statuses = [NSMutableArray array];
                                                                        
                         // 解析json对象
                        NSArray *array = JSON[@"statuses"];
                        for (NSDictionary *dict in array) {
                            XWStatus *s = [[XWStatus alloc] initWithDict:dict];
                            [statuses addObject:s];
                        }
                        // 回调block
                        success(statuses);
                 } failure:^(NSError *error) {
                                            if (failure == nil) return;
                                            failure(error);
    }];

}

+ (void)fetchLongURLWithShortURL:(NSString *)shortURL
                         success:(HttpSuccessBlock)success
                         failure:(HttpFailureBlock)failure
{
    [HttpTool getWithpath:@"2/short_url/expand.json" params:@{@"url_short":shortURL} success:^(id JSON) {
        if (success) {
            
            
            success(JSON);
        }
    } failure:^(NSError *error) {
        if (failure == nil) {
            return;
        }
        failure(error);
    }];
}

+ (void)everyUserStatusesWithParams:(NSDictionary *)param success:(StatusSuccessBlock)success failure:(HttpFailureBlock)failure
{
    
    [HttpTool getWithpath:@"2/statuses/user_timeline.json"params:param success:^(id JSON) {
        // 解析json对象
        
        if (success == nil) return;
        
        NSMutableArray *statuses = [NSMutableArray array];
        NSArray *array = JSON[@"statuses"];
        
        for (NSDictionary *dict in array) {
            XWStatus *s = [[XWStatus alloc] initWithDict:dict];
            [statuses addObject:s];
        }
        
        // 回调block
        success(statuses);

    } failure:^(NSError *error) {
     
    }];
}

+ (void)fetchTagAboutUserWithSuccess:(HttpSuccessBlock)success
                             failure:(HttpFailureBlock)failure
{
    [HttpTool getWithpath:@"2/tags/suggestions.json" params:nil success:^(id JSON) {
        
        if (success) {
            success(JSON);
        }
        
    } failure:^(NSError *error) {
        
    }];
}

+ (void)fetchFriendGroupWithSuccess:(HttpSuccessBlock)success
                            failure:(HttpFailureBlock)failure
{
    [HttpTool getWithpath:@"2/friendships/groups.json" params:nil success:^(id JSON) {
        
        if (success) {
            success(JSON);
        }
        
    } failure:^(NSError *error) {
        
    }];
}

+ (void)commentsWithSinceId:(long long)sinceId maxId:(long long)maxId statusId:(long long)statusId success:(CommentsSuccessBlock)success failure:(CommentsFailureBlock)failure
{
    [HttpTool getWithpath:@"2/comments/show.json" params:@{
                                                           @"id" : @(statusId),
                                                           @"since_id" : @(sinceId),
                                                           @"max_id" : @(maxId),
                                                           @"count" : @20
                                                           } success:^(id JSON) {
                                                               if (success == nil) return;
                                                               
                                                               // JSON数组（装着所有的评论）
                                                               NSArray *array = JSON[@"comments"];
                                                               
                                                               NSMutableArray *comments = [NSMutableArray array];
                                                               
                                                               for (NSDictionary *dict in array) {
                                                                   XWComment *c = [[XWComment alloc] initWithDict:dict];
                                                                   [comments addObject:c];
                                                               }
                                                               
                                                               success(comments, [JSON[@"total_number"] intValue], [JSON[@"next_cursor"] longLongValue]);
                                                               
                                                           } failure:^(NSError *error) {
                                                               if (failure == nil) return;
                                                               
                                                               failure(error);
                                                           }];
}

+ (void)repostsWithSinceId:(long long)sinceId maxId:(long long)maxId statusId:(long long)statusId success:(RepostsSuccessBlock)success failure:(RepostsFailureBlock)failure
{
    [HttpTool getWithpath:@"2/statuses/repost_timeline.json" params:@{
                                                                      @"id" : @(statusId),
                                                                      @"since_id" : @(sinceId),
                                                                      @"max_id" : @(maxId),
                                                                      @"count" : @20
                                                                      } success:^(id JSON) {
                                                                          if (success == nil) return;
                                                                          
                                                                          NSArray *array = JSON[@"reposts"];
                                                                          
                                                                          NSMutableArray *reposts = [NSMutableArray array];
                                                                          
                                                                          for (NSDictionary *dict in array) {
                                                                              XWStatus *r = [[XWStatus alloc] initWithDict:dict];
                                                                              [reposts addObject:r];
                                                                          }
                                                                          
                                                                          success(reposts, [JSON[@"total_number"] intValue], [JSON[@"next_cursor"] longLongValue]);
                                                                      } failure:^(NSError *error) {
                                                                          if (failure == nil) return;
                                                                          
                                                                          failure(error);
                                                                      }];
}

+ (void)statusWithId:(long long)ID success:(SingleStatusSuccessBlock)success failure:(SingleStatusFailureBlock)failure
{
    [HttpTool getWithpath:@"2/statuses/show.json" params:@{
                                                           @"id" : @(ID),
                                                           } success:^(id JSON) {
                                                               if (success == nil) return;
                                                               
                                                               XWStatus *s = [[XWStatus alloc] initWithDict:JSON];
                                                               
                                                               success(s);
                                                               
                                                           } failure:^(NSError *error) {
                                                               if (failure == nil) return;
                                                               
                                                               failure(error);
                                                           }];
}


+ (void)userStatusesWithParam:(XWSingleStatusParam *)param success:(StatusesSuccess)success failure:(HttpFailureBlock)failure
{
    [self getWithPath:@"2/statuses/user_timeline.json" param:param success:success failure:failure resultClass:[XWStatusResult class]];
}

+ (void)unreadCountWithParam:(XWUnreadParam *)param success:(UnreadSuccess)success failure:(HttpFailureBlock)failure
{
    [self getWithPath:@"2/remind/unread_count.json" param:param success:success failure:failure resultClass:[XWUnreadResult class]];
}

+ (void)updateWithParam:(XWUpdateParam *)param success:(UpdateSuccess)success failure:(HttpFailureBlock)failure
{
    [self postWithPath:@"2/statuses/update.json" param:param success:success failure:failure resultClass:[XWStatus class]];
}

+ (void)uploadWithParam:(XWUploadParam *)param success:(UploadSuccess)success failure:(HttpFailureBlock)failure
{
    [self postWithURL:@"https://upload.api.weibo.com/2/statuses/upload.json" param:param success:success failure:failure resultClass:[XWStatus class]];
}

@end

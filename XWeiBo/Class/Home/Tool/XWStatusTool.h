//
//  XWStatusTool.h
//  XWeiBo
//
//  Created by DP on 14/12/3.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XWBaseTool.h"

@class XWStatusParam, XWStatusResult, XWUnreadParam, XWUnreadResult;
@class XWUpdateParam, XWUploadParam;
@class XWSingleStatusParam;
@class XWOwnComment;

@class XWStatus;
// statues装的都是Status对象
typedef void (^StatusSuccessBlock)(NSArray *statues);
typedef void (^StatusFailureBlock)(NSError *error);

typedef void (^CommentsSuccessBlock)(NSArray *comments, int totalNumber, long long nextCursor);
typedef void (^CommentsFailureBlock)(NSError *error);

typedef void (^RepostsSuccessBlock)(NSArray *reposts, int totoalNumber, long long nextCursor);
typedef void (^RepostsFailureBlock)(NSError *error);

typedef void (^SingleStatusSuccessBlock)(XWStatus *status);
typedef void (^SingleStatusFailureBlock)(NSError *error);

typedef void (^StatusesSuccess)(XWStatusResult *result);
typedef void (^UnreadSuccess)(XWUnreadResult *result);
typedef void (^UpdateSuccess)(XWStatus *status);
typedef void (^UploadSuccess)(XWStatus *status);

typedef void (^OwnCommentsSuccessBlock)(NSArray *ownComments);
typedef void (^OwnCommentsFailureBloack)(NSError *error);

@interface XWStatusTool : XWBaseTool
// 抓取微博数据
+ (void)statusesWithSinceId:(long long)sinceId
                      maxId:(long long)maxId
                    success:(StatusSuccessBlock)success
                    failure:(StatusFailureBlock)failure;

// 获取公共微博数据
+ (void)publicStatusesWithSinceId:(long long)sinceId
                            maxId:(long long)maxId
                          success:(StatusSuccessBlock)success
                          failure:(StatusFailureBlock)failure;

// 获取好友圈的微博数据
+ (void)fetchFriendsLoopWithSinceID:(long long)sinceId
                              maxId:(long long)maxId
                            success:(StatusSuccessBlock)success
                            failure:(StatusFailureBlock)failure;

// 抓取@我的微博
+ (void)metionsWithSinceId:(long long)sinceId
                     maxId:(long long)maxId
                   success:(StatusSuccessBlock)success
                   failure:(StatusFailureBlock)failure;

// 抓取接收到的评论
+ (void)ownCommentsWithSinceId:(long long)sinceId
                      maxId:(long long)maxId
                    success:(OwnCommentsSuccessBlock)success
                    failure:(OwnCommentsFailureBloack)failure;

// 获取发售的评论
+ (void)sendCommentsHistorySince:(long long)sinceId
                           maxId:(long long)maxId
                         success:(OwnCommentsSuccessBlock)success
                         failure:(OwnCommentsFailureBloack)failure;

// 回复收到的评论
+ (void)repeatCommentsWithStatusID:(long long)statusID
                        commentsID:(long long)commentsID
                    commentContent:(NSString *)commentContent
                           success:(HttpSuccessBlock)success
                           failure:(HttpFailureBlock)failure;

// 获取用户Images
+ (void)fetchUserImagesWithUID:(long long)UID
                      WithPage:(NSUInteger)page
                        Success:(HttpSuccessBlock)success
                        failure:(HttpFailureBlock)failure;


// 抓取某条微博的评论数据
+ (void)commentsWithSinceId:(long long)sinceId
                      maxId:(long long)maxId
                   statusId:(long long)statusId
                    success:(CommentsSuccessBlock)success
                    failure:(CommentsFailureBlock)failure;

// 抓取某条微博的转发数据
+ (void)repostsWithSinceId:(long long)sinceId
                     maxId:(long long)maxId
                  statusId:(long long)statusId
                   success:(RepostsSuccessBlock)success
                   failure:(RepostsFailureBlock)failure;

// 抓取单条微博数据
+ (void)statusWithId:(long long)ID
             success:(SingleStatusSuccessBlock)success
             failure:(SingleStatusFailureBlock)failure;

/** 更新一条文字微博 */
+ (void)updateWithParam:(XWUpdateParam *)param
                success:(UpdateSuccess)success
                failure:(HttpFailureBlock)failure;

/** 更新一条文字+图片微博 */
+ (void)uploadWithParam:(XWUploadParam *)param
                success:(UploadSuccess)success
                failure:(HttpFailureBlock)failure;

/** 获得某个用户的发布微博 */
+ (void)userStatusesWithParam:(XWSingleStatusParam *)param
                      success:(StatusesSuccess)success
                      failure:(HttpFailureBlock)failure;

/* 获取相关用户的微博信息，这里API只能用于当前登录用户和给此App授权的用户，否则返回error*/
+ (void)everyUserStatusesWithParams:(NSDictionary *)param
                            success:(StatusSuccessBlock)success
                            failure:(HttpFailureBlock)failure;

/*获取用户提醒数字*/
+ (void)unreadCountWithParam:(XWUnreadParam *)param
                     success:(UnreadSuccess)success
                     failure:(HttpFailureBlock)failure;
/**
 *  获取用户标签
 *
 *  @param success 返回tag
 *  @param failure errorInfo
 */
+ (void)fetchTagAboutUserWithSuccess:(HttpSuccessBlock)success
                             failure:(HttpFailureBlock)failure;

/**
 *  获取好友分组
 *
 *  @param success 分组信息
 *  @param failure errorInfo
 */
+ (void)fetchFriendGroupWithSuccess:(HttpSuccessBlock)success
                            failure:(HttpFailureBlock)failure;


/**
 *  短链接转长链接
 *
 *  @param shortURL 短连接URL
 *  @param success  链接类型
 *  @param failure  errorInfo
 */
+ (void)fetchLongURLWithShortURL:(NSString *)shortURL
                         success:(HttpSuccessBlock)success
                         failure:(HttpFailureBlock)failure;

/**
 *  获取用户收藏
 *
 *  @param success 收藏Weibo信息
 *  @param failure errorInfo
 */
+ (void)fetchUserFavoritesSuccess:(StatusSuccessBlock)success
                          failure:(StatusFailureBlock)failure;
@end

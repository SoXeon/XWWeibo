//
//  XWStatus.h
//  XWeiBo
//
//  Created by DP on 14/12/3.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWBaseText.h"

@interface XWStatus : XWBaseText <NSCoding>

@property (nonatomic, strong) NSArray *picUrls; // 微博配图
@property (nonatomic, strong) XWStatus *retweetedStatus; // 被转发的微博
@property (nonatomic, assign) int repostsCount; // 转发数
@property (nonatomic, assign) int commentsCount; // 评论数
@property (nonatomic, assign) int attitudesCount; // 表态数(被赞)
@property (nonatomic, copy) NSString *source; // 微博来源

@property (nonatomic, strong) NSArray *picIDs;

@end

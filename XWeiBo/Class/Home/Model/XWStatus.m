//
//  XWStatus.m
//  XWeiBo
//
//  Created by DP on 14/12/3.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWStatus.h"

@implementation XWStatus

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super initWithDict:dict]) {
        self.picUrls = dict[@"pic_urls"];
        
        self.picIDs = dict[@"pic_ids"];
        
        NSDictionary *retweet = dict[@"retweeted_status"];
        if (retweet) {
            self.retweetedStatus = [[XWStatus alloc] initWithDict:retweet];
        }
        self.source = dict[@"source"];
        
        self.repostsCount = [dict[@"reposts_count"] intValue];
        self.commentsCount = [dict[@"comments_count"] intValue];
        self.attitudesCount = [dict[@"attitudes_count"] intValue];
    }
    return self;
}

- (void)setSource:(NSString *)source
{
    if ([source rangeOfString:@"<a href="].length > 0) {
        int start = (int)[source rangeOfString:@">"].location + 1;
        int end = (int)[source rangeOfString:@"</a>"].location;
        
        source = [source substringWithRange:NSMakeRange(start, end - start)];
    }
    _source = [NSString stringWithFormat:@"来自%@", source];
}

//- (void)encodeWithCoder:(NSCoder *)aCoder
//{
//    [aCoder encodeObject:self.picUrls forKey:@"pic_urls"];
//    [aCoder encodeObject:self.picIDs forKey:@"pic_ids"];
//    [aCoder encodeObject:self.retweetedStatus forKey:@"retweetedStatus"];
//    [aCoder encodeObject:@(self.repostsCount) forKey:@"respostsCount"];
//    [aCoder encodeObject:@(self.commentsCount) forKey:@"commentsCount"];
//    [aCoder encodeObject:@(self.attitudesCount) forKey:@"attitudesCount"];
//    [aCoder encodeObject:self.source forKey:@"source"];
//}
//
//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    if (self = [super init]) {
//        self.picUrls  = [aDecoder decodeObjectForKey:@"pic_urls"];
//        self.picIDs = [aDecoder decodeObjectForKey:@"pic_ids"];
//        self.retweetedStatus = [aDecoder decodeObjectForKey:@"retweetedStatus"];
//        self.repostsCount = [[aDecoder decodeObjectForKey:@"retweetedStatus"] intValue];
//        self.commentsCount = [[aDecoder decodeObjectForKey:@"commentsCount"] intValue];
//        self.attitudesCount = [[aDecoder decodeObjectForKey:@"attitudesCount"] intValue];
//        self.source = [aDecoder decodeObjectForKey:@"source"];
//    }
//    return self;
//}

@end

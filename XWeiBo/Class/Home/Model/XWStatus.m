//
//  XWStatus.m
//  XWeiBo
//
//  Created by DP on 14/12/3.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWStatus.h"
#import "XWUser.h"

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

@end

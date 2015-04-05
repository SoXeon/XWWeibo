//
//  XWUnreadResult.m
//  XWeiBo
//
//  Created by DP on 14/12/4.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWUnreadResult.h"

@implementation XWUnreadResult

- (int)totalCount
{
    return self.totalMessageCount + self.status + self.follower;
}

- (int)totalMessageCount
{
    return self.cmt + self.dm + self.mention_status + self.mention_cmt;
}

@end

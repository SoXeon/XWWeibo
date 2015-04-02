//
//  XWPageResult.h
//  XWeiBo
//
//  Created by DP on 14/12/4.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWBaseResult.h"

@interface XWPageResult : XWBaseResult

@property (nonatomic, assign) long long previous_cursor;
@property (nonatomic, assign) long long next_cursor;
@property (nonatomic, assign) long long total_number;
@end

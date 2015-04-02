//
//  XWFriendshipParam.h
//  XWeiBo
//
//  Created by DP on 14/12/4.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWUidParam.h"

@interface XWFriendshipParam : XWUidParam
/** 	false 	string 	需要查询的用户昵称。*/
@property (nonatomic, copy) NSString *screen_name;
/** 	false 	int 	单页返回的记录条数，默认为50，最大不超过200。*/
@property (nonatomic, strong) NSNumber *count;
/** 	false 	int 	返回结果的游标，下一页用返回值里的next_cursor，上一页用previous_cursor，默认为0。*/
@property (nonatomic, strong) NSNumber *cursor;
/** 	false 	int 	返回值中user字段中的status字段开关，0：返回完整status字段、1：status字段仅返回status_id，默认为1。*/
@property (nonatomic, strong) NSNumber *trim_status;

@end

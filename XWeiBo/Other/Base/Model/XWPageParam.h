//
//  XWPageParam.h
//  XWeiBo
//
//  Created by DP on 14/12/4.
//  Copyright (c) 2014年 戴鹏. All rights reserved.
//

#import "XWBaseParam.h"

@interface XWPageParam : XWBaseParam

/**
 false	int64	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
 */
@property (nonatomic, strong) NSNumber *since_id;
/**
 false	int64	若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
 */
@property (nonatomic, strong) NSNumber *max_id;
/**
 false	int	单页返回的记录条数，最大不超过100，默认为20。
 */
@property (nonatomic, strong) NSNumber *count;
/**
 false	int	返回结果的页码，默认为1。
 */
@property (nonatomic, strong) NSNumber *page;

@end

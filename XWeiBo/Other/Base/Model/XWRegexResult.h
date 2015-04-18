//
//  XWRegexResult.h
//  XWeiBo
//
//  Created by DP on 15/4/12.
//  Copyright (c) 2015年 戴鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XWRegexResult : NSObject
// 匹配到的字符串
@property (nonatomic, copy) NSString *string;
// 范围
@property (nonatomic, assign) NSRange range;
//这个结果是否是表情
@property (nonatomic, assign, getter = isEmotion) BOOL emotion;
@end
